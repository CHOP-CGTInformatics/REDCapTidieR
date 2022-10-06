# Package wide function to redact credentials from mocks. Define fake tokens and
# uri here
# See https://enpiar.com/r/httptest/articles/redacting.html#setting-a-package-level-redactor
function(response) {

  api_creds <- Sys.getenv(c(
    "REDCAPTIDIER_CLASSIC_API",
    "REDCAPTIDIER_LONGITUDINAL_API",
    "REDCAPTIDIER_LONGITUDINAL_NOARMS_API",
    "SUPERHEROES_REDCAP_API",
    "REDCAP_URI"
  ))

  # Replace each token with a fake token. Fakes must be 32 length hexadecimal
  response %>%
    gsub_response(
      api_creds["REDCAP_URI"], "https://my.institution.edu/redcap/api/", fixed = TRUE) %>%
    gsub_response(
      api_creds["REDCAPTIDIER_CLASSIC_API"], "123456789ABCDEF123456789ABCDEF01", fixed = TRUE) %>%
    gsub_response(
      api_creds["REDCAPTIDIER_LONGITUDINAL_API"], "123456789ABCDEF123456789ABCDEF02", fixed = TRUE) %>%
    gsub_response(
      api_creds["REDCAPTIDIER_LONGITUDINAL_NOARMS_API"], "123456789ABCDEF123456789ABCDEF03", fixed = TRUE) %>%
    gsub_response(
      api_creds["SUPERHEROES_REDCAP_API"], "123456789ABCDEF123456789ABCDEF04", fixed = TRUE)
}
