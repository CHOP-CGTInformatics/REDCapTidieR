#' @title
#' Extract non-longitudinal REDCap databases into tidy tibbles
#'
#' @description
#' Helper function internal to \code{read_redcap} responsible for
#' extraction and final processing of a tidy \code{tibble} to the user from
#' a non-longitudinal REDCap database.
#'
#' @param db_data The REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#'
#' @return
#' Returns a \code{tibble} with list elements containing tidy dataframes. Users
#' can access dataframes under the \code{redcap_data} column with reference to
#' \code{form_name} and \code{structure} column details.
#'
#' @importFrom
#' checkmate assert_data_frame expect_logical expect_factor expect_character
#' expect_double
#' @importFrom dplyr filter pull
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom rlang .data
#'
#' @keywords internal

clean_redcap <- function(db_data,
                         db_metadata) {
  # Apply checkmate checks ---
  assert_data_frame(db_data)
  assert_data_frame(db_metadata)

  # Repeating Instrument Check ----
  # Check if database supplied contains any repeating instruments to map onto `
  # redcap_repeat_*` variables

  has_repeat_forms <- "redcap_repeat_instance" %in% names(db_data)

  ## Repeating Instruments Logic ----
  if (has_repeat_forms) {
    repeated_forms <- db_data %>%
      filter(!is.na(.data$redcap_repeat_instrument)) %>%
      pull(.data$redcap_repeat_instrument) %>%
      unique()

    repeated_forms_tibble <- tibble(
      redcap_form_name = repeated_forms,
      redcap_data = map(
        repeated_forms,
        ~ distill_repeat_table(
          .x, db_data,
          db_metadata
        )
      ),
      structure = "repeating"
    )
  }

  ## Nonrepeating Instruments Logic ----
  nonrepeated_forms <- db_metadata %>%
    filter(!is.na(.data$form_name)) %>%
    pull(.data$form_name) %>%
    unique()

  if (has_repeat_forms) {
    nonrepeated_forms <- setdiff(
      nonrepeated_forms,
      repeated_forms
    )
  }

  nonrepeated_forms_tibble <- tibble(
    redcap_form_name = nonrepeated_forms,
    redcap_data = map(
      nonrepeated_forms,
      ~ distill_nonrepeat_table(
        .x,
        db_data,
        db_metadata
      )
    ),
    structure = "nonrepeating"
  )

  if (has_repeat_forms) {
    rbind(repeated_forms_tibble, nonrepeated_forms_tibble)
  } else {
    nonrepeated_forms_tibble
  }
}

#' @title
#' Extract non-repeat tables from non-longitudinal REDCap databases
#'
#' @description
#' Sub-helper function to \code{clean_redcap} for single nonrepeat table
#' extraction.
#'
#' @return
#' A subset \code{tibble} of all data related to a specified \code{form_name}
#'
#' @param form_name The \code{form_name} described in the named column from the
#' REDCap metadata.
#' @param db_data The REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#'
#' @importFrom dplyr filter pull select relocate rename
#' @importFrom tidyselect all_of everything starts_with any_of
#' @importFrom tibble tibble
#' @importFrom rlang .data
#'
#' @keywords internal

distill_nonrepeat_table <- function(form_name,
                                    db_data,
                                    db_metadata) {
  # Repeating Instrument Check ----
  # Check if database supplied contains any repeating instruments to map onto
  # `redcap_repeat_*` variables
  has_repeat_forms <- "redcap_form_instance" %in% names(db_data)

  my_record_id <- names(db_data)[1]
  my_form <- form_name

  my_fields <- db_metadata %>%
    filter(.data$form_name == my_form) %>%
    pull(.data$field_name_updated)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, my_fields)
  }

  # Below necessary to remove descriptive text fields
  # and to add column to indicate that instrument is completed
  my_fields <- db_data %>%
    select(
      all_of(my_fields),
      any_of(paste0(my_form, "_timestamp")),
      paste0(my_form, "_complete")
    ) %>%
    names()

  # For forms containing surveys, also pull redcap_survey_identifier
  if (paste0(my_form, "_timestamp") %in% my_fields) {
    my_fields <- c(my_fields, "redcap_survey_identifier")
  }

  if ("redcap_repeat_instance" %in% names(db_data)) {
    db_data <- db_data %>%
      filter(is.na(.data$redcap_repeat_instance))
  }

  out <- db_data %>%
    add_partial_keys() %>%
    select(
      all_of(my_fields), any_of(c("redcap_event", "redcap_arm", "redcap_form_instance", "redcap_event_instance"))
    ) %>%
    relocate(
      any_of(c("redcap_event", "redcap_arm", "redcap_form_instance", "redcap_event_instance")),
      .after = my_record_id) %>%
    rename("redcap_survey_timestamp" = any_of(paste0(my_form, "_timestamp"))) %>%
    relocate(any_of("redcap_survey_timestamp"), .after = everything()) %>%
    rename("form_status_complete" = paste0(my_form, "_complete")) %>%
    relocate("form_status_complete", .after = everything()) %>%
    tibble()

  # Remove redcap_form_instance if necessary
  if (has_repeat_forms) {
    if (all(is.na(out$redcap_form_instance))) {
      out <- out %>%
        select(-"redcap_form_instance")
    }
  }

  out
}

#' @title
#' Extract repeat tables from non-longitudinal REDCap databases
#'
#' @description
#' Sub-helper function to \code{clean_redcap} for single repeat table
#' extraction.
#'
#' @return
#' A subset \code{tibble} of all data related to a specified \code{form_name}
#'
#' @param form_name The \code{form_name} described in the named column from the
#' REDCap metadata.
#' @param db_data The non-longitudinal REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The non-longitudinal REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#'
#' @importFrom dplyr filter pull select relocate rename
#' @importFrom tidyselect all_of everything starts_with any_of
#' @importFrom tibble tibble
#' @importFrom rlang .data
#'
#' @keywords internal

distill_repeat_table <- function(form_name,
                                 db_data,
                                 db_metadata) {
  my_record_id <- names(db_data)[1]
  my_form <- form_name

  my_fields <- db_metadata %>%
    filter(.data$form_name == my_form) %>%
    pull(.data$field_name_updated)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, my_fields)
  }

  # Below necessary to remove descriptive text fields
  # and to add column to indicate that instrument is completed
  my_fields <- db_data %>%
    select(
      all_of(my_fields),
      any_of(paste0(my_form, "_timestamp")),
      paste0(my_form, "_complete")
    ) %>%
    names()

  # For forms containing surveys, also pull redcap_survey_identifier
  if (paste0(my_form, "_timestamp") %in% my_fields) {
    my_fields <- c(my_fields, "redcap_survey_identifier")
  }

  db_data %>%
    add_partial_keys() %>%
    filter(
      !is.na(.data$redcap_form_instance) &
        .data$redcap_repeat_instrument == my_form
    ) %>%
    select(all_of(my_fields), "redcap_form_instance") %>%
    relocate("redcap_form_instance", .after = all_of(my_record_id)) %>%
    rename("redcap_survey_timestamp" = any_of(paste0(my_form, "_timestamp"))) %>%
    relocate(any_of("redcap_survey_timestamp"), .after = everything()) %>%
    rename("form_status_complete" = paste0(my_form, "_complete")) %>%
    relocate("form_status_complete", .after = everything()) %>%
    tibble()
}
