#' @title
#' Add \link[skimr]{skimr} metrics to a supertibble's metadata
#'
#' @description
#' Add default \link[skimr]{skim} metrics to the `redcap_data` list elements of
#' a supertibble output from `read_readcap`.
#'
#' @details
#' For more information on the default metrics provided, check the
#' \link[skimr]{get_default_skimmer_names}
#' documentation.
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#'
#' @importFrom dplyr left_join select
#' @importFrom tidyselect any_of
#' @importFrom purrr map2
#'
#' @return
#' A supertibble with \link[skimr]{skimr} metadata metrics
#'
#' @examples
#' superheroes_supertbl
#'
#' add_skimr_metadata(superheroes_supertbl)
#'
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' supertbl <- read_redcap(redcap_uri, token)
#' add_skimr_metadata(supertbl)
#' }
#'
#' @export

add_skimr_metadata <- function(supertbl) {
  check_installed("skimr", reason = "to use `add_skimr_metadata()`")

  skim_data <- function(redcap_data, redcap_metadata) {
    excluded_fields <- c(
      get_record_id_field(redcap_data),
      "redcap_form_instance", "redcap_event_instance", "redcap_event",
      "redcap_arm", "form_status_complete"
    )

    skimmed_data <- redcap_data %>%
      select(!any_of(excluded_fields)) %>%
      skimr::skim()

    redcap_metadata %>%
      left_join(
        skimmed_data,
        by = c(field_name = "skim_variable")
      )
  }

  supertbl$redcap_metadata <- map2(.x = supertbl$redcap_data,
                                   .y = supertbl$redcap_metadata,
                                   .f = skim_data)

  supertbl
}
