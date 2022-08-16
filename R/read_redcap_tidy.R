#' Extract REDCap Databases to Tidy Tibbles
#'
#' Automatically detect REDCap database structure for the following elements:
#' \itemize{
#'   \item{Repeat Instruments}
#'   \item{Longitudinal Events}
#'   \item{Longitudinal Arms}
#' }
#' Output a \code{tibble} with list elements containing tidy dataframes. Ideal for combination of tables with join operations primary and composite keys.
#'
#' @import REDCapR
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project. Required.
#' @param token The user-specific string that serves as the password for a project. Required.
#' @param raw_or_label A string (either 'raw' or 'label') that specifies whether to export the raw coded values or the labels for the options of multiple choice fields. Default is 'label'.
#' @param suppress_messages Optionally show or suppress messages. Default \code{TRUE}.
#'
#' @export

read_redcap_tidy <- function(redcap_uri,
                             token,
                             raw_or_label = 'label',
                             suppress_messages = TRUE){

  # Load Datasets ----
  db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                 token = token,
                                 verbose = FALSE)$data

  db_metadata <- redcap_metadata_read(redcap_uri = redcap_uri,
                                      token = token,
                                      verbose = FALSE)$data

  # Apply general changes ----
  # Apply checkbox appending functions to metadata
  db_metadata <- update_field_names(db_metadata, raw_or_label = raw_or_label)

  if (raw_or_label == "label"){
    db_data <- multi_choice_to_labels(db_data, db_metadata)
  }
  # Check if database supplied is longitudinal to determine appropriate function to use
  is_longitudinal <- if("redcap_event_name" %in% names(db_data)){TRUE}else{FALSE}

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

}
