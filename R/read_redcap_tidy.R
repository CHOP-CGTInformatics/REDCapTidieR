#' @title
#' Extract a REDCap database into a tidy supertibble
#'
#' @description
#' Call the REDCap API to retrieve data and metadata about a project,
#' and then transform the output into a tidy "supertibble" that contains tidy
#' tibbles, where each tibble represents a single instrument.
#'
#' @details
#' This function uses {REDCapR} to call the REDCap API. The REDCap API returns
#' a "sparse matrix" that mashes data from all data collection instruments
#' together. In complex databases, such as those that contain repeated
#' instruments, this is unwieldy. The `read_redcap_tidy` function intelligently
#' deconvolutes the sparse matrix and splices the data into individual tibbles,
#' where one tibble represents the data from one instrument.
#'
#' @return
#' Returns a \code{tibble} in which each row represents a REDCap instrument.
#'
#' @importFrom REDCapR redcap_read_oneshot redcap_metadata_read
#' @importFrom dplyr filter bind_rows %>%
#' @importFrom tibble tribble
#' @importFrom rlang .data
#'
#' @param redcap_uri The
#' URI/URL of the REDCap server (e.g.,
#' "https://server.org/apps/redcap/api/"). Required.
#' @param token The user-specific string that serves as the password for a
#' project. Required.
#' @param raw_or_label A string (either 'raw' or 'label') that specifies whether
#' to export the raw coded values or the labels for the options of multiple
#' choice fields. Default is 'label'.
#' @param suppress_messages Optionally show or suppress messages.
#' Default \code{TRUE}.
#'
#' @examples
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' read_redcap_tidy(
#'    redcap_uri,
#'    token,
#'    raw_or_label = "label"
#'  )
#' }
#'
#' @export

read_redcap_tidy <- function(redcap_uri,
                             token,
                             raw_or_label = "label",
                             suppress_messages = TRUE) {

  # Load Datasets ----
  # Load REDCap Dataset output
  db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                 token = token,
                                 verbose = FALSE)$data

  check_redcap_populated(db_data)

  # Load REDCap Metadata output
  db_metadata <- redcap_metadata_read(redcap_uri = redcap_uri,
                                      token = token,
                                      verbose = FALSE)$data %>%
    filter(.data$field_type != "descriptive")

  # Apply database output changes ----
  # Apply checkbox appending functions to metadata
  db_metadata <- update_field_names(db_metadata)
  # Note: Order of functions calls between `update_*` matters
  if ("checkbox" %in% db_metadata$field_type) {
    db_data <- update_data_col_names(db_data, db_metadata)
  }

  if (raw_or_label == "label") {
    db_data <- multi_choice_to_labels(db_data, db_metadata)
  }

  # Check for potential API rights issues ----
  # If any missing field names detected in metadata output, run the following
  # resulting in metadata with missing data removed and warn user of action
  if (any(!db_metadata$field_name_updated %in% names(db_data))) {
    check_user_rights(db_data, db_metadata)
    # Default behavior: Remove missing field names to prevent crash
    db_metadata <- db_metadata %>%
      filter(.data$field_name_updated %in% names(db_data))
  }

  # Longitudinal Arms Check and Cleaning Application ----
  # Check if database supplied is longitudinal to determine appropriate function
  # to use
  is_longitudinal <- if ("redcap_event_name" %in% names(db_data)) {
    TRUE
  } else {
    FALSE
  }

  if (is_longitudinal) {
    linked_arms <- link_arms(db_data_long = db_data,
                             db_metadata_long = db_metadata,
                             redcap_uri = redcap_uri,
                             token = token)

    out <- clean_redcap_long(db_data_long = db_data,
                             db_metadata_long = db_metadata,
                             linked_arms = linked_arms)
  } else {
    out <- clean_redcap(db_data = db_data,
                        db_metadata = db_metadata)
  }

  out
}
