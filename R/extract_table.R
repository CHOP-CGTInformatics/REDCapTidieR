#' Extract a Single Specific REDCapTidieR Table
#'
#' Supply a \code{read_redcap_tidy()} output and specify a table of interest to extract.
#'
#' @param .data A tidy table provided by \code{read_redcap_tidy()}
#' @param tbl REDCap table name specification, one max.
#'
#' @import checkmate
#' @importFrom rlang .data
#'
#' @export

extract_table <- function(.data,
                          tbl){

  # Check tbl is valid ----
  assert_character(tbl)

  if (length(tbl) > 1){
    stop("Only one table may be supplied.")
  }

  if (!tbl %in% .data$redcap_form_name){
    stop("tbl, ", tbl, ", not detected in redcap_form_name.")
  }

  # Extract specified table ----
  out %>%
    filter(redcap_form_name == tbl) %>%
    pull(redcap_data) %>%
    first()
}

#' Extract Multiple Specified REDCapTidieR Tables
#'
#' Supply a \code{read_redcap_tidy()} output and specify tables of interest to extract.
#'
#' @param .data A tidy table provided by \code{read_redcap_tidy()}
#' @param tbls REDCap table name specifications, one or more.
#'
#' @import checkmate
#' @importFrom rlang .data
#'
#' @export

extract_tables <- function(.data,
                          tbls){

  # Check tbls is valid ----
  assert_vector(tbls)

  # Extract specified table ----
  out %>%
    filter(redcap_form_name == tbl) %>%
    pull(redcap_data) %>%
    first()
}
