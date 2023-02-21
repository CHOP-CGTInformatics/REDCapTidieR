# Create mocks for tests in test-read_redcap.R

devtools::load_all()
library(httptest)

# Delete existing mocks
unlink(testthat::test_path("fixtures/my.institution.edu"), recursive = TRUE)

creds <- get_credentials()

# Create mocks -----------
start_capturing(path = testthat::test_path("fixtures"))

read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API)

read_redcap(creds$REDCAP_URI,
  creds$REDCAPTIDIER_CLASSIC_API,
  forms = "repeated"
)

read_redcap(creds$REDCAP_URI,
  creds$REDCAPTIDIER_CLASSIC_API,
  export_survey_fields = TRUE
)

read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_API, forms = "repeated")

read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_NOARMS_API)

read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_API)

# Ignore expected errors
tryCatch(
  form_does_not_exist = function(cnd) {}, # nolint: brace_linter
  read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API, forms = "fake-form")
)

tryCatch(
  form_does_not_exist = function(cnd) {}, # nolint: brace_linter
  read_redcap(creds$REDCAP_URI,
    creds$REDCAPTIDIER_CLASSIC_API,
    forms = c("fake-form", "repeated")
  )
)

tryCatch(
  api_token_rejected = function(cnd) {}, # nolint: brace_linter
  read_redcap(
    creds$REDCAP_URI,
    "CC0CE44238EF65C5DA26A55DD749AF7A" # will be rejected by server
  )
)

read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API)
read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API, forms = "form_2")

read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_RESTRICTED_ACCESS_API)

tryCatch(
  no_data_access = function(cnd) {}, # nolint: brace_linter
  read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_RESTRICTED_ACCESS_API, forms = "no_access")
)

read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_REPEATING_EVENT_API)

stop_capturing()
