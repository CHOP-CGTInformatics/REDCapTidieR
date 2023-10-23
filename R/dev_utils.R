#' @title Additional release questions
#'
#' @description
#' Additional release questions to be added when using `devtools::release()`
#' during CRAN submissions.
#'
#' @details
#' This follows the documentation provided in `devtools::release()`.
#'
#' @return A series of character string questions
#'
#' @keywords internal

release_questions <- function() {
  c(
    "Have you reviewed all error messages in `cli_message_examples.R`?",
    "Have you added new error messages in this release to `cli_message_examples.R`?",
    "Have you tested this release against all test databases in `test_creds.R`?"
  )
}
