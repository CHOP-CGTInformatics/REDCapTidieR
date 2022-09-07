#' @title
#' Extract a Single Table from a REDCapTidieR Output
#'
#' @description
#' Supply a \code{read_redcap_tidy()} output and specify a \code{form_name} to extract.
#'
#' @returns A single \code{tibble} specified by the user.
#'
#' @param .data A REDCapTidieR output provided by \code{read_redcap_tidy()}
#' @param tbl REDCap \code{form_name} specification, one max.
#'
#' @importFrom checkmate assert_character
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' out <- read_redcap_tidy(
#'           redcap_uri,
#'           token,
#'           raw_or_label = "label"
#'         )
#'
#'  extract_table(out, "sample_form_name")
#' }
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

#' Extract One or More Tables from a REDCapTidieR Output
#'
#' @description
#' Supply a \code{read_redcap_tidy()} output and specify one or more \code{form_name}s to extract.
#'
#' @details
#' Users may supply \code{tidyselect} statements such as \code{starts_with()} or \code{ends_with()} for easier selection.
#'
#' @returns A named list of \code{tibble}s specified by the user via \code{form_name}.
#'
#' @param .data A REDCapTidieR output provided by \code{read_redcap_tidy()}
#' @param tbl REDCap \code{form_name} specification, one or more.
#'
#' @importFrom rlang .data enquo
#' @importFrom dplyr select
#' @importFrom tidyselect eval_select everything
#' @importFrom tidyr pivot_wider
#' @importFrom purrr map pluck
#'
#' @examples
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' out <- read_redcap_tidy(
#'           redcap_uri,
#'           token,
#'           raw_or_label = "label"
#'         )
#'
#'  extract_tables(out, c("sample_form_name1", "sample_form_name2"))
#'  extract_tables(out, everything())
#'  extract_tables(out, starts_with("demographics"))
#' }
#'
#' @export

extract_tables <- function(.data,
                           tbls = everything()){

  # Extract specified table ----
  # Pass tbls as an expression for enquosure
  tbls <- enquo(tbls)

  out <- .data %>%
    select(-.data$structure) %>%
    pivot_wider(names_from = .data$redcap_form_name,
                values_from = .data$redcap_data)

  out <- out[eval_select(tbls, data = out)]

  out %>%
    map(.f = ~pluck(.)[[1]])
}
