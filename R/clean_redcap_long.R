#' Extract Longitudinal REDCap Databases into Tidy Tibbles
#'
#' @param db_data_long The longitudinal REDCap database output defined by \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata_long The longitudinal REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#' @param linked_arms Output of \code{link_arms}, linking forms to REDCap events/arms
#'
#' @import dplyr purrr REDCapR checkmate

clean_redcap_long <- function(
    db_data_long,
    db_metadata_long,
    linked_arms
){

  # Apply checkmate checks
  assert_data_frame(db_data_long)
  assert_data_frame(db_metadata_long)

  ## Repeating Forms Logic ----
  repeated_forms <- db_data_long %>%
    filter(!is.na(redcap_repeat_instrument)) %>%
    pull(redcap_repeat_instrument) %>%
    unique()

  repeated_forms_tibble <- tibble(
    redcap_form_names = repeated_forms,
    redcap_data = map(
      redcap_form_names,
      ~ extract_repeat_table_long(.x, db_data_long, db_metadata_long, linked_arms)
    ),
    structure = "repeating"
  )

  ## Nonrepeating Forms Logic ----
  nonrepeated_forms <- db_metadata_long %>%
    pull(form_name) %>%
    unique() %>%
    setdiff(repeated_forms)

  nonrepeated_forms_tibble <- tibble(
    redcap_form_names = nonrepeated_forms,
    redcap_data = map(
      redcap_form_names,
      ~ extract_nonrepeat_table_long(.x, db_data_long, db_metadata_long, linked_arms)
    ),
    structure = "nonrepeating"
  )

  clean_redcap_output <- rbind(repeated_forms_tibble, nonrepeated_forms_tibble)

  clean_redcap_output
}

#' Extract Non-Repeat Tables from Longitudinal REDCap Databases
#'
#' @param form_name The \code{form_name} described in the named column from the REDCap metadata.
#' @param db_data_long The REDCap database output defined by \code{REDCapR::reedcap_read_oneshot()$data}
#' @param db_metadata_long The REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#' @param linked_arms Output of \code{link_arms}, linking forms to REDCap events/arms
#'
#' @import dplyr REDCapR stringr

extract_nonrepeat_table_long <- function(
    form_name,
    db_data_long,
    db_metadata_long,
    linked_arms
){
  my_record_id <- names(db_data_long)[1]
  my_form <- form_name

  my_fields <- db_metadata_long %>%
    filter(form_name == my_form) %>%
    pull(field_name)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, my_fields)
  }

  # Setup data for loop redcap_arm linking
  db_data_long <- db_data_long %>%
    add_partial_keys() %>%
    filter(is.na(redcap_repeat_instance))

  # Use link_arms() output to check if my_form appears in each event_name
  # If it does not, filter out all rows containing that event_name
  for (i in 1:length(names(linked_arms))) {
    if (my_form %in% unlist(linked_arms[[i]]) == FALSE) {
      db_data_long <- db_data_long %>%
        filter(redcap_event_name != names(linked_arms[i]))
    }
    db_data_long
  }

  # Final aesthetic cleanup
  out <- db_data_long %>%
    select(all_of(my_fields), redcap_event, redcap_arm) %>%
    relocate(c(redcap_event, redcap_arm), .after = record_id)

  # Check arms
  if(!any(names(linked_arms) %>% str_detect("arm_2"))){
    out <- out %>%
      select(-redcap_arm)
  }

  out
}

#' Extract Repeat Tables from Longitudinal REDCap Databases
#'
#' @param form_name The \code{form_name} described in the named column from the REDCap metadata.
#' @param db_data_long The REDCap database output defined by \code{REDCapR::reedcap_read_oneshot()$data}
#' @param db_metadata_long The REDCap metadata output defined by \code{REDCapR::redcap_metadata_read()$data}
#' @param linked_arms Output of \code{link_arms}, linking forms to REDCap events/arms
#'
#' @import dplyr REDCapR stringr

extract_repeat_table_long <- function(
    form_name,
    db_data_long,
    db_metadata_long,
    linked_arms
){
  my_record_id <- names(db_data_long)[1]
  my_form <- form_name

  my_fields <- db_metadata_long %>%
    filter(form_name == my_form) %>%
    pull(field_name)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, my_fields)
  }

  # Setup data for loop redcap_arm linking
  db_data_long <- db_data_long %>%
    add_partial_keys() %>%
    filter(!is.na(redcap_repeat_instance))

  # Use link_arms() output to check if my_form appears in each event_name
  # If it does not, filter out all rows containing that event_name
  for (i in 1:length(names(linked_arms))) {
    if (my_form %in% unlist(linked_arms[[i]]) == FALSE) {
      db_data_long <- db_data_long %>%
        filter(redcap_event_name != names(linked_arms[i]))
    }
    db_data_long
  }

  # Final aesthetic cleanup
  out <- db_data_long %>%
    select(all_of(my_fields), redcap_repeat_instance, redcap_event, redcap_arm) %>%
    relocate(c(redcap_repeat_instance, redcap_event, redcap_arm), .after = record_id)

  # Check arms
  if(!any(names(linked_arms) %>% str_detect("arm_2"))){
    out <- out %>%
      select(-redcap_arm)
  }

  out
}
