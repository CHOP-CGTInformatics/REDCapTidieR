#' @title
#' Add [skimr::skim] metrics to a supertibble's metadata
#'
#' @description
#' Add default [skimr::skim] metrics to the `redcap_data` list elements of
#' a supertibble output from `read_readcap`.
#'
#' @details
#' For more information on the default metrics provided, check the
#' [skimr::get_default_skimmer_names] documentation.
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#'
#' @return
#' A supertibble with [skimr::skim] metadata metrics
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
  check_arg_is_supertbl(supertbl)
  # Check if supertbl has been labelled
  is_labelled <- is_labelled(supertbl)

  supertbl$redcap_metadata <- map2(
    .x = supertbl$redcap_data,
    .y = supertbl$redcap_metadata,
    is_labelled,
    .f = skim_data
  )

  # If supertbl is labelled, apply skimr labels
  if (is_labelled) {
    supertbl <- make_labelled(supertbl)
  }

  supertbl
}

#' @title Apply applicable skimmers to data
#'
#' @description
#' A helper function for `add_skimr_metadata()` which applies applicable
#' skimmers to a given dataframe.
#'
#' @returns A dataframe
#'
#' @keywords internal

skim_data <- function(redcap_data, redcap_metadata, is_labelled) {
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
