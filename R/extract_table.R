#' Extract a Single REDCapTidieR Table
#'
#' Supply a \code{read_redcap_tidy()} output and specify a table of interest to extract.
#'
#' @returns A single \code{tibble} specified by the user.
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
  assert_character(all_of(tbl))

  if (length(all_of(tbl)) > 1){
    stop("Only one table may be supplied.")
  }

  # Extract specified table ----
  out <- extract_tables(.data, tbls = all_of(tbl))[[1]]

  out
}

#' Extract Multiple Specified REDCapTidieR Tables
#'
#' Supply a \code{read_redcap_tidy()} output and specify tables of interest to extract. Users may supply \code{tidyselect} statements for easier selection.
#'
#' @returns A named list of \code{tibble}s specified by the user.
#'
#' @param .data A tidy table provided by \code{read_redcap_tidy()}
#' @param tbls REDCap table name specifications, one or more.
#'
#' @import checkmate
#' @importFrom rlang .data enquo
#' @importFrom tidyselect eval_select
#' @importFrom purrr map pluck
#'
#' @export

extract_tables <- function(.data,
                           tbls){

  # Extract specified table ----
  # Pass tbls as an expression for enquosure
  tbls <- rlang::enquo(tbls)

  out <- .data %>%
    select(-.data$structure) %>%
    pivot_wider(names_from = .data$redcap_form_name,
                values_from = .data$redcap_data)

  out <- out[tidyselect::eval_select(tbls, data = out)]

  out %>%
    map(.f = ~pluck(.)[[1]])
}
