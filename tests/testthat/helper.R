# This function behaves like Sys.getenv() but returns values from the
# store of fake REDCap API credentials in inst/misc

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

# httptest setup ----

classic_token <- get_fake_credentials("REDCAPTIDIER_CLASSIC_API")
longitudinal_token <- get_fake_credentials("REDCAPTIDIER_LONGITUDINAL_API")
longitudinal_noarms_token <- get_fake_credentials("REDCAPTIDIER_LONGITUDINAL_NOARMS_API")
repeat_first_instrument_token <- get_fake_credentials("REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API")
restricted_access_token <- get_fake_credentials("REDCAPTIDIER_RESTRICTED_ACCESS_API")
repeat_events_token <- Sys.getenv("REDCAPTIDIER_REPEATING_EVENT_API")
redcap_uri <- get_fake_credentials("REDCAP_URI")

