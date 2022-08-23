#' Extract non-Longitudinal REDCap Databases into Tidy Tibbles
#'
#' @param db_data The REDCap database output defined by \code{REDCapR::reedcap_read_oneshot()$data}
#' @param db_metadata The REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#'
#' @import dplyr purrr REDCapR checkmate
#' @importFrom rlang .data
#' @keywords internal

clean_redcap <- function(
    db_data,
    db_metadata
){

  # Apply checkmate checks ---
  assert_data_frame(db_data)
  assert_data_frame(db_metadata)

  repeated_forms <- db_data %>%
    filter(!is.na(.data$redcap_repeat_instrument)) %>%
    pull(.data$redcap_repeat_instrument) %>%
    unique()

  repeated_forms_tibble <- tibble(
    redcap_form_name = repeated_forms,
    redcap_data = map(
      repeated_forms,
      ~ extract_repeat_table(.x, db_data, db_metadata)
    ),
    structure = "repeating"
  )

  nonrepeated_forms <- db_metadata %>%
    pull(.data$form_name) %>%
    unique() %>%
    setdiff(repeated_forms)

  nonrepeated_forms_tibble <- tibble(
    redcap_form_name = nonrepeated_forms,
    redcap_data = map(
      nonrepeated_forms,
      ~ extract_nonrepeat_table(.x, db_data, db_metadata)
    ),
    structure = "nonrepeating"
  )

  clean_redcap_output <- rbind(repeated_forms_tibble, nonrepeated_forms_tibble)

  clean_redcap_output
}

#' Extract Non-Repeat Tables from non-Longitudinal REDCap Databases
#'
#' @param form_name The \code{form_name} described in the named column from the REDCap metadata.
#' @param db_data The REDCap database output defined by \code{REDCapR::reedcap_read_oneshot()$data}
#' @param db_metadata The REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#'
#' @import dplyr REDCapR
#' @importFrom rlang .data
#' @keywords internal

extract_nonrepeat_table <- function(
    form_name,
    db_data,
    db_metadata
){
  my_record_id <- names(db_data)[1]
  my_form <- form_name

  my_fields <- db_metadata %>%
    filter(.data$form_name == my_form) %>%
    pull(.data$field_name_updated)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, my_fields)
  }

  # Below necessary to remove descriptive text fields
  # and to add column to indicate that form is completed
  my_fields <- db_data %>%
    select(starts_with(my_fields), paste0(my_form, "_complete")) %>%
    names()

  db_data %>%
    filter(is.na(.data$redcap_repeat_instance)) %>%
    select(all_of(my_fields)) %>%
    rename("form_status_complete" = paste0(my_form, "_complete")) %>%
    relocate(.data$form_status_complete, .after = everything()) %>%
    tibble()
}

#' Extract Repeat Tables from non-Longitudinal REDCap Databases
#'
#' @param form_name The \code{form_name} described in the named column from the REDCap metadata.
#' @param db_data The non-longitudinal REDCap database output defined by \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The non-longitudinal REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#'
#' @import dplyr REDCapR
#' @importFrom rlang .data
#' @keywords internal

extract_repeat_table <- function(
    form_name,
    db_data,
    db_metadata
){
  my_record_id <- names(db_data)[1]
  my_form <- form_name

  my_fields <- db_metadata %>%
    filter(.data$form_name == my_form) %>%
    pull(.data$field_name_updated)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, my_fields)
  }

  # Below necessary to remove descriptive text fields
  # and to add column to indicate that form is completed
  my_fields <- db_data %>%
    select(starts_with(my_fields), paste0(my_form, "_complete")) %>%
    names()

  db_data %>%
    filter(!is.na(.data$redcap_repeat_instance)) %>%
    select(all_of(my_fields), .data$redcap_repeat_instance) %>%
    relocate(.data$redcap_repeat_instance, .after = all_of(my_record_id)) %>%
    rename("form_status_complete" = paste0(my_form, "_complete")) %>%
    relocate(.data$form_status_complete, .after = everything()) %>%
    tibble()
}
