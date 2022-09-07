#' @title
#' Extract non-Longitudinal REDCap Databases into Tidy Tibbles
#'
#' @description
#' Helper function internal to \code{read_redcap_tidy} responsible for
#' extraction and final processing of a tidy \code{tibble} to the user from
#' a non-longitudinal REDCap database.
#'
#' @param db_data The REDCap database output defined by \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#'
#' @return
#' Returns a \code{tibble} with list elements containing tidy dataframes. Users
#' can access dataframes under the \code{redcap_data} column with reference to
#' \code{form_name} and \code{structure} column details.
#'
#' @importFrom
#' checkmate assert_data_frame expect_logical expect_factor expect_character expect_double
#' @importFrom dplyr filter pull
#' @importFrom purrr map
#' @importFrom tibble tibble
#' @importFrom rlang .data
#'
#' @keywords internal

clean_redcap <- function(
    db_data,
    db_metadata
){

  # Apply checkmate checks ---
  assert_data_frame(db_data)
  assert_data_frame(db_metadata)

  # Repeating Instrument Check ----
  # Check if database supplied contains any repeating instruments to map onto `redcap_repeat_*` variables

  has_repeating <- if("redcap_repeat_instance" %in% names(db_data)){TRUE}else{FALSE}

  ## Repeating Forms Logic ----
  if(has_repeating){
    repeated_forms <- db_data %>%
      filter(!is.na(.data$redcap_repeat_instrument)) %>%
      pull(.data$redcap_repeat_instrument) %>%
      unique()

    repeated_forms_tibble <- tibble(
      redcap_form_name = repeated_forms,
      redcap_data = map(
        repeated_forms,
        ~ distill_repeat_table(.x, db_data, db_metadata)
      ),
      structure = "repeating"
    )
  }

  ## Nonrepeating Forms Logic ----
  nonrepeated_forms <- db_metadata %>%
    pull(.data$form_name) %>%
    unique()

  if (has_repeating) {
    nonrepeated_forms <- setdiff(nonrepeated_forms,
                                 repeated_forms)
  }

  nonrepeated_forms_tibble <- tibble(
    redcap_form_name = nonrepeated_forms,
    redcap_data = map(
      nonrepeated_forms,
      ~ distill_nonrepeat_table(.x,
                                db_data,
                                db_metadata)
    ),
    structure = "nonrepeating"
  )

  if(has_repeating){
    clean_redcap_output <- rbind(repeated_forms_tibble, nonrepeated_forms_tibble)
  } else {
    clean_redcap_output <- nonrepeated_forms_tibble
  }
}

#' @title
#' Extract Non-Repeat Tables from non-Longitudinal REDCap Databases
#'
#' @description
#' Sub-helper function to \code{clean_redcap} for single nonrepeat table extraction.
#'
#' @return
#' A \code{tibble} of all data related to a specified \code{form_name}
#'
#' @param form_name The \code{form_name} described in the named column from the REDCap metadata.
#' @param db_data The REDCap database output defined by \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#'
#' @importFrom dplyr filter pull select relocate rename
#' @importFrom tidyselect all_of everything starts_with
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @keywords internal

distill_nonrepeat_table <- function(
    form_name,
    db_data,
    db_metadata
){

  # Repeating Instrument Check ----
  # Check if database supplied contains any repeating instruments to map onto `redcap_repeat_*` variables
  has_repeating <- if("redcap_repeat_instance" %in% names(db_data)){TRUE}else{FALSE}

  my_record_id <- names(db_data)[1]
  my_form <- form_name

  my_fields <- db_metadata %>%
    filter(.data$form_name == my_form) %>%
    pull(.data$field_name_updated)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, all_of(my_fields))
  }

  # Below necessary to remove descriptive text fields
  # and to add column to indicate that form is completed
  my_fields <- db_data %>%
    select(starts_with(my_fields), paste0(my_form, "_complete")) %>%
    names()

  if(has_repeating){
    db_data <- db_data %>%
      filter(is.na(.data$redcap_repeat_instance))
  }

  db_data %>%
    select(all_of(my_fields)) %>%
    rename("form_status_complete" = paste0(my_form, "_complete")) %>%
    relocate(.data$form_status_complete, .after = everything()) %>%
    tibble()
}

#' @title
#' Extract Repeat Tables from non-Longitudinal REDCap Databases
#'
#' @description
#' Sub-helper function to \code{clean_redcap} for single repeat table extraction.
#'
#' @return
#' A \code{tibble} of all data related to a specified \code{form_name}
#'
#' @param form_name The \code{form_name} described in the named column from the REDCap metadata.
#' @param db_data The non-longitudinal REDCap database output defined by \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The non-longitudinal REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#'
#' @importFrom dplyr filter pull select relocate rename
#' @importFrom tidyselect all_of everything starts_with
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @keywords internal

distill_repeat_table <- function(
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
    my_fields <- c(my_record_id, all_of(my_fields))
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
