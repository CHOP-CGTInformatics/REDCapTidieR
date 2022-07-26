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
