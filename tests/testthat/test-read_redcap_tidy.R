# Load initial variables
`%notin%` <- Negate(`%in%`)
classic_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_API")
longitudinal_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

test_that("read_redcap_tidy works for classic databases", {
  # Define Classic REDCap Dataframes ----
  classic_redcap <- read_redcap_tidy(redcap_uri, classic_token)
  classic_repeating <- classic_redcap %>%
    filter(structure == "repeating")
  classic_nonrepeating <- classic_redcap %>%
    filter(structure == "nonrepeating")

  # Define Variables to Test ----
  common_vars <- c("record_id")
  repeating_vars <- c("redcap_repeat_instance")

  # Check Repeating Variables Exist in Applicable List Element
  expect_true(
    all(c(common_vars, repeating_vars) %in% names(classic_repeating$redcap_data[[1]]))
  )

  # Check Nonrepeating Variables Exist in Applicable List Element
  expect_true(
    all(common_vars %in% names(classic_nonrepeating$redcap_data[[1]]))
  )
  expect_true(
    all(common_vars %in% names(classic_nonrepeating$redcap_data[[2]]))
  )
  expect_false(
    any(repeating_vars %in% names(classic_nonrepeating$redcap_data[[1]]))
  )
  expect_false(
    any(repeating_vars %in% names(classic_nonrepeating$redcap_data[[2]]))
  )
})

test_that("read_redcap_tidy works for longitudinal databases", {
  # Define Longitudinal REDCap Dataframes ----
  longitudinal_redcap <- read_redcap_tidy(redcap_uri, longitudinal_token)
  longitudinal_repeating <- longitudinal_redcap %>%
    filter(structure == "repeating")
  longitudinal_nonrepeating <- longitudinal_redcap %>%
    filter(structure == "nonrepeating")

  # Define Variables to Test ----
  common_vars <- c("record_id", "redcap_event", "redcap_arm")
  repeating_vars <- c("redcap_repeat_instance")

  # Check Repeating Variables Exist in Applicable List Elements
  expect_true(
    all(c(common_vars, repeating_vars) %in% names(longitudinal_repeating$redcap_data[[1]]))
  )

  # Check Nonrepeating Variables Exist in Applicable List Elements
  expect_true(
    all(common_vars %in% names(longitudinal_nonrepeating$redcap_data[[1]]))
  )
  expect_true(
    all(common_vars %in% names(longitudinal_nonrepeating$redcap_data[[2]]))
  )
  expect_false(
    any(repeating_vars %in% names(longitudinal_nonrepeating$redcap_data[[1]]))
  )
  expect_false(
    any(repeating_vars %in% names(longitudinal_nonrepeating$redcap_data[[2]]))
  )
})
