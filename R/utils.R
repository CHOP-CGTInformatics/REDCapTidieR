#' @title
#' Add partial key helper variables to dataframes
#'
#' @description
#' Make helper variables \code{redcap_event} and \code{redcap_arm} available as
#' branches from \code{redcap_event_name} for later use.
#'
#' @returns Two appended columns, \code{redcap_event} and \code{redcap_arm}
#' to the end of \code{read_redcap_tidy} output \code{tibble}s.
#'
#' @param db_data The REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#'
#' @importFrom dplyr mutate
#' @importFrom rlang .data
#'
#' @keywords internal

add_partial_keys <- function(
    db_data
) {
  pattern <- "^(\\w+?)_arm_(\\d)$"

  db_data <- db_data %>%
    mutate(
      redcap_event = sub(pattern, "\\1", .data$redcap_event_name),
      redcap_arm   = as.integer(sub(pattern, "\\2", .data$redcap_event_name))
    )

  db_data
}

#' @title
#' Link longitudinal REDCap forms with their events/arms
#'
#' @description
#' For REDCap databases containing arms and events, it is necessary to determine
#' how these are linked and what variables belong to them.
#'
#' @returns
#' Returns a \code{tibble} of \code{redcap_event_name}s with list elements
#' containing a vector of associated forms.
#'
#' @param redcap_uri The REDCap URI
#' @param token The REDCap API token
#'
#' @importFrom dplyr rename left_join
#' @importFrom REDCapR redcap_event_instruments redcap_arm_export
#'
#' @keywords internal

link_arms <- function(
    redcap_uri,
    token
) {

  arms <- redcap_arm_export(redcap_uri, token, verbose = FALSE)$data %>%
    # match field name of redcap_event_instruments() output
    rename(arm_num = "arm_number")

  db_event_instruments <- redcap_event_instruments(
    redcap_uri = redcap_uri,
    token = token,
    arms = NULL, # get all arms
    verbose = FALSE
  )$data

  left_join(db_event_instruments, arms, by = "arm_num")
}

#' @title
#' Parse labels from REDCap metadata into usable formats
#'
#' @description
#' Takes a string separated by \code{,}s and/or \code{|}s (i.e. comma/tab
#' separated values) containing key value pairs (\code{raw} and \code{label})
#' and returns a tidy \code{tibble}.
#'
#' @details
#' The associated \code{string} comes from metadata outputs.
#'
#' @returns A tidy \code{tibble} from a matrix giving raw and label outputs to
#' be used in later functions.
#'
#' @param string A \code{db_metadata$select_choices_or_calculations} field
#' pre-filtered for checkbox \code{field_type}
#'
#' @importFrom stringi stri_split_fixed
#' @importFrom tibble as_tibble is_tibble
#' @importFrom rlang .data
#' @importFrom cli cli_abort cli_warn
#'
#' @keywords internal

parse_labels <- function(string) {

  # If string is empty/NA, throw a warning
  if(is.na(string)){
    cli_warn("Empty string detected for a given multiple choice label.")
  }

  out <- string %>%
    strsplit(" \\| ") # Split by "|"

  # Check there is a comma in all | delimited strsplit elements
  if (!all(grepl(",", out[[1]]))) {
    # If this is a misattributed data field or blank, throw warning in
    # multi_choice_to_labels
    if (length(out[[1]]) > 1 && !all(is.na(out[[1]]))) {
      cli_abort("Cannot parse the select_choices_or_calculations field from
                  REDCap metadata. This may happen if there is a pipe character
                  `|` inside the label: {string}")
    }
  }

  # split on the _first_ comma in each element
  out <- out %>%
    unlist() %>%
    stri_split_fixed(pattern = ", ", n = 2) %>% # Split by first ","
    unlist()

  # Check if vector is even for matrix creation. If not, then fail.
  if (length(out) %% 2 != 0) {
    # If this is a misattributed data field or blank, throw warning in
    # multi_choice_to_labels
    if (length(out[[1]]) > 1 && !all(is.na(out[[1]]))) {
      cli_abort("Cannot parse the select_choices_or_calculations field from
                  REDCap metadata. This may happen if there is a pipe character
                  `|` inside the label: {string}")
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

#' @title
#' Append REDCap checkbox variables with helpful labels
#'
#' @description
#' Takes a \code{db_metadata$select_choices_or_calculations} field pre-filtered
#' for checkbox \code{field_type}s and returns a vector of key names for
#' appending to checkbox variables.
#'
#' @returns A vector.
#'
#' @param field_name The \code{db_metadata$field_name} to append onto the string
#' @param string A \code{db_metadata$select_choices_or_calculations} field
#' pre-filtered for checkbox \code{field_type}
#'
#' @importFrom rlang .data
#' @keywords internal

checkbox_appender <- function(field_name, string) {
  prefix <- paste0(field_name, "___")

  out <- parse_labels(string)
  out$raw <- tolower(out$raw)
  # append each element of the split vector with the field_name prefix and then
  # recombine
  out <- paste0(prefix, out[[1]])

  out
}

#' @title
#' Update metadata field names for checkbox handling
#'
#' @description
#' Takes a \code{db_metadata} object and appends a \code{field_name_updated}
#' field to the end for checkbox variable handling.
#'
#' @returns Column \code{field_name_updated} appended to a given REDCap
#' \code{db_metadata} object.
#'
#' @param db_metadata The REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#'
#' @return Returns an updated REDCap metadata object with updated field names
#'
#' @importFrom tidyr unnest
#'
#' @keywords internal

update_field_names <- function(db_metadata) {
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
    unnest(cols = "field_name_updated")
}

#' @title
#' Correctly label variables belonging to checkboxes with minus signs
#'
#' @description
#' Using \code{db_data} and \code{db_metadata}, temporarily create a conversion
#' column that reverts automatic REDCap behavior where database column names
#' have "-"s converted to "_"s.
#'
#' @details
#' This is an issue with checkbox fields since analysts should be able to verify
#' checkbox variable suffices with their label counterparts.
#'
#' @param db_data The REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#'
#' @return Updated \code{db_data} column names for checkboxes where "-"s were
#' replaced by "_"s.
#'
#' @importFrom rlang .data
#' @importFrom stringr str_replace_all
#' @importFrom dplyr %>% select filter
#'
#' @keywords internal

update_data_col_names <- function(db_data, db_metadata) {
  # Resolve checkbox conversion ----
  # Note: REDCap auto-exports and enforces changes from "-" to "_". This is not
  # useful when analysts want to reference negative values or other naming
  # conventions for checkboxes.
  db_metadata$checkbox_conversion <- db_metadata$field_name_updated
  db_metadata$checkbox_conversion <- str_replace_all(
    db_metadata$checkbox_conversion, "-", "_"
  )

  changed_names <- db_metadata %>%
    select("field_name_updated", "checkbox_conversion") %>%
    filter(.data$field_name_updated != .data$checkbox_conversion)

  for (i in seq_len(nrow(changed_names))) {
    names(db_data)[names(db_data) %in% changed_names$checkbox_conversion[i]] <- changed_names$field_name_updated[i]
  }

  db_data
}

#' @title
#' Update multiple choice fields with label data
#'
#' @description
#' Update REDCap variables with multi-choice types to standard form labels taken
#' from REDCap metadata.
#'
#' @details
#' Coerce variables of \code{field_type} "truefalse", "yesno", and "checkbox" to
#' logical. Introduce \code{form_status_complete} column and append to end of
#' \code{tibble} outputs. Ensure \code{field_type}s "dropdown" and "radio" are
#' converted appropriately since label appendings are important and unique to
#' these.
#'
#' @param db_data A REDCap database object
#' @param db_metadata A REDCap metadata object
#'
#' @importFrom dplyr select mutate across case_when filter pull left_join
#' @importFrom rlang .data :=
#' @importFrom tidyselect any_of ends_with all_of
#' @importFrom cli cli_warn
#'
#' @keywords internal

multi_choice_to_labels <- function(db_data, db_metadata) {

  # form_status_complete Column Handling ----
  # Must be done before the creation of form_status_complete
  # select columns that don't appear in field_name_updated and end with
  # "_complete"
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
             .fns = ~factor(., levels = c(
               "Incomplete", "Unverified", "Complete"
             )
             )
      )
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

      # Check for empty selection strings indicating missing data or incorrect
      # data field attribute types in REDCap
      if (is.na(db_metadata$select_choices_or_calculations[i])) {
        msg <- paste(
          "The field {field_name} in {db_metadata$form_name[i]} is a",
          "{db_metadata$field_type[i]} field type, however it does not have",
          "any categories."
        )
        cli_warn(
          c("!" = msg),
          class = c("field_missing_categories", "REDCapTidieR_cond")
        )
      }

      # Retrieve parse_labels key for given field_name
      parse_labels_output <- parse_labels(
        db_metadata$select_choices_or_calculations[i]
      )

      # Replace values from db_data$(field_name) with label values from
      # parse_labels key
      db_data <- db_data %>%
        mutate(
          across(.cols = !!field_name, .fns = as.character)
        ) %>%
        left_join(parse_labels_output %>% rename(!!field_name := "raw"),
                  by = field_name) %>%
        mutate(!!field_name := .data$label) %>% # Again, use rlang var injection
        select(-"label")

      db_data <- db_data %>%
        mutate(
          across(.cols = all_of(field_name),
                 .fns = ~factor(., levels = parse_labels_output$label))
        )
    }
  }
  db_data
}
