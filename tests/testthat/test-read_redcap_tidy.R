# Load initial variables
`%notin%` <- Negate(`%in%`)
classic_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_API")
longitudinal_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
longitudinal_noarms_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOARMS_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

test_that("read_redcap_tidy works for a classic database with a nonrepeating instrument", {

  # Define partial key columns that should be in a nonrepeating table
  # from a classic database
  expected_present_cols <- c("record_id")
  expected_absent_cols <- c("redcap_repeat_instance", "redcap_event", "redcap_arm")

  # Pull a nonrepeating table from a classic database
  out <-
    read_redcap_tidy(redcap_uri, classic_token) %>%
    filter(redcap_form_name == "nonrepeated") %>%
    select(redcap_data) %>%
    pluck(1, 1)

  expect_true(
    all(expected_present_cols %in% names(out))
  )

  expect_false(
    any(expected_absent_cols %in% names(out))
  )

})

# Please implement equivalent tests for all remaining 5 cases defined in the PR
