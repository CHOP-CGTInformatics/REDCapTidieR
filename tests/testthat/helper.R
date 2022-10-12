# This function behaves like Sys.getenv() but returns values from the
# store of fake REDCap API credentials in inst/misc

get_fake_credentials <- function(credentials) {
  creds <- readr::read_csv(
    system.file("misc/fake_credentials.csv", package = "REDCapTidieR"),
    col_types = "cc"
  ) %>%
    dplyr::filter(name %in% credentials)

  res <- rep("", length(credentials))
  names(res) <- credentials
  res[creds$name] <- creds$value

  # Remove names if only one value requested to mimic Sys.getenv
  if (length(res) == 1) {
    res <- unname(res)
  }

  res
}
