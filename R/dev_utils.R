#' Retrieve credentials for creating or using mocks
#'
#' @param credentials names of credentials to retrieve. By default all credentials in
#' `inst/misc/fake_credentials.csv` are retrieved
#' @param fake logical. Should fake credentials be retrieved? By default `FALSE`
#'
#' @return
#' A named list of credentials from with `Sys.getenv()` if `fake = FALSE`
#' or from `inst/misc/fake_credentials.csv` if `fake = TRUE`
#' @keywords internal
get_credentials <- function(credentials = NULL, fake = FALSE) {
  creds <- readr::read_csv(
    system.file("misc/fake_credentials.csv", package = "REDCapTidieR"),
    col_types = "cc"
  )

  if (!is.null(credentials)) {
    if (!all(credentials %in% creds$name)) {
      missing_creds <- setdiff(credentials, creds$name) # nolint: object_usage_linter
      cli::cli_abort(c(
        "x" = "{.code {missing_creds}} {?is/are} missing from {.path inst/misc/fake_credentials.csv}"
      ))
    }

    creds <- creds[creds$name %in% credentials, ]
  }

  res <- rep("", nrow(creds))

  if (fake) {
    res <- creds$value
  } else {
    res <- unname(Sys.getenv(creds$name))
  }

  res <- as.list(res)
  names(res) <- creds$name
  res
}

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
