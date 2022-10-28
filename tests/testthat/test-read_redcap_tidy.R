# Tell httptest where to looks for mocks
# Need this here since devtools::test_path doesn't work in helper.R
# https://github.com/r-lib/testthat/issues/1270
httptest::.mockPaths(test_path("fixtures"))

# Load initial variables
`%notin%` <- Negate(`%in%`)

test_that("read_redcap_tidy works for a classic database with a nonrepeating instrument", {

  # Define partial key columns that should be in a nonrepeating table
  # from a classic database
  expected_present_cols <- c("record_id")
  expected_absent_cols <- c("redcap_repeat_instance", "redcap_event", "redcap_arm")

  # Pull a nonrepeating table from a classic database
  httptest::with_mock_api({
    out <-
      read_redcap_tidy(redcap_uri, classic_token) %>%
      # suppress expected warning
      suppressWarnings(classes = "field_missing_categories") %>%
      filter(redcap_form_name == "nonrepeated") %>%
      select(redcap_data) %>%
      pluck(1, 1)
  })

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
  httptest::with_mock_api({
    out <-
      read_redcap_tidy(redcap_uri, classic_token) %>%
      # suppress expected warning
      suppressWarnings(classes = "field_missing_categories") %>%
      filter(redcap_form_name == "repeated") %>%
      select(redcap_data) %>%
      pluck(1, 1)
  })

  expect_true(
    all(expected_present_cols %in% names(out))
  )

  expect_false(
    any(expected_absent_cols %in% names(out))
  )

})

test_that("read_redcap_tidy returns checkbox fields", {

  # Pull a nonrepeating table from a classic database
  httptest::with_mock_api({
    out <-
      read_redcap_tidy(redcap_uri, classic_token) %>%
      # suppress expected warning
      suppressWarnings(classes = "field_missing_categories") %>%
      filter(redcap_form_name == "data_field_types") %>%
      select(redcap_data) %>%
      pluck(1, 1)
  })

  expect_true("checkbox_multiple___1" %in% names(out))

})

test_that("supplying forms is equivalent to post-hoc filtering for a classic database", {

  # Explicitly testing form that doesn't contain identifiers
  httptest::with_mock_api({
    filtered_by_api <-
      read_redcap_tidy(redcap_uri,
                       classic_token,
                       forms = "repeated")

    filtered_locally <-
      read_redcap_tidy(redcap_uri,
                       classic_token) %>%
      # suppress expected warning
      suppressWarnings(classes = "field_missing_categories") %>%
      filter(redcap_form_name == "repeated")
  })

  expect_equal(
    filtered_by_api, filtered_locally
  )
})

test_that("supplying forms is equivalent to post-hoc filtering for a longitudinal database", {

  # Explicitly testing form that doesn't contain identifiers
  httptest::with_mock_api({
    filtered_by_api <-
      read_redcap_tidy(redcap_uri,
                       longitudinal_token,
                       forms = "repeated")

    filtered_locally <-
      read_redcap_tidy(redcap_uri,
                       longitudinal_token) %>%
      filter(redcap_form_name == "repeated")
  })

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
  httptest::with_mock_api({
    out <-
      read_redcap_tidy(redcap_uri, longitudinal_noarms_token) %>%
      filter(redcap_form_name == "nonrepeated") %>%
      select(redcap_data) %>%
      pluck(1, 1)
  })

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
  httptest::with_mock_api({
    out <-
      read_redcap_tidy(redcap_uri, longitudinal_noarms_token) %>%
      filter(redcap_form_name == "repeated") %>%
      select(redcap_data) %>%
      pluck(1, 1)
  })

  expect_true(
    all(expected_present_cols %in% names(out))
  )

  expect_false(
    any(expected_absent_cols %in% names(out))
  )

})

test_that("read_redcap_tidy works for a longitudinal, multi-arm database with a nonrepeating instrument", {

  # Define partial key columns that should be in a nonrepeating table
  # from a longitudinal, multi-arm database
  expected_present_cols <- c("record_id", "redcap_event", "redcap_arm")
  expected_absent_cols <- c("redcap_repeat_instance")

  # Pull a nonrepeating table from a longitudinal, multi arm database
  httptest::with_mock_api({
    out <-
      read_redcap_tidy(redcap_uri, longitudinal_token) %>%
      filter(redcap_form_name == "nonrepeated") %>%
      select(redcap_data) %>%
      pluck(1, 1)
  })

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
  httptest::with_mock_api({
    out <-
      read_redcap_tidy(redcap_uri, longitudinal_token) %>%
      filter(redcap_form_name == "repeated") %>%
      select(redcap_data) %>%
      pluck(1, 1)
  })

  expect_true(
    all(expected_present_cols %in% names(out))
  )

})

test_that("errors when non-existent form is supplied alone", {
  httptest::with_mock_api({
    read_redcap_tidy(redcap_uri,
                     classic_token,
                     forms = "fake-form") %>%
      expect_error(class = "form_does_not_exist")
  })
})

test_that("errors when non-existent form is supplied with existing forms", {
  httptest::with_mock_api({
    read_redcap_tidy(redcap_uri,
                     classic_token,
                     forms = c("fake-form", "repeated")) %>%
      expect_error(class = "form_does_not_exist")
  })
})

test_that("get_fields_to_drop handles checkboxes", {
  # Example metadata
  test_meta <- tibble::tribble(
    ~field_name,   ~form_name, ~field_type, ~select_choices_or_calculations,
    "record_id",   "my_form",  "text",      NA_character_,
    "my_checkbox", "my_form",  "checkbox",  "1, 1 | -99, Unknown"
  )

  res <- get_fields_to_drop(test_meta, "my_form")

  expect_setequal(
    res,
    c("my_checkbox___1", "my_checkbox___-99", "my_form_complete" )
  )
})

test_that("read_redcap_tidy returns metadata", {
  httptest::with_mock_api({
    out <- read_redcap_tidy(redcap_uri, longitudinal_token)
  })

  expected_cols <- c(
    "redcap_form_name", "redcap_form_label", "redcap_data", "redcap_metadata",
    "redcap_events", "structure", "data_rows", "data_cols", "data_size",
    "data_na_pct"
  )

  # metadata fields exist and correctly ordered
  expect_equal(expected_cols, names(out))

  # metadata fields have the correct data types

  ## redcap_metadata and redcap_events fields consist of tibbles
  c(out$redcap_metadata, out$redcap_events) %>%
    purrr::map_lgl(inherits, what = "tbl") %>%
    all() %>%
    expect_true()

  ## summary fields have correct types
  expect_type(out$data_rows, "integer")
  expect_type(out$data_cols, "integer")
  expect_s3_class(out$data_size, "lobstr_bytes")
  expect_true(
    all(out$data_na_pct >= 0) && all(out$data_na_pct <= 1)
  )

  # metadata contains all expected fields in data

  ## fields we don't expect
  exclude_fields <- c(
    "redcap_repeat_instance", "redcap_event",
    "redcap_arm", "form_status_complete"
  )

  fields_in_metadata <- out$redcap_metadata %>%
    map("field_name") %>%
    map(setdiff, y = exclude_fields)

  fields_in_data <- out$redcap_data %>%
    map(colnames) %>%
    map(setdiff, y = exclude_fields)

  expect_equal(fields_in_metadata, fields_in_data)

})

test_that("read_redcap_tidy suppresses events metadata for non-longitudinal database", {
  httptest::with_mock_api({
    out <- read_redcap_tidy(redcap_uri, classic_token) %>%
      suppressWarnings(classes = "field_missing_categories")
  })

  expect_false("redcap_events" %in% names(out))
})
