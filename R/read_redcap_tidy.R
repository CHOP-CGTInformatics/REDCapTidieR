#' Extract REDCap Databases to Tidy Tibbles
#'
#' Automatically detect REDCap database structure for the following elements:
#' \itemize{
#'   \item{Repeat Instruments}
#'   \item{Longitudinal Events}
#'   \item{Longitudinal Arms}
#' }
#'
#' @import REDCapR
#'
#' @param redcap_uri The URI (uniform resource identifier) of the REDCap project. Required.
#' @param token The user-specific string that serves as the password for a project. Required.
#'
#' @export

read_redcap_tidy <- function(redcap_uri,
                             token){

  # Load Datasets ----
  db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                 token = token)$data

  db_metadata <- redcap_metadata_read(redcap_uri = redcap_uri,
                                      token = token)$data

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

  out
}
