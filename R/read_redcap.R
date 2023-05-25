#' @title
#' Import a REDCap database into a tidy supertibble
#'
#' @description
#' Query the REDCap API to retrieve data and metadata about a project,
#' and transform the output into a "supertibble" that contains data
#' and metadata organized into tibbles, broken down by instrument.
#'
#' @details
#' This function uses the [REDCapR](https://ouhscbbmc.github.io/REDCapR/index.html)
#' package to query the REDCap API. The REDCap API returns a
#' [block matrix](https://en.wikipedia.org/wiki/Block_matrix) that mashes
#' data from all data collection instruments
#' together. The `read_redcap()` function
#' deconstructs the block matrix and splices the data into individual tibbles,
#' where one tibble represents the data from one instrument.
#'
#' @return
#' A `tibble` in which each row represents a REDCap instrument. It
#' contains the following columns:
#' * `redcap_form_name`, the name of the instrument
#' * `redcap_form_label`, the label for the instrument
#' * `redcap_data`, a tibble with the data for the instrument
#' * `redcap_metadata`, a tibble of data dictionary entries for each field in the instrument
#' * `redcap_events`, a tibble with information about the arms and longitudinal events represented in the instrument.
#'    Only if the project has longitudinal events enabled
#' * `structure`, the instrument structure, either "repeating" or "nonrepeating"
#' * `data_rows`, the number of rows in the instrument's data tibble
#' * `data_cols`, the number of columns in the instrument's data tibble
#' * `data_size`, the size in memory of the instrument's data tibble computed by `lobstr::obj_size()`
#' * `data_na_pct`, the percentage of cells in the instrument's data columns that are `NA` excluding identifier and
#'    form completion columns
#'
#' @importFrom REDCapR redcap_read_oneshot redcap_metadata_read
#' @importFrom dplyr filter bind_rows %>% select slice
#' @importFrom tidyselect any_of
#' @importFrom rlang .data try_fetch abort current_call
#' @importFrom cli cli_abort
#'
#' @param redcap_uri The
#' URI/URL of the REDCap server (e.g.,
#' "https://server.org/apps/redcap/api/"). Required.
#' @param token The user-specific string that serves as the password for a
#' project. Required.
#' @param raw_or_label A string (either 'raw' or 'label') that specifies whether
#' to export the raw coded values or the labels for the options of categorical
#' fields. Default is 'label'.
#' @param forms A character vector of REDCap instrument names that specifies
#' which instruments to import. Default is `NULL` which imports all instruments
#' in the project.
#' @param export_survey_fields A logical that specifies whether to export the
#' survey identifier and timestamp fields if available. The default, `NULL`,
#' tries to determine if survey fields exist and returns them as though `TRUE`.
#' @param export_data_access_groups A boolean value that specifies whether or
#' not to export the `redcap_data_access_group` field when data access groups are
#' utilized in the project. The default, `NULL`, tries to determine if data
#' access group fields exist and returns them as though `TRUE`.
#' @param suppress_redcapr_messages A logical to control whether to suppress messages
#' from REDCapR API calls. Default `TRUE`.
#' @param guess_max A positive [base::numeric] value
#' passed to [readr::read_csv()] that specifies the maximum number of records to
#' use for guessing column types. Default `.Machine$integer.max`.
#'
#' @examples
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' read_redcap(
#'   redcap_uri,
#'   token,
#'   raw_or_label = "label"
#' )
#' }
#'
#' @export

read_redcap <- function(redcap_uri,
                        token,
                        raw_or_label = "label",
                        forms = NULL,
                        export_survey_fields = NULL,
                        export_data_access_groups = NULL,
                        suppress_redcapr_messages = TRUE,
                        guess_max = .Machine$integer.max) {
  check_arg_is_character(redcap_uri, len = 1, any.missing = FALSE)
  check_arg_is_character(token, len = 1, any.missing = FALSE)
  check_arg_is_valid_token(token)
  check_arg_choices(raw_or_label, choices = c("label", "raw"))
  check_arg_is_character(forms, min.len = 1, null.ok = TRUE, any.missing = FALSE)
  check_arg_is_logical(export_survey_fields, len = 1, any.missing = FALSE, null.ok = TRUE)
  check_arg_is_logical(export_data_access_groups, len = 1, any.missing = FALSE, null.ok = TRUE)
  check_arg_is_logical(suppress_redcapr_messages, len = 1, any.missing = FALSE)

  # Load REDCap Metadata ----
  # Capture unexpected metadata API call errors
  db_metadata <- try_redcapr({
    redcap_metadata_read(
      redcap_uri = redcap_uri,
      token = token,
      verbose = !suppress_redcapr_messages
    )
  })

  db_metadata <- db_metadata %>%
    filter(.data$field_type != "descriptive")

  # Cache unedited db_metadata to reduce dependencies on the order of edits
  db_metadata_orig <- db_metadata

  # Retrieve initial instrument/form_name order for preservation later
  form_name_order <- db_metadata_orig %>%
    pull("form_name") %>%
    unique()

  # Dissociate primary project id from any instrument
  # primary id will always be first in the metadata
  db_metadata$form_name[[1]] <- NA_character_

  # The user may not have requested instrument with identifiers. We need to
  # make sure identifiers are kept regardless. This requires adding the
  # instrument with identifiers to our redcap_read_oneshot call but filtering
  # out extra, non-identifier fields in that instrument

  # Set default instruments for API call
  forms_for_api_call <- forms
  api_call_edited <- FALSE

  # Filter metadata if `forms` parameter was used
  if (!is.null(forms)) {
    check_forms_exist(db_metadata, forms)

    # Update forms for API call

    # Get name of first instrument from unedited metadata
    id_form <- db_metadata_orig$form_name[[1]]

    if (id_form %in% forms) {
      # If instrument with identifiers was already requested:
      # Use forms for API call
      forms_for_api_call <- forms

      # and no need to drop any fields
      extra_fields_to_drop <- NULL
    } else {
      # If instrument with identifiers was not requested:
      # Add it to the API call
      forms_for_api_call <- c(id_form, forms)

      # Store the extra fields we need to drop
      extra_fields_to_drop <- get_fields_to_drop(db_metadata, id_form)

      api_call_edited <- TRUE
    }

    # Keep only user-requested instruments in the metadata
    # form_name is NA for primary id
    db_metadata <- filter(
      db_metadata,
      .data$form_name %in% forms | is.na(.data$form_name)
    )
  }

  # Determine fields to pass to REDCapR ----
  # Enforce NULL opinionated checks for select arguments supplied:
  # - export_data_access_groups
  # - export_survey_fields

  export_data_access_groups_original <- export_data_access_groups
  export_data_access_groups <- ifelse(is.null(export_data_access_groups), TRUE, export_data_access_groups)

  export_survey_fields_original <- export_survey_fields
  export_survey_fields <- ifelse(is.null(export_survey_fields), TRUE, export_survey_fields)

  # Load REDCap Dataset output ----

  db_data <- try_redcapr({
    redcap_read_oneshot(
      redcap_uri = redcap_uri,
      token = token,
      forms = forms_for_api_call,
      export_survey_fields = export_survey_fields,
      export_data_access_groups = export_data_access_groups,
      verbose = !suppress_redcapr_messages,
      guess_max = guess_max
    )
  })

  # Check that results were returned
  check_redcap_populated(db_data)

  # Check that requested args exist
  if (!is.null(export_data_access_groups_original)) {
    if (export_data_access_groups_original) {
      check_data_arg_exists(db_data,
                            col = "redcap_data_access_group",
                            arg = "export_data_access_groups")
    }
  }

  if (!is.null(export_survey_fields_original)) {
    if (export_survey_fields_original) {
      check_data_arg_exists(db_data,
                            col = "redcap_survey_identifier",
                            arg = "export_survey_fields")
    }
  }

  # Apply database output changes ----
  # Apply checkbox appending functions to metadata
  db_metadata <- update_field_names(db_metadata)
  # Note: Order of functions calls between `update_*` matters
  if ("checkbox" %in% db_metadata$field_type) {
    db_data <- update_data_col_names(db_data, db_metadata)
  }

  # If we edited the redcap_read_oneshot API call to get the first instrument
  # then do some cleanup
  if (api_call_edited) {
    # Drop any extra fields that may have been added because we added extra
    # instruments to the API call
    # This assumes the names of checkbox fields in the data have been updated by
    # update_data_col_names
    db_data <- select(db_data, !any_of(extra_fields_to_drop))

    # Drop repeating instrument rows that may be associated with extra instrument
    if ("redcap_repeat_instrument" %in% colnames(db_data)) {
      db_data <- db_data %>%
        filter(
          .data$redcap_repeat_instrument %in% forms |
            is.na(.data$redcap_repeat_instrument)
        )

      # Drop repeating fields if there are no remaining repeating instruments
      # or repeat instances
      if (all(is.na(db_data$redcap_repeat_instrument) & is.na(db_data$redcap_repeat_instance))) {
        db_data <- db_data %>%
          select(-"redcap_repeat_instrument", -"redcap_repeat_instance")
      }
    }
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
    linked_arms <- link_arms(
      redcap_uri = redcap_uri, token = token,
      suppress_redcapr_messages = suppress_redcapr_messages
    )

    out <- clean_redcap_long(
      db_data_long = db_data,
      db_metadata_long = db_metadata,
      linked_arms = linked_arms
    )
  } else {
    out <- clean_redcap(
      db_data = db_data,
      db_metadata = db_metadata
    )
  }

  # Augment with metadata ----
  out <- add_metadata(out, db_metadata, redcap_uri, token, suppress_redcapr_messages)

  if (is_longitudinal) {
    out <- add_event_mapping(out, linked_arms)
  }

  out <- out %>%
    dplyr::slice(
      order(
        factor(
          .data$redcap_form_name,
          levels = form_name_order
        )
      )
    )

  as_supertbl(out)
}

#' @title
#' Determine fields included in \code{REDCapR::redcap_read_oneshot} output
#' that should be dropped from results of \code{read_redcap}
#'
#' @details
#' This function applies rules to determine which fields are included in the
#' results of \code{REDCapR::redcap_read_oneshot} because the user didn't
#' request the instrument containing identifiers
#'
#' @param db_metadata metadata tibble created by
#' \code{REDCapR::redcap_metadata_read}
#' @param form the name of the instrument containing identifiers
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
  # Assume the first instrument in the metadata contains IDs
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
  # read_redcap output

  res <- c(res, paste0(form, "_complete"))

  res
}

#' @title
#' Supplement a supertibble with additional metadata fields
#'
#' @param supertbl a supertibble object to supplement with metadata
#' @param db_metadata a REDCap metadata tibble
#' @param suppress_redcapr_messages A logical to control whether to suppress messages
#' from REDCapR API calls. Default `TRUE`.
#' @inheritParams read_redcap
#'
#' @details This function assumes that \code{db_metadata} has been processed to
#' include a row for each option of each multiselection field, i.e. with
#' \code{update_field_names()}
#'
#' @return
#' The original supertibble with additional fields:
#' - \code{instrument_label} containing labels for each instrument
#' - \code{redcap_metadata} containing metadata for the fields in each
#' instrument as a list column
#'
#' @importFrom REDCapR redcap_instruments
#' @importFrom dplyr left_join rename %>% select rename relocate mutate
#' bind_rows filter
#' @importFrom tidyr nest unnest_wider complete fill
#' @importFrom tidyselect everything
#' @importFrom rlang .data caller_env
#' @importFrom purrr map
#'
#' @keywords internal

add_metadata <- function(supertbl, db_metadata, redcap_uri, token, suppress_redcapr_messages) {
  # Get instrument labels ----
  instrument_labs <- try_redcapr(
    {
      redcap_instruments(
        redcap_uri,
        token,
        verbose = !suppress_redcapr_messages
      )
    },
    call = caller_env()
  ) %>%
    rename(
      redcap_form_label = "instrument_label",
      redcap_form_name = "instrument_name"
    )

  # Process metadata ----
  db_metadata <- db_metadata %>%
    # remove field_name since it has been unpacked into field_name_updated
    # via update_field_names()
    select(!"field_name") %>%
    rename(
      field_name = "field_name_updated",
      redcap_form_name = "form_name"
    ) %>%
    relocate("field_name", "field_label", "field_type", .before = everything())

  ## Create a record with the project identifier for each instrument
  all_forms <- unique(db_metadata$redcap_form_name)
  record_id_field <- get_record_id_field(supertbl$redcap_data[[1]])

  db_metadata <- db_metadata %>%
    # Just the record_id fields
    filter(.data$field_name == record_id_field) %>%
    complete(field_name = record_id_field, redcap_form_name = all_forms) %>%
    # Fill in metadata from first entry
    fill(everything(), .direction = "up") %>%
    # Combine with non-record_id fields
    bind_rows(filter(db_metadata, .data$field_name != record_id_field)) %>%
    filter(!is.na(.data$redcap_form_name))

  # nest by instrument
  metadata <- nest(db_metadata, redcap_metadata = !"redcap_form_name")

  # Combine ----
  res <- supertbl %>%
    left_join(instrument_labs, by = "redcap_form_name") %>%
    left_join(metadata, by = "redcap_form_name") %>%
    relocate(
      "redcap_form_name", "redcap_form_label", "redcap_data",
      "redcap_metadata", "structure"
    )

  # Add summary stats ----
  res %>%
    mutate(summary = map(.data$redcap_data, calc_metadata_stats)) %>%
    unnest_wider(summary) %>%
    relocate(
      "redcap_form_name", "redcap_form_label", "redcap_data", "redcap_metadata",
      "structure", "data_rows", "data_cols", "data_size", "data_na_pct"
    )
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
    select(
      redcap_form_name = "form", "redcap_event", "redcap_arm", "arm_name"
    ) %>%
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
#' @importFrom formattable percent
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
    get_record_id_field(data),
    "redcap_form_instance", "redcap_event_instance", "redcap_event",
    "redcap_arm", "form_status_complete"
  )

  na_pct <- data %>%
    # drop cols to exclude from NA calc
    select(!any_of(excluded_fields)) %>%
    is.na() %>%
    mean()

  list(
    data_rows = nrow(data), data_cols = ncol(data),
    data_size = obj_size(data),
    data_na_pct = percent(na_pct, digits = 2, format = "fg")
  )
}

#' @title
#' Add supertbl S3 class
#'
#' @param x an object to class
#'
#' @return
#' The object with `redcaptidier_supertbl` S3 class
#'
#' @keywords internal
#'
as_supertbl <- function(x) {
  class(x) <- c("redcap_supertbl", class(x))
  x
}
