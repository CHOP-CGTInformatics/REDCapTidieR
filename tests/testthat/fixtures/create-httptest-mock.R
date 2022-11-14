# Create mocks for tests in test-read_redcap_tidy.R

library(httptest)

classic_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_API")
longitudinal_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
longitudinal_noarms_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOARMS_API")
repeat_first_instrument_token <- Sys.getenv("REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

# Create mocks -----------
start_capturing(path = testthat::test_path("fixtures"))

read_redcap_tidy(redcap_uri, classic_token)

read_redcap_tidy(redcap_uri,
                 classic_token,
                 forms = "repeated")

read_redcap_tidy(redcap_uri,
                 classic_token,
                 export_survey_fields = TRUE)

read_redcap_tidy(redcap_uri, longitudinal_token, forms = "repeated")

read_redcap_tidy(redcap_uri, longitudinal_noarms_token)

read_redcap_tidy(redcap_uri, longitudinal_token)

# Ignore expected form_does_not_exist errors
tryCatch(
  form_does_not_exist = function(cnd) {},
  read_redcap_tidy(redcap_uri, classic_token, forms = "fake-form")
)

tryCatch(
  form_does_not_exist = function(cnd) {},
  read_redcap_tidy(redcap_uri,
                   classic_token,
                   forms = c("fake-form", "repeated"))
)

read_redcap_tidy(redcap_uri, repeat_first_instrument_token)
read_redcap_tidy(redcap_uri, repeat_first_instrument_token, forms = "form_2")

stop_capturing()
