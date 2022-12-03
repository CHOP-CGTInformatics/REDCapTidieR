# This code is sourced when httptest::start_vignette() is called. See
# https://enpiar.com/r/httptest/articles/vignettes.html#advanced-topics

# Look for credentials needed to create a vignette and, if found, delete
# the cache of mocks associated with the vignette so that fresh mocks
# will be created.

# Credential getter function from testthat/helper.R
get_fake_credentials <- function(credentials) {
  creds <- readr::read_csv(
    system.file("misc/fake_credentials.csv", package = "REDCapTidieR"),
    col_types = "cc"
  ) %>%
    dplyr::filter(.data$name %in% credentials)

  res <- rep("", length(credentials))
  names(res) <- credentials
  res[creds$name] <- creds$value

  # Remove names if only one value requested to mimic Sys.getenv
  if (length(res) == 1) {
    res <- unname(res)
  }

  res
}
