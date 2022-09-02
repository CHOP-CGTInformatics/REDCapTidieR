#' Add Partial Keys for Helper Variables
#'
#' Make helper vars \code{redcap_event} and \code{redcap_arm} available as offshoots from \code{redcap_event_name}.
#'
#' @param db_data A REDCap database export
#'
#' @importFrom dplyr mutate
#' @importFrom rlang .data
#' @keywords internal

add_partial_keys <- function(
    db_data
){
  pattern <- "^(\\w+?)_arm_(\\d)$"

  db_data <- db_data %>%
    mutate(
      redcap_event = sub(pattern, "\\1", .data$redcap_event_name),
      redcap_arm   = as.integer(sub(pattern, "\\2", .data$redcap_event_name))
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
#' @importFrom dplyr select
#' @importFrom tidyr pivot_wider
#' @importFrom REDCapR redcap_event_instruments redcap_arm_export
#' @importFrom tibble tibble
#' @importFrom purrr map
#' @importFrom rlang .data
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
    select(-.data$arm_num) %>%
    pivot_wider(names_from = c("unique_event_name"),
                values_from = c("form"),
                values_fn = list)
}

#' Parse Labels Function
#'
#' Takes a string separated by \code{,}s and/or \code{|}s (i.e. comma/tab separated values) containing key value pairs (\code{raw} and \code{label}) and returns a tidy tibble.
#'
#' @param string A \code{db_metadata$select_choices_or_calculations} field pre-filtered for checkbox \code{field_type}
#'
#' @importFrom stringi stri_split_fixed
#' @importFrom tibble as_tibble is_tibble
#' @importFrom rlang .data
#' @keywords internal

parse_labels <- function(string){
  out <- string %>%
    strsplit(" \\| ") # Split by "|"

  # Check there is a comma in all | delimited strsplit elements
  if (!all(grepl(",", out[[1]]))) {
    # If this is a misattributed data field or blank, throw warning in multi_choice_to_labels
    if (length(out[[1]]) > 1 & !all(is.na(out[[1]]))){
      stop(paste0("Cannot parse the select_choices_or_calculations field from REDCap metadata. This may happen if there is a pipe character `|` inside the label: ", string))
    }
  }

  # split on the _first_ comma in each element
  out <- out %>%
    unlist() %>%
    stri_split_fixed(pattern = ", ", n = 2) %>% # Split by first ","
    unlist()

  # Check if vector is even for matrix creation. If not, then fail.
  if (length(out) %% 2 != 0) {
    # If this is a misattributed data field or blank, throw warning in multi_choice_to_labels
    if (length(out[[1]]) > 1 && !all(is.na(out[[1]]))){
      stop(paste0("Cannot parse the select_choices_or_calculations field from REDCap metadata. This may happen if there is a pipe character `|` inside the label: ", string))
    }
  }

  out <- out %>%
    matrix(
      ncol = 2,
      byrow = TRUE,
      dimnames = list(
        c(),               # row names
        c("raw", "label")) # column names
    ) %>%
    as_tibble()

  out
}

#' Checkbox String Appender Helper Function
#'
#' Takes a \code{db_metadata$select_choices_or_calculations} field pre-filtered for checkbox \code{field_type} and returns a vector of key names for appending to checkbox variables.
#'
#' @param field_name The \code{db_metadata$field_name} to append onto the string
#' @param string A \code{db_metadata$select_choices_or_calculations} field pre-filtered for checkbox \code{field_type}
#'
#' @importFrom rlang .data
#' @keywords internal

checkbox_appender <- function(field_name, string){
  prefix <- paste0(field_name, "___")

  out <- parse_labels(string)
  out$raw <- tolower(out$raw)
  # append each element of the split vector with the field_name prefix and then recombine
  out <- paste0(prefix, out[[1]])

  out
}

#' Metadata field_name Updater Helper Function
#'
#' Takes a \code{db_metadata} object and appends a \code{field_name_updated} field to the end for checkbox variable handling.
#'
#' @param db_metadata A REDCap metadata object
#' @param raw_or_label A string (either 'raw' or 'label') that specifies whether to export the raw coded values or the labels for the options of multiple choice fields. Default is 'raw'.
#'
#' @importFrom tidyr unnest
#' @importFrom rlang .data
#' @keywords internal

update_field_names <- function(db_metadata, raw_or_label = 'raw'){
  out <- db_metadata %>%
    mutate(
      field_name_updated = list(c())
    )

  # Apply checkbox appender function to rows of field_type == "checkbox"
  # Assign all field names, including expanded checkbox variables, to a list col
  for (i in seq_len(nrow(out))) {
    if (out$field_type[i] == "checkbox") {
      out$field_name_updated[i] <- list(
        checkbox_appender(field_name = out$field_name[i],
                          string = out$select_choices_or_calculations[i])
      )
    } else {
      out$field_name_updated[i] <- list(out$field_name[i])
    }
  }

  # Unnest and expand checkbox list elements
  out %>%
    unnest(cols = .data$field_name_updated)
}

#' Update Multiple Choice Fields with Label Data
#'
#' @param db_data A REDCap database object
#' @param db_metadata A REDCap metadata object
#'
#' @importFrom dplyr select mutate across case_when filter pull left_join
#' @importFrom rlang .data :=
#' @importFrom tidyselect any_of ends_with all_of
#' @keywords internal

multi_choice_to_labels <- function(db_data, db_metadata){

  # form_status_complete Column Handling ----
  # Must be done before the creation of form_status_complete
  # select columns that don't appear in field_name_updated and end with "_complete"
  form_status_cols <- db_data %>%
    select(!any_of(db_metadata$field_name_updated) & ends_with("_complete")) %>%
    names()

  db_data <- db_data %>%
    mutate(
      # Change double output of raw data to character
      across(.cols = all_of(form_status_cols),
             .fns = ~as.character(.)),
      # Map constant values to raw values
      across(.cols = all_of(form_status_cols),
             .fns = ~case_when(. == "0" ~ "Incomplete",
                              . == "1" ~ "Unverified",
                              . == "2" ~ "Complete")),
      # Convert to factor
      # Map constant values to raw values
      across(.cols = all_of(form_status_cols),
             .fns = ~factor(., levels = c("Incomplete", "Unverified", "Complete")))
    )


  # Logical Column Handling ----
  # Handle columns where we change 0/1 to FALSE/TRUE (logical)
  logical_cols <- db_metadata %>%
    filter(.data$field_type %in% c("yesno", "truefalse", "checkbox")) %>%
    pull(.data$field_name_updated)

  db_data <- db_data %>%
    mutate(across(.cols = all_of(logical_cols), as.logical))

  for (i in seq_len(nrow(db_metadata))) {

    # Extract metadata field name and database corresponding column name
    field_name <- db_metadata$field_name_updated[i]

    # dropdown and radio datatype handling ----
    if (db_metadata$field_type[i] %in% c("dropdown", "radio")) {

      # Check for empty selection strings indicating missing data or incorrect data field attribute types in REDCap
      if(is.na(db_metadata$select_choices_or_calculations[i])) {
        warning(paste0("The field ", {field_name}, " in " , db_metadata$form_name[i], " is a ", db_metadata$field_type[i], " field type, however it does not have any categories."))
      }

      # Retrieve parse_labels key for given field_name
      parse_labels_output <- parse_labels(db_metadata$select_choices_or_calculations[i])

      # Replace values from db_data$(field_name) with label values from  parse_labels key
      db_data <- db_data %>%
        mutate(
          !!field_name := as.character(!!field_name)
        ) %>%
        left_join(parse_labels_output %>% rename(!!field_name := .data$raw), # Could not get working in by argument, instead inject field name for rename in parse_labels_output
                  by = field_name) %>%
        mutate(!!field_name := .data$label) %>% # Again, use rlang var injection
        select(-.data$label)

      db_data <- db_data %>%
        mutate(
          across(.cols = all_of(field_name), .fns = ~factor(., levels = parse_labels_output$label))
        )
    }
  }

  db_data
}
