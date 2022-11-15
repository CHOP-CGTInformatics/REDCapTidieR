# Package wide function to redact credentials from mocks. Define fake tokens and
# uri here
# See https://enpiar.com/r/httptest/articles/redacting.html#setting-a-package-level-redactor
function(response) {
  credentials <- c(
    "REDCAPTIDIER_CLASSIC_API",
    "REDCAPTIDIER_LONGITUDINAL_API",
    "REDCAPTIDIER_LONGITUDINAL_NOARMS_API",
    "REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API",
    "SUPERHEROES_REDCAP_API",
    "REDCAP_URI"
  )

  real_creds <- Sys.getenv(credentials)
  fake_creds <- get_fake_credentials(credentials)

  # Replace each token with a fake token
  purrr::reduce(
    credentials,
    .f = ~gsub_response(.x, real_creds[.y], fake_creds[.y], fixed = TRUE),
    .init = response
  )
}
