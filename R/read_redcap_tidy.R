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
#' @param suppress_messages Optionally show or suppress messages. Default \code{TRUE}.
#'
#' @export

read_redcap_tidy <- function(redcap_uri,
                             token,
                             suppress_messages = TRUE){

  # Load Datasets ----
  db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                 token = token,
                                 verbose = FALSE)$data

  db_metadata <- redcap_metadata_read(redcap_uri = redcap_uri,
                                      token = token,
                                      verbose = FALSE)$data %>%
    mutate(
      field_name_updated = list(c())
    )

  # Apply checkbox appender function to rows of field_type == "checkbox"
  # Assign all field names, including expanded checkbox variables, to a list col
  for (i in 1:nrow(db_metadata)) {
    if (db_metadata$field_type[i] == "checkbox") {
      db_metadata$field_name_updated[i] <- list(
        checkbox_appender(field_name = db_metadata$field_name[i],
                          string = db_metadata$select_choices_or_calculations[i])
      )
    } else {
      db_metadata$field_name_updated[i] <- list(db_metadata$field_name[i])
    }
  }

  # Unnest and expand checkbox list elements
  db_metadata <- db_metadata %>%
    unnest(cols = field_name_updated)


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
