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
#' Returns a \code{tibble} in which each row represents a REDCap instrument. The
#' results contains the following fields:
#' - \code{redcap_form_name}, the name of the instrument
#' - \code{redcap_form_label}, the label for the instrument. Only if
#' \code{include_metadata = TRUE}
#' - \code{redcap_data}, the data for the instrument
#' - \code{redcap_metadata}, a \code{tibble} of data dictionary entries for each
#' field in the instrument. Only if \code{include_metadata = TRUE}
#' - \code{redcap_events}, a \code{tibble} with information about the arms and
#' longitudinal events represented in the instrument. Only if the project has
#' longitudinal events enables and \code{include_metadata = TRUE}
#' - \code{structure}, the type of instrument, "repeating" or "nonrepeating"
#' - \code{data_rows}, the number of rows in the instrument's data. Only if
#' \code{include_metadata = TRUE}
#' - \code{data_cols}, the number of columns in the instrument's data. Only if
#' \code{include_metadata = TRUE}
#' - \code{data_size}, the size in memory of the instrument's data computed by
#' \code{lobstr::obj_size}. Only if \code{include_metadata = TRUE}
#' - \code{data_na_pct}, the percentage of cells in the instrument's data that
#' are \code{NA} excluding identifier and form completion fields. Only if
#' \code{include_metadata = TRUE}
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

  # Dissociate primary project id from any instrument
  # primary id will always be first in the metadata
  db_metadata$form_name[[1]] <- NA_character_

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
    # form_name is NA for primary id
    db_metadata <- filter(
      db_metadata,
      .data$form_name %in% forms | is.na(.data$form_name)
    )
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

    if (is_longitudinal) {
      out <- add_event_mapping(out, linked_arms)
    }
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
#' Supplement a supertibble with additional metadata fields
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
#' - \code{redcap_metadata} containing metadata for the fields in each form as a
#' list column
#'
#' @importFrom REDCapR redcap_instruments
#' @importFrom dplyr left_join rename %>% select rename relocate mutate bind_rows
#' filter
#' @importFrom tidyr nest unnest_wider complete fill
#' @importFrom tidyselect everything
#' @importFrom rlang .data
#' @importFrom purrr map
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
  db_metadata <- db_metadata %>%
    # At this stage select_choices_or_calculations has been unpacked into
    # field_name_updated so we can drop it. Likewise, field_name has a subset
    # of info from field_name_updated
    select(!c("field_name", "select_choices_or_calculations")) %>%
    rename(
      field_name = "field_name_updated",
      redcap_form_name = "form_name"
    ) %>%
    relocate("field_name", "field_label", "field_type", .before = everything())

  ## Create a record with the project identifier for each form
  all_forms <- unique(db_metadata$redcap_form_name)
  record_id_field <- get_project_id_field(supertbl$redcap_data[[1]])

  db_metadata <- db_metadata %>%
    # Just the record_id fields
    filter(.data$field_name == record_id_field) %>%
    complete(field_name = record_id_field, redcap_form_name = all_forms) %>%
    # Fill in metadata from first entry
    fill(everything(), .direction = "up") %>%
    # Combine with non-record_id fields
    bind_rows(filter(db_metadata, .data$field_name != record_id_field)) %>%
    filter(!is.na(.data$redcap_form_name))

  # nest by form
  metadata <- nest(db_metadata, redcap_metadata = !"redcap_form_name")

  # Combine ----
  res <- supertbl %>%
    left_join(instrument_labs, by = "redcap_form_name") %>%
    left_join(metadata, by = "redcap_form_name") %>%
    relocate("redcap_form_name", "redcap_form_label", "redcap_data",
             "redcap_metadata", "structure")

  # Add summary stats ----
  res %>%
    mutate(summary = map(.data$redcap_data, calc_metadata_stats)) %>%
    unnest_wider(summary)
}

#' @title
#' Supplement a supertibble from a longitudinal database with information about
#' the events associated with each instrument
#'
#' @param supertbl a supertibble object to supplement with metadata
#' @param linked_arms the tibble with event mappings created by
#' \code{link_arms()}
#'
#' @importFrom rlang .data
#' @importFrom dplyr select left_join relocate
#' @importFrom tidyr nest
#'
#' @return
#' The original supertibble with an events \code{redcap_events} list column
#' containing arms and events associated with each instrument
#'
#' @keywords internal
#'
add_event_mapping <- function(supertbl, linked_arms) {
  event_info <- linked_arms %>%
    add_partial_keys(.data$unique_event_name) %>%
    select(redcap_form_name = "form", "redcap_event", "redcap_arm", "arm_name") %>%
    nest(redcap_events = !"redcap_form_name")

  left_join(supertbl, event_info, by = "redcap_form_name") %>%
    relocate("redcap_events", .after = "redcap_metadata")
}

#' @title
#' Utility function to calculate summary for each tibble in a supertibble
#'
#' @param data a tibble of redcap data stored in the \code{redcap_data} column
#' of a supertibble
#'
#' @importFrom dplyr select
#' @importFrom tidyselect any_of
#' @importFrom lobstr obj_size
#'
#' @return
#' A list containing:
#' - \code{data_rows}, the number of rows in the data
#' - \code{data_cols}, the number of columns in the data
#' - \code{data_size}, the size of the data in bytes
#' - \code{data_na_pct}, the percentage of cells that are NA excluding
#' identifiers and form completion fields
#'
#' @keywords internal
#'
calc_metadata_stats <- function(data) {

  excluded_fields <- c(
    get_project_id_field(data),
    "redcap_repeat_instance", "redcap_event",
    "redcap_arm", "form_status_complete"
  )

  na_pct <- data %>%
    # drop cols to exclude from NA calc
    select(!any_of(excluded_fields)) %>%
    is.na() %>%
    mean()

  list(
    data_rows = nrow(data), data_cols = ncol(data),
    data_size = obj_size(data), data_na_pct = na_pct
  )
}
