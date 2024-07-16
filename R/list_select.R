#' @title Select Data Tibbles from Named Lists
#'
#' @description
#' `list_select()` helps users easily select data tibbles from named lists. This
#' function uses <[`tidy-select`][tidyr_tidy_select]> syntax to specify which elements to extract.
#'
#' @details
#' `list_select()` can be used with any named list, and is typically used in
#' conjunction with [extract_tibbles()] to pull out named data tibbles of interest
#' for analytic operations.
#'
#' @param list A named list from which data tibbles are to be selected. Required.
#' @param tbls <[`tidy-select`][tidyr_tidy_select]> The names of the data tibbles to select from the list. Required.
#'
#' @return A named list of selected data tibbles.
#'
#' @examples
#' my_list <- extract_tibbles(superheroes_supertbl)
#'
#' list_select(my_list, starts_with("hero"))
#'
#' @export

list_select <- function(list, tbls = everything()) {
  # Check args ----
  check_arg_is_list(list)

  tbls <- eval_select(data = list, expr = enquo(tbls))
  list[tbls]
}
