#' @title
#' Add supertbl S3 class
#'
#' @param x an object to class
#'
#' @return
#' The object with `redcaptidier_supertbl` S3 class
#'
#' @keywords internal
#'
as_supertbl <- function(x) {
  class(x) <- c("redcap_supertbl", class(x))
  x
}

#' @export
vec_ptype_abbr.redcap_supertbl <- function(x) {
  "suprtbl"
}

#' @export
tbl_sum.redcap_supertbl <- function(x) {
  paste("A REDCapTidier Supertibble with", nrow(x), "instruments")
}
