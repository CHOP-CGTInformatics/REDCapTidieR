# This code is sourced when httptest::start_vignette() is called. See
# https://enpiar.com/r/httptest/articles/vignettes.html#advanced-topics

# Credential getter function from testthat/helper.R
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

    creds <- creds[creds$name == credentials, ]
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
