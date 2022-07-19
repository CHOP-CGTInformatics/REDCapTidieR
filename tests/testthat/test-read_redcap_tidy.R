# Load initial variables
`%notin%` <- Negate(`%in%`)
classic_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_API")
longitudinal_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

test_that("read_redcap_tidy works", {
  # Classic REDCap Testing ----
  classic_redcap <- read_redcap_tidy(redcap_uri, classic_token)

  # Check Repeating Variables Exist in All List Elements
  for (i in 1:length(classic_redcap$redcap_data[classic_redcap$structure == "repeating"])) {
    expect_true(
      all(c("record_id", "redcap_repeat_instance") %in% names(classic_redcap$redcap_data[classic_redcap$structure == "repeating"][[i]]))
    )
  }

  # Check Nonrepeating Variables Exist in All List Elements
  # Check Repeating Variables Do Not Appear in List Elements
  for (i in 1:length(classic_redcap$redcap_data[classic_redcap$structure == "nonrepeating"])) {
    expect_true(
      all("record_id" %in% names(classic_redcap$redcap_data[classic_redcap$structure == "nonrepeating"][[i]]))
    )
    expect_true(
      all(c("redcap_repeat_instance") %notin% names(classic_redcap$redcap_data[classic_redcap$structure == "nonrepeating"][[i]]))
    )
  }

  # Longitudinal REDCap Testing ----
  longitudinal_redcap <- read_redcap_tidy(redcap_uri, longitudinal_token)

  # Check Repeating Variables Exist in All List Elements
  for (i in 1:length(longitudinal_redcap$redcap_data[longitudinal_redcap$structure == "repeating"])) {
    expect_true(
      all(c("record_id", "redcap_repeat_instance", "redcap_event", "redcap_arm") %in% names(longitudinal_redcap$redcap_data[longitudinal_redcap$structure == "repeating"][[i]]))
    )
  }

  # Check Nonrepeating Variables Exist in All List Elements
  # Check Repeating Variables Do Not Appear in List Elements
  for (i in 1:length(longitudinal_redcap$redcap_data[longitudinal_redcap$structure == "nonrepeating"])) {
    expect_true(
      all(c("record_id", "redcap_event", "redcap_arm") %in% names(longitudinal_redcap$redcap_data[longitudinal_redcap$structure == "nonrepeating"][[i]]))
    )
    expect_true(
      all(c("redcap_repeat_instance") %notin% names(longitudinal_redcap$redcap_data[longitudinal_redcap$structure == "nonrepeating"][[i]]))
    )
  }
})
