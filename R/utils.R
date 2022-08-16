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

  arms <- redcap_arm_export(redcap_uri, token, verbose = FALSE)$data

  db_event_instruments <- map(arms$arm_number, ~redcap_event_instruments(
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

#' Parse Labels Function
#'
#' Takes a string separated by \code{,}s and/or \code{|}s (i.e. comma/tab separated values) containing key value pairs (\code{raw} and \code{label}) and returns a tidy tibble.
#'
#' @param string A \code{db_metadata$select_choices_or_calculations} field pre-filtered for checkbox \code{field_type}
#' @param raw_or_label A string (either 'raw' or 'label') that specifies whether to export the raw coded values or the labels for the options of multiple choice fields.
#'
#' @import dplyr
#' @keywords internal

parse_labels <- function(string, raw_or_label){
  out <- string %>%
    strsplit(" \\| |, ") %>% # split either by ' | ' or ', '
    unlist() %>%
    matrix(
      ncol = 2,
      byrow = TRUE,
      dimnames = list(
        c(),               # row names
        c("raw", "label")) # column names
    ) %>%
    dplyr::as_tibble()

  out
}

#' Checkbox String Appender Helper Function
#'
#' Takes a \code{db_metadata$select_choices_or_calculations} field pre-filtered for checkbox \code{field_type} and returns a vector of key names for appending to checkbox variables.
#'
#' @param field_name The \code{db_metadata$field_name} to append onto the string
#' @param string A \code{db_metadata$select_choices_or_calculations} field pre-filtered for checkbox \code{field_type}
#' @param raw_or_label A string (either 'raw' or 'label') that specifies whether to export the raw coded values or the labels for the options of multiple choice fields.
#'
#' @import dplyr
#' @keywords internal

checkbox_appender <- function(field_name, string, raw_or_label){
  prefix <- paste0(field_name, "___")

  out <- parse_labels(string, raw_or_label)
  # append each element of the split vector with the field_name prefix and then recombine
  if(raw_or_label == 'raw'){
    out <- paste0(prefix, out[[1]])
  } else {
    out <- paste0(prefix, out[[2]])
  }

  out
}

#' Metadata field_name Updater Helper Function
#'
#' Takes a \code{db_metadata} object and appends a \code{field_name_updated} field to the end for checkbox variable handling.
#'
#' @param db_metadata A REDCap metadata object
#' @param raw_or_label A string (either 'raw' or 'label') that specifies whether to export the raw coded values or the labels for the options of multiple choice fields. Default is 'raw'.
#'
#' @import dplyr
#' @keywords internal

update_field_names <- function(db_metadata, raw_or_label = 'raw'){
  out <- db_metadata %>%
    mutate(
      field_name_updated = list(c())
    )

  # Apply checkbox appender function to rows of field_type == "checkbox"
  # Assign all field names, including expanded checkbox variables, to a list col
  for (i in 1:nrow(out)) {
    if (out$field_type[i] == "checkbox") {
      out$field_name_updated[i] <- list(
        checkbox_appender(field_name = out$field_name[i],
                          string = out$select_choices_or_calculations[i],
                          raw_or_label)
      )
    } else {
      out$field_name_updated[i] <- list(out$field_name[i])
    }
  }

  # Unnest and expand checkbox list elements
  out %>%
    unnest(cols = field_name_updated)
}

