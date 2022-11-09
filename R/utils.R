#' @title
#' Add partial key helper variables to dataframes
#'
#' @description
#' Make helper variables \code{redcap_event} and \code{redcap_arm} available as
#' branches from \code{var} for later use.
#'
#' @returns Two appended columns, \code{redcap_event} and \code{redcap_arm}
#' to the end of \code{read_redcap_tidy} output \code{tibble}s.
#'
#' @param db_data The REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param var the unquoted name of the field containing event and arm
#' identifiers
#'
#' @importFrom dplyr mutate
#'
#' @keywords internal

add_partial_keys <- function(
    db_data,
    var
) {
  pattern <- "^(\\w+?)_arm_(\\d)$"

  db_data <- db_data %>%
    mutate(
      redcap_event = sub(pattern, "\\1", {{ var }}),
      redcap_arm   = as.integer(sub(pattern, "\\2", {{ var }}))
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
#' be used in later functions if \code{return_vector = FALSE}, the default.
#' Otherwise a vector result in a c(raw = label) format to use with
#' dplyr::recode
#'
#' @param string A \code{db_metadata$select_choices_or_calculations} field
#' pre-filtered for checkbox \code{field_type}
#' @param return_vector logical for whether to return result as a vector
#'
#' @importFrom stringi stri_split_fixed
#' @importFrom tibble as_tibble is_tibble
#' @importFrom rlang .data
#' @importFrom cli cli_abort cli_warn
#'
#' @keywords internal

parse_labels <- function(string, return_vector = FALSE) {

  # If string is empty/NA, throw a warning
  if(is.na(string)){
    cli_warn("Empty string detected for a given multiple choice label.",
             class = c("empty_parse_warning", "REDCapTidieR_cond"))
  }

  out <- string %>%
    strsplit(" \\| ") # Split by "|"

  # Check there is a comma in all | delimited strsplit elements
  if (!all(grepl(",", out[[1]]))) {
    # If this is a misattributed data field or blank, throw warning in
    # multi_choice_to_labels
    if (length(out[[1]]) > 1 && !all(is.na(out[[1]]))) {
      cli_abort(
        "Cannot parse the select_choices_or_calculations field from
        REDCap metadata. This may happen if there is a comma separator missing
        inside the label: {string}",
        class = c("label_parse_error", "comma_parse_error", "REDCapTidieR_cond")
      )
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
    if (length(out) > 1 && !all(is.na(out))) {
      cli_abort(
        "Cannot parse the select_choices_or_calculations field from
        REDCap metadata. This may happen if there is a pipe character
        `|` inside the label: {string}",
        class = c("label_parse_error", "matrix_parse_error", "REDCapTidieR_cond")
      )
    }
  }

  if (return_vector) {
    if(all(is.na(out))){
      # handle no label case
      return(c(`NA` = NA_character_))
    }

    # labels are odd numbered locations in out
    res <- out[seq_along(out) %% 2 == 0]
    # raw are event numbered
    names(res) <- out[seq_along(out) %% 2 == 1]

    return(res)
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
#' Formats raw checkbox values by converting to lowercase and appending the
#' name of the checkbox field from \code{field_name}
#'
#' @returns A vector.
#'
#' @param field_name The \code{db_metadata$field_name} to append onto the string
#' @param raw A vector of raw checkbox values produced by \code{parse_labels}
#'
#' @keywords internal

checkbox_appender <- function(field_name, raw) {
  prefix <- paste0(field_name, "___")
  paste0(prefix, tolower(raw))
}

#' @title
#' Update metadata field names for checkbox handling
#'
#' @description
#' Takes a \code{db_metadata} object and:
#' \itemize{
#'   \item replaces checkbox field rows with a set of rows, one for each
#'   checkbox option
#'   \item appends a \code{field_name_updated} field to the end for checkbox
#'   variable handling
#'   \item updates \code{field_label} for any new checkbox rows to include the
#'   specific option in parenthese
#' }
#'
#' @returns Column \code{db_metadata} with \code{field_name_updated} appended
#' and \code{field_label} updated for new rows corresponding to checkbox options
#'
#' @param db_metadata The REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#'
#' @importFrom tidyr unnest
#' @importFrom dplyr %>% select mutate
#' @importFrom tibble tibble
#' @importFrom rlang .data
#'
#' @keywords internal

update_field_names <- function(db_metadata) {
  out <- db_metadata %>%
    mutate(
      updated_metadata = list(c())
    )

  for (i in seq_len(nrow(out))) {
    if (out$field_type[i] == "checkbox") {
      # If checkbox field, parse labels fill updated_metadata with a tibble
      # containing updated field names and labels
      parsed_labs <- parse_labels(out$select_choices_or_calculations[i])

      out$updated_metadata[i] <- list(
        tibble(
          field_name_updated = checkbox_appender(out$field_name[[i]], parsed_labs$raw),
          # Append checkbox option to field label in parentheses
          field_label_updated = paste0(out$field_label[[i]], " (", parsed_labs$label, ")")
        )
      )

    } else {
      # Otherwise carry through existing field name and label
      out$updated_metadata[i] <- list(
        tibble(
          field_name_updated = out$field_name[[i]],
          field_label_updated = out$field_label[[i]]
        )
      )
    }
  }

  # Unnest and expand checkbox list elements + overwrite field_labels with
  # updated field labels

  out %>%
    unnest(cols = "updated_metadata") %>%
    mutate(field_label = .data$field_label_updated) %>%
    select(-"field_label_updated")
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
#' @importFrom dplyr select mutate across case_when filter pull recode
#' @importFrom rlang .data
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
        db_metadata$select_choices_or_calculations[i],
        return_vector = TRUE
      )

      # Replace values from db_data$(field_name) with label values from
      # parse_labels key
      db_data[[field_name]] <- db_data[[field_name]] %>%
        as.character() %>%
        recode(!!!parse_labels_output) %>%
        factor(levels = parse_labels_output)
    }
  }
  db_data
}

#' @title
#' Utility function to extract the name of the project identifier field for
#' a tibble of REDCap data
#'
#' @details
#' The current implementation assumes that the first field in the data is the
#' project identifier
#'
#' @param data a tibble of REDCap data
#'
#' @return
#' The name of the identifier field in the data
#'
#' @keywords internal
#'
get_project_id_field <- function(data) {
  names(data)[[1]]
}
