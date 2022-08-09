#' Add Partial Keys for Helper Variables
#'
#' Make helper vars \code{redcap_event} and \code{redcap_arm} available as offshoots from \code{redcap_event_name}.
#'
#' @param db_data A REDCap database export
#'
#' @import dplyr
#' @keywords internal

add_partial_keys <- function(
    db_data
){
  pattern <- "^(\\w+?)_arm_(\\d)$"

  db_data <- db_data %>%
    mutate(
      redcap_event = sub(pattern, "\\1", redcap_event_name),
      redcap_arm   = as.integer(sub(pattern, "\\2", redcap_event_name))
    )

  db_data
}

#' Link Longitudinal REDCap Forms with the Events/Arms They Belong To
#'
#' Returns a tibble of \code{redcap_event_name}s with list elements containing a vector of associated forms.
#'
#' @param db_data_long A longitudinal REDCap database export
#' @param db_metadata_long A longitudinal REDCap metadata export
#' @param redcap_uri The REDCap URI
#' @param token The REDCap API token
#'
#' @import dplyr tibble REDCapR tidyr
#' @keywords internal

link_arms <- function(
    db_data_long,
    db_metadata_long,
    redcap_uri,
    token
){

  # First, add helper variables
  db_data_long <- add_partial_keys(db_data_long)

  # Next map through all possible arms by identifying unique ones in db_data_long
  # after it has helper variables added from `add_partial_keys()`
  db_event_instruments <- tibble() # Define empty tibble
  arms <- db_data_long %>% pull(redcap_arm) %>% unique() # Define arms

  db_event_instruments <- map(arms, ~redcap_event_instruments(
    redcap_uri = redcap_uri,
    token = token, arms = .x,
    verbose = FALSE
  )$data) %>%
    bind_rows()

  # Categorize all events/arms and assign all forms that appear in them to a vector. Vectors help with variable length assignments.
  db_event_instruments %>%
    select(-arm_num) %>%
    pivot_wider(names_from = c("unique_event_name"),
                values_from = c("form"),
                values_fn = list)
}

#' Checkbox String Appender Function
#'
#' Takes a \code{db_metadata$select_choices_or_calculations} field pre-filtered for checkbox \code{field_type} and returns a vector of key names for appending to checkbox variables
#'
#' @param field_name The \code{db_metadata$field_name} to append onto the string
#' @param string A \code{db_metadata$select_choices_or_calculations} field pre-filtered for checkbox \code{field_type}
#'
#' @import dplyr
#' @keywords internal

checkbox_appender <- function(field_name, string){
  out <- string %>%
    gsub(pattern = "\\|", replacement = "") %>%
    gsub(pattern = " [a-zA-Z0-9_.-]* ", replacement = "") %>% # Remove any value surrounded by whitespace (var names are connected to a comma)
    gsub(pattern = ", [a-zA-Z0-9_.-]*$", replacement = "") %>% # Remove the value at end of string not taken care of above
    strsplit(", ")

  # append each element of the split vector with the field_name prefix and then recombine
  prefix <- paste0(field_name, "___")
  out <- paste(prefix, out[[1]], sep = "")
  out
}
