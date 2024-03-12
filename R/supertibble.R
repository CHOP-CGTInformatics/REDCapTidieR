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

#' @inherit vctrs::vec_ptype_abbr params return title description
#' @export
vec_ptype_abbr.redcap_supertbl <- function(x, ..., prefix_named, suffix_shape) {
  "suprtbl"
}

#' @inherit pillar::tbl_sum params return title description
#' @export
tbl_sum.redcap_supertbl <- function(x) {
  paste("A REDCapTidieR Supertibble with", nrow(x), "instruments")
}
