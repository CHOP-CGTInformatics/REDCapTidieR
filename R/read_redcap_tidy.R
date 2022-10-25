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
#' @param include_metadata Optionally include metadata columns in the result.
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
                             suppress_messages = TRUE,
                             include_metadata = TRUE) {

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

  # Filter metadata if forms parameter was used
  if (!is.null(forms)) {
    check_forms_exist(db_metadata, forms)

    # Update forms for API call
    id_form <- db_metadata$form_name[[1]]

    if (id_form %in% forms) {
      # If form with identifiers was already requested:
      # Use forms for API call
      forms_for_api_call <- forms

      # and no need to drop any fields
      extra_fields_to_drop <- NULL
    } else {
      # If form with identifiers was not requested:
      # Add it to the API call
      forms_for_api_call <- c(id_form, forms)

      # Store the extra fields we need to drop
      extra_fields_to_drop <- get_fields_to_drop(db_metadata, id_form)
    }

    # Keep only user requested forms in the metadata
    db_metadata <- filter(db_metadata, .data$form_name %in% forms)
  }

  # Load REDCap Dataset output ----

  db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                 token = token,
                                 forms = forms_for_api_call,
                                 verbose = FALSE)$data

  # Check that results were returned
  check_redcap_populated(db_data)

  # Apply database output changes ----
  # Apply checkbox appending functions to metadata
  db_metadata <- update_field_names(db_metadata)
  # Note: Order of functions calls between `update_*` matters
  if ("checkbox" %in% db_metadata$field_type) {
    db_data <- update_data_col_names(db_data, db_metadata)
  }

  # Drop any extra fields that may have been added because we added extra forms
  # to the API call
  # This assumes the names of checkbox fields in the data have been updated by
  # update_data_col_names
  if (!is.null(forms)) {
    db_data <- select(db_data, !any_of(extra_fields_to_drop))
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
    linked_arms <- link_arms(redcap_uri = redcap_uri, token = token)

    out <- clean_redcap_long(db_data_long = db_data,
                             db_metadata_long = db_metadata,
                             linked_arms = linked_arms)
  } else {
    out <- clean_redcap(db_data = db_data,
                        db_metadata = db_metadata)
  }

  # Augment with metadata ----
  if (include_metadata) {
    out <- add_metadata(out, db_metadata, redcap_uri, token)
  }

  out
}

#' @title
#' Determine fields included in \code{REDCapR::redcap_read_oneshot} output
#' that should be dropped from results of \code{read_redcap_tidy}
#'
#' @details
#' This function applies rules to determine which fields are included in the
#' results of \code{REDCapR::redcap_read_oneshot} because the user didn't
#' request the form containing identifiers
#'
#' @param db_metadata metadata tibble created by \code{REDCapR::redcap_metadata_read}
#' @param form the name of the form containing identifiers
#'
#' @return
#' A character vector of extra field names that can be used to filter the
#' results of \code{REDCapR::redcap_read_oneshot}
#'
#' @importFrom dplyr filter pull %>%
#' @importFrom rlang .data
#'
#' @keywords internal
get_fields_to_drop <- function(db_metadata, form) {
  # Assume the first form in the metadata contains IDs
  # REDCap enforces this constraints
  record_id_field <- db_metadata$field_name[[1]]

  res <- db_metadata %>%
    filter(.data$form_name == form) %>%
    # Add checkbox field names to metadata
    update_field_names() %>%
    pull(.data$field_name_updated)

  # Remove identifier since we want to keep it
  res <- setdiff(res, record_id_field)

  # Add form complete field which is not in metadata but should be removed from
  # read_redcap_tidy output

  res <- c(res, paste0(form, "_complete"))

  res
}

#' @title
#' Supplement a supertibble with addtional metadata fields
#'
#' @param supertbl a supertibble object to supplement with metadata
#' @param db_metadata a REDCap metadata tibble
#' @inheritParams read_redcap_tidy
#'
#' @details This function assumes that \code{db_metadata} has been processed to
#' include a row for each option of each multiselection field, i.e. with
#' \code{update_field_names()}
#'
#' @return
#' The original supertibble with additional fields:
#' - \code{instrument_label} containing labels for each form
#' - \code{metadata} containing metadata for the fields in each form as a
#' list column
#' - \code{events} containing information about the events and arms represented
#' in each form. Longitudinal REDCaps pnly.
#'
#' @importFrom REDCapR redcap_instruments
#' @importFrom dplyr left_join rename %>% select rename relocate
#' @importFrom tidyr nest
#' @importFrom tidyselect everything
#'
#' @keywords internal

add_metadata <- function(supertbl, db_metadata, redcap_uri, token) {

  # Get instrument labels ----
  instrument_labs <- redcap_instruments(
    redcap_uri,
    token,
    verbose = FALSE
  )$data %>%
    rename(
      redcap_form_label = "instrument_label",
      redcap_form_name = "instrument_name"
    )

  # Process metadata ----
  metadata <- db_metadata %>%
    # At this stage select_choices_or_calculations has been unpacked into
    # field_name_updated so we can drop it. Likewise, field_name has a subset
    # of info from field_name_updated
    select(!c("field_name", "select_choices_or_calculations")) %>%
    rename(
      # TODO: consider changing this name upstream in update_field_names
      field_name = "field_name_updated",
      redcap_form_name = "form_name"
    ) %>%
    # TODO: Consider adding form completion fields to metadata
    relocate("field_name", "field_label", "field_type", .before = everything()) %>%
    # nest by form
    nest(metadata = !"redcap_form_name")

  # Combine ----
  supertbl %>%
    left_join(instrument_labs, by = "redcap_form_name") %>%
    left_join(metadata, by = "redcap_form_name")

  # TODO: add event/arm with:
  # arm id
  # arm name
  # event id
  # event name -- would need call to API w/ event method
}
