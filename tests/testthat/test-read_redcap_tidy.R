skip_on_cran()

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
    suppressWarnings() %>% # necessary for CRAN submission
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

test_that("read_redcap_tidy works for a classic database with a repeating instrument", {

  # Define partial key columns that should be in a repeating table
  # from a classic database
  expected_present_cols <- c("record_id", "redcap_repeat_instance")
  expected_absent_cols <- c("redcap_event", "redcap_arm")

  # Pull a repeating table from a classic database
  out <-
    read_redcap_tidy(redcap_uri, classic_token) %>%
    suppressWarnings() %>% # necessary for CRAN submission
    filter(redcap_form_name == "repeated") %>%
    select(redcap_data) %>%
    pluck(1, 1)

  expect_true(
    all(expected_present_cols %in% names(out))
  )

  expect_false(
    any(expected_absent_cols %in% names(out))
  )

})

test_that("supplying forms is equivalent to post-hoc filtering for a classic database", {

  skip("Failing due to https://github.com/CHOP-CGTDataOps/REDCapTidieR/issues/39")

  filtered_by_api <-
    read_redcap_tidy(redcap_uri,
                     classic_token,
                     forms = c("nonrepeated", "data_field_types")) %>%
    suppressWarnings()

  filtered_locally <-
    read_redcap_tidy(redcap_uri,
                     classic_token) %>%
    suppressWarnings() %>%
    filter(redcap_form_name %in% c("nonrepeated", "data_field_types"))

  expect_equal(
    filtered_by_api, filtered_locally
  )
})

test_that("read_redcap_tidy works for a longitudinal, single arm database with a nonrepeating instrument", {

  # Define partial key columns that should be in a nonrepeating table
  # from a longitudinal, single arm database
  expected_present_cols <- c("record_id", "redcap_event")
  expected_absent_cols <- c("redcap_repeat_instance", "redcap_arm")

  # Pull a nonrepeating table from a longitudinal, single arm database
  out <-
    read_redcap_tidy(redcap_uri, longitudinal_noarms_token) %>%
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

test_that("read_redcap_tidy works for a longitudinal, single arm database with a repeating instrument", {

  # Define partial key columns that should be in a repeating table
  # from a longitudinal, single arm database
  expected_present_cols <- c("record_id", "redcap_repeat_instance", "redcap_event")
  expected_absent_cols <- c("redcap_arm")

  # Pull a repeating table from a longitudinal, single arm database
  out <-
    read_redcap_tidy(redcap_uri, longitudinal_noarms_token) %>%
    filter(redcap_form_name == "repeated") %>%
    select(redcap_data) %>%
    pluck(1, 1)

  expect_true(
    all(expected_present_cols %in% names(out))
  )

  expect_false(
    any(expected_absent_cols %in% names(out))
  )

})

test_that("supplying forms is equivalent to post-hoc filtering for a longitudinal, single arm database", {

  filtered_by_api <-
    read_redcap_tidy(redcap_uri,
                     longitudinal_noarms_token,
                     forms = c("nonrepeated", "repeated"))

  filtered_locally <-
    read_redcap_tidy(redcap_uri,
                     longitudinal_noarms_token) %>%
    filter(redcap_form_name %in% c("nonrepeated", "repeated"))

  expect_equal(
    filtered_by_api, filtered_locally
  )
})

test_that("read_redcap_tidy works for a longitudinal, multi-arm database with a nonrepeating instrument", {

  # Define partial key columns that should be in a nonrepeating table
  # from a longitudinal, multi-arm database
  expected_present_cols <- c("record_id", "redcap_event", "redcap_arm")
  expected_absent_cols <- c("redcap_repeat_instance")

  # Pull a nonrepeating table from a longitudinal, multi arm database
  out <-
    read_redcap_tidy(redcap_uri, longitudinal_token) %>%
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

test_that("read_redcap_tidy works for a longitudinal, multi-arm database with a repeating instrument", {

  # Define partial key columns that should be in a repeating table
  # from a longitudinal, multi-arm database
  expected_present_cols <- c("record_id", "redcap_repeat_instance", "redcap_event", "redcap_arm")

  # Pull a repeating table from a longitudinal, multi arm database
  out <-
    read_redcap_tidy(redcap_uri, longitudinal_token) %>%
    filter(redcap_form_name == "repeated") %>%
    select(redcap_data) %>%
    pluck(1, 1)

  expect_true(
    all(expected_present_cols %in% names(out))
  )

})

test_that("supplying forms is equivalent to post-hoc filtering for a longitudinal, multi-arm database", {

  filtered_by_api <-
    read_redcap_tidy(redcap_uri,
                     longitudinal_token,
                     forms = c("nonrepeated", "repeated"))

  filtered_locally <-
    read_redcap_tidy(redcap_uri,
                     longitudinal_token) %>%
    filter(redcap_form_name %in% c("nonrepeated", "repeated"))

  expect_equal(
    filtered_by_api, filtered_locally
  )
})
