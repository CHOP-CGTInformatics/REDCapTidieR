#' @title
#' Extract a REDCap database into a tidy supertibble
#'
#' @description
#' Call the REDCap API to retrieve data and metadata about a project,
#' and then transform the output into a tidy "supertibble" that contains tidy
#' tibbles, where each tibble represents a single instrument.
#'
#' @details
#' This function uses [REDCapR](https://ouhscbbmc.github.io/REDCapR)
#' to call the REDCap API. The REDCap API returns
#' a [block matrix](https://en.wikipedia.org/wiki/Block_matrix) that mashes
#' data from all data collection instruments
#' together. In complex databases, such as those that contain repeated
#' instruments, this is unwieldy. The `read_redcap_tidy` function intelligently
#' deconvolutes the block matrix and splices the data into individual tibbles,
#' where one tibble represents the data from one instrument.
#'
#' @return
#' Returns a \code{tibble} in which each row represents a REDCap instrument.
#'
#' @importFrom REDCapR redcap_read_oneshot redcap_metadata_read
#' @importFrom dplyr filter bind_rows %>% select
#' @importFrom tidyselect any_of
#' @importFrom rlang .data
#'
#' @param redcap_uri The
#' URI/URL of the REDCap server (e.g.,
#' "https://server.org/apps/redcap/api/"). Required.
#' @param token The user-specific string that serves as the password for a
#' project. Required.
#' @param raw_or_label A string (either 'raw' or 'label') that specifies whether
#' to export the raw coded values or the labels for the options of multiple
#' choice fields. Default is 'label'.
#' @param forms A character vector of form names that specifies the forms to
#' export. Default returns all forms in the project.
#' @param suppress_messages Optionally show or suppress messages.
#' Default \code{TRUE}.
#'
#' @examples
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' read_redcap_tidy(
#'    redcap_uri,
#'    token,
#'    raw_or_label = "label"
#'  )
#' }
#'
#' @export

read_redcap_tidy <- function(redcap_uri,
                             token,
                             raw_or_label = "label",
                             forms = NULL,
                             suppress_messages = TRUE) {

  # Load REDCap Metadata ----
  db_metadata <- redcap_metadata_read(redcap_uri = redcap_uri,
                                      token = token,
                                      verbose = FALSE)$data %>%
    filter(.data$field_type != "descriptive")

  # The user may not have requested form with identifiers. We need to make sure
  # identifiers are kept regardless. This requires adding the form with
  # identifiers to our redcap_read_oneshot call but filtering out extra,
  # non-identifier fields in that form

  # Set default forms for API call
  forms_for_api_call <- forms
  # Capture fields we need to keep in the output
  fields_to_keep <- get_output_fields(db_metadata, forms)

  # Filter metadata if forms parameter was used
  if (!is.null(forms)) {
    check_forms_exist(db_metadata, forms)

    # Update forms for API call
    id_form <- db_metadata$form_name[[1]]

    forms_for_api_call <- unique(c(id_form, forms))

    # Keep only user requested forms in the metadata
    db_metadata <- filter(db_metadata, .data$form_name %in% forms)
  }

  # Load REDCap Dataset output ----

  db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                 token = token,
                                 forms = forms_for_api_call,
                                 verbose = FALSE)$data %>%
    select(any_of(fields_to_keep))

  # Check that results were returned
  check_redcap_populated(db_data)

  # Apply database output changes ----
  # Apply checkbox appending functions to metadata
  db_metadata <- update_field_names(db_metadata)
  # Note: Order of functions calls between `update_*` matters
  if ("checkbox" %in% db_metadata$field_type) {
    db_data <- update_data_col_names(db_data, db_metadata)
  }

  # Check for potential API rights issues ----
  # If any missing field names detected in metadata output, run the following
  # resulting in metadata with missing data removed and warn user of action
  if (any(!db_metadata$field_name_updated %in% names(db_data))) {
    check_user_rights(db_data, db_metadata)
    # Default behavior: Remove missing field names to prevent crash
    db_metadata <- db_metadata %>%
      filter(.data$field_name_updated %in% names(db_data))
  }

  if (raw_or_label == "label") {
    db_data <- multi_choice_to_labels(db_data, db_metadata)
  }

  # Longitudinal Arms Check and Cleaning Application ----
  # Check if database supplied is longitudinal to determine appropriate function
  # to use
  is_longitudinal <- if ("redcap_event_name" %in% names(db_data)) {
    TRUE
  } else {
    FALSE
  }

  if (is_longitudinal) {
    linked_arms <- link_arms(db_data_long = db_data,
                             db_metadata_long = db_metadata,
                             redcap_uri = redcap_uri,
                             token = token)

    out <- clean_redcap_long(db_data_long = db_data,
                             db_metadata_long = db_metadata,
                             linked_arms = linked_arms)
  } else {
    out <- clean_redcap(db_data = db_data,
                        db_metadata = db_metadata)
  }

  out
}

#' @title
#' Determine the maximal set of fields to keep in the result of read_redcap_tidy
#'
#' @details
#' This function applies rules to determine which fields are kept in the results
#' of calling \code{REDCapR::redcap_read_oneshot}.
#'
#' @param db_metadata metadata tibble created by \code{REDCapR::redcap_metadata_read}
#' @param forms \code{forms} argument passed to \code{read_redcap_tidy}
#'
#' @return
#' A character vector fo field names that can be used to filter the results of
#' \code{REDCapR::redcap_read_oneshot}
#'
#' @keywords internal
get_output_fields <- function(db_metadata, forms) {
  # If forms was NULL we want all forms in the metadata
  if (is.null(forms)) {
    forms <- unique(db_metadata$form_name)
  }

  # Assume the first form in the metadata contains IDs
  # REDCap enforces this constraints
  record_id_field <- db_metadata$field_name[[1]]

  id_fields <- c(record_id_field, "redcap_event_name",
                 "redcap_repeat_instrument", "redcap_repeat_instance")

  # 1. Fields in requested forms
  res <- with(db_metadata, field_name[form_name %in% forms])
  # 2. ID fields
  res <- unique(c(id_fields, res))
  # 3. Completion fields in requested forms (these aren't in metadata)
  res <- c(res, paste0(forms, "_complete"))

  res
}
