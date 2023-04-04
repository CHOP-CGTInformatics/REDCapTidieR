# Tell httptest where to looks for mocks
# Need this here since devtools::test_path doesn't work in helper.R
# https://github.com/r-lib/testthat/issues/1270
httptest::.mockPaths(test_path("fixtures"))

# Load initial variables
`%notin%` <- Negate(`%in%`)

test_that("read_redcap works for a classic database with a nonrepeating instrument", {
  # Define partial key columns that should be in a nonrepeating table
  # from a classic database
  expected_present_cols <- c("record_id")
  expected_absent_cols <- c("redcap_form_instance", "redcap_event", "redcap_arm")

  # Pull a nonrepeating table from a classic database
  httptest::with_mock_api({
    out <-
      read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API) %>%
      # suppress expected warning
      suppressWarnings(classes = c(
        "field_missing_categories",
        "empty_parse_warning",
        "duplicate_labels"
      )) %>%
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

test_that("read_redcap works for a classic database with a repeating instrument", {
  # Define partial key columns that should be in a repeating table
  # from a classic database
  expected_present_cols <- c("record_id", "redcap_form_instance")
  expected_absent_cols <- c("redcap_event", "redcap_arm")

  # Pull a repeating table from a classic database
  httptest::with_mock_api({
    out <-
      read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API) %>%
      # suppress expected warning
      suppressWarnings(classes = c(
        "field_missing_categories",
        "empty_parse_warning",
        "duplicate_labels"
      )) %>%
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

test_that("read_redcap returns checkbox fields", {
  # Pull a nonrepeating table from a classic database
  httptest::with_mock_api({
    out <-
      read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API) %>%
      # suppress expected warning
      suppressWarnings(classes = c(
        "field_missing_categories",
        "empty_parse_warning",
        "duplicate_labels"
      )) %>%
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
      read_redcap(creds$REDCAP_URI,
        creds$REDCAPTIDIER_CLASSIC_API,
        forms = "repeated"
      )

    filtered_locally <-
      read_redcap(
        creds$REDCAP_URI,
        creds$REDCAPTIDIER_CLASSIC_API
      ) %>%
      # suppress expected warning
      suppressWarnings(classes = c(
        "field_missing_categories",
        "empty_parse_warning",
        "duplicate_labels"
      )) %>%
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
      read_redcap(creds$REDCAP_URI,
        creds$REDCAPTIDIER_LONGITUDINAL_API,
        forms = "repeated"
      )

    filtered_locally <-
      read_redcap(
        creds$REDCAP_URI,
        creds$REDCAPTIDIER_LONGITUDINAL_API
      ) %>%
      filter(redcap_form_name == "repeated")
  })

  expect_equal(
    filtered_by_api, filtered_locally
  )
})

test_that("supplying forms is equivalent to post-hoc filtering for a database with a repeating first instrument", {
  # Explicitly testing form that doesn't contain identifiers
  httptest::with_mock_api({
    filtered_by_api <-
      read_redcap(creds$REDCAP_URI,
        creds$REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API,
        forms = "form_2"
      )

    filtered_locally <-
      read_redcap(
        creds$REDCAP_URI,
        creds$REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API
      ) %>%
      filter(redcap_form_name == "form_2")
  })

  expect_equal(
    filtered_by_api, filtered_locally
  )
})

test_that("read_redcap works for a longitudinal, single arm database with a nonrepeating instrument", {
  # Define partial key columns that should be in a nonrepeating table
  # from a longitudinal, single arm database
  expected_present_cols <- c("record_id", "redcap_event")
  expected_absent_cols <- c("redcap_form_instance", "redcap_arm")

  # Pull a nonrepeating table from a longitudinal, single arm database
  httptest::with_mock_api({
    out <-
      read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_NOARMS_API) %>%
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

test_that("read_redcap works for a longitudinal, single arm database with a repeating instrument", {
  # Define partial key columns that should be in a repeating table
  # from a longitudinal, single arm database
  expected_present_cols <- c("record_id", "redcap_form_instance", "redcap_event")
  expected_absent_cols <- c("redcap_arm")

  # Pull a repeating table from a longitudinal, single arm database
  httptest::with_mock_api({
    out <-
      read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_NOARMS_API) %>%
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

test_that("read_redcap works for a longitudinal, multi-arm database with a nonrepeating instrument", {
  # Define partial key columns that should be in a nonrepeating table
  # from a longitudinal, multi-arm database
  expected_present_cols <- c("record_id", "redcap_event", "redcap_arm")
  expected_absent_cols <- c("redcap_form_instance")

  # Pull a nonrepeating table from a longitudinal, multi arm database
  httptest::with_mock_api({
    out <-
      read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_API) %>%
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

test_that("read_redcap works for a longitudinal, multi-arm database with a repeating instrument", {
  # Define partial key columns that should be in a repeating table
  # from a longitudinal, multi-arm database
  expected_present_cols <- c("record_id", "redcap_form_instance", "redcap_event", "redcap_arm")

  # Pull a repeating table from a longitudinal, multi arm database
  httptest::with_mock_api({
    out <-
      read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_API) %>%
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
    read_redcap(creds$REDCAP_URI,
      creds$REDCAPTIDIER_CLASSIC_API,
      forms = "fake-form"
    ) %>%
      expect_error(class = "form_does_not_exist")
  })
})

test_that("errors when non-existent form is supplied with existing forms", {
  httptest::with_mock_api({
    read_redcap(creds$REDCAP_URI,
      creds$REDCAPTIDIER_CLASSIC_API,
      forms = c("fake-form", "repeated")
    ) %>%
      expect_error(class = "form_does_not_exist")
  })
})

test_that("get_fields_to_drop handles checkboxes", {
  # Example metadata
  test_meta <- tibble::tribble(
    ~field_name, ~form_name, ~field_type, ~select_choices_or_calculations, ~field_label,
    "record_id", "my_form", "text", NA_character_, NA_character_,
    "my_checkbox", "my_form", "checkbox", "1, 1 | -99, Unknown", NA_character_
  )

  res <- get_fields_to_drop(test_meta, "my_form")

  expect_setequal(
    res,
    c("my_checkbox___1", "my_checkbox___-99", "my_form_complete")
  )
})

test_that("read_redcap returns metadata", {
  httptest::with_mock_api({
    out <- read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_API)
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
  expect_s3_class(out$redcap_metadata[[1]], "tbl")
  expect_s3_class(out$redcap_events[[1]], "tbl")

  ## summary fields have correct types
  expect_type(out$data_rows, "integer")
  expect_type(out$data_cols, "integer")
  expect_s3_class(out$data_size, "lobstr_bytes")
  expect_true(
    all(out$data_na_pct >= 0) && all(out$data_na_pct <= 100)
  )

  # check that for each tibble in out$redcap_data, all fields in the data are
  # represented in the corresponding tibble in out$redcap_metadata

  ## Some fields we know won't be in the metadata
  exclude_fields <- c(
    "redcap_form_instance", "redcap_event",
    "redcap_arm", "form_status_complete"
  )

  ## map over rows of supertibble and extract fields in metadata from each
  ## instrument
  fields_in_metadata <- out$redcap_metadata %>%
    map(~ .[["field_name"]])

  ## map over rows of supertibble and extract fields in data from each
  ## instrument
  fields_in_data <- out$redcap_data %>%
    map(colnames) %>%
    # remove fields that we don't expected in metadata
    map(setdiff, y = exclude_fields)

  ## make sure metadata fields match data fields for each instrument
  expect_equal(fields_in_metadata, fields_in_data)
})

test_that("read_redcap suppresses events metadata for non-longitudinal database", {
  httptest::with_mock_api({
    out <- read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API) %>%
      suppressWarnings(classes = c(
        "field_missing_categories",
        "empty_parse_warning",
        "duplicate_labels"
      ))
  })

  expect_false("redcap_events" %in% names(out))
})

test_that("read_redcap preserves form_name order mirroring original REDCapR metadata order", {
  httptest::with_mock_api({
    expected_order <- REDCapR::redcap_metadata_read(creds$REDCAP_URI,
      creds$REDCAPTIDIER_CLASSIC_API,
      verbose = FALSE
    )$data %>%
      pull(form_name) %>%
      unique()

    out <- read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API) %>%
      suppressWarnings(classes = c(
        "field_missing_categories",
        "empty_parse_warning",
        "duplicate_labels"
      ))
  })

  expect_equal(expected_order, out$redcap_form_name)
})

test_that("read_redcap returns expected survey fields", {
  httptest::with_mock_api({
    out <- read_redcap(creds$REDCAP_URI,
      creds$REDCAPTIDIER_CLASSIC_API,
      export_survey_fields = TRUE
    ) %>%
      suppressWarnings(classes = c(
        "field_missing_categories",
        "empty_parse_warning",
        "duplicate_labels"
      ))
  })

  survey_data <- out$redcap_data[out$redcap_form_name == "survey"][[1]]
  repeat_survey_data <- out$redcap_data[out$redcap_form_name == "repeat_survey"][[1]]

  expected_nonrep_cols <- c("redcap_survey_identifier", "redcap_survey_timestamp")
  expected_rep_cols <- c("redcap_survey_identifier", "redcap_survey_timestamp")

  expect_true(all(expected_nonrep_cols %in% names(survey_data)))
  expect_true(all(expected_rep_cols %in% names(repeat_survey_data)))

  checkmate::expect_class(survey_data$redcap_survey_timestamp, c("POSIXct", "POSIXt"))
})

test_that("read_redcap errors with bad inputs", {
  # Checking for type and length constraints where relevant

  # args missing

  ## TODO

  # redcap uri
  expect_error(read_redcap(123, creds$REDCAPTIDIER_CLASSIC_API), class = "check_character")
  expect_error(read_redcap(letters[1:3], creds$REDCAPTIDIER_CLASSIC_API), class = "check_character")
  expect_error(read_redcap("https://www.google.com", creds$REDCAPTIDIER_CLASSIC_API), class = "cannot_post")
  expect_error(read_redcap("https://www.google.comm", creds$REDCAPTIDIER_CLASSIC_API), class = "cannot_resolve_host")

  # token
  expect_error(read_redcap(creds$REDCAP_URI, 123), class = "check_character")
  expect_error(read_redcap(creds$REDCAP_URI, letters[1:3]), class = "check_character")
  expect_error(read_redcap(creds$REDCAP_URI, "abc"), class = "invalid_token")
  expect_error(read_redcap(creds$REDCAP_URI, ""), class = "invalid_token")
  expect_error(
    read_redcap(creds$REDCAP_URI, "CC0CE44238EF65C5DA26A55DD749AF7"), # 31 hex characters
    class = "invalid_token"
  )
  httptest::with_mock_api({
    expect_error(
      read_redcap(creds$REDCAP_URI, "CC0CE44238EF65C5DA26A55DD749AF7A"), # will be rejected
      class = "api_token_rejected"
    )
  })

  # raw_or_label
  expect_error(
    read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API, raw_or_label = "bad option"),
    class = "check_choice"
  )

  # forms
  expect_error(
    read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API, forms = 123),
    class = "check_character"
  )

  # export_survey_fields
  expect_error(
    read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API, export_survey_fields = 123),
    class = "check_logical"
  )
  expect_error(
    read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API, export_survey_fields = c(TRUE, TRUE)),
    class = "check_logical"
  )

  # suppress_redcapr_messages
  expect_error(
    read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API, suppress_redcapr_messages = 123),
    class = "check_logical"
  )
  expect_error(
    read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API, suppress_redcapr_messages = c(TRUE, TRUE)),
    class = "check_logical"
  )
})

test_that("read_redcap returns S3 object", {
  httptest::with_mock_api({
    out <- read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_LONGITUDINAL_API)
  })

  expect_s3_class(out, "redcap_supertbl")
})

test_that("read_redcap handles access restrictions", {
  # Warns due to partial data access
  httptest::with_mock_api({
    read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_RESTRICTED_ACCESS_API) %>%
      expect_warning(class = "partial_data_access")
  })

  httptest::with_mock_api({
    out <- read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_RESTRICTED_ACCESS_API) %>%
      suppressWarnings(classes = "redcap_user_rights")
  })

  # Response has expected instruments
  expect_equal(out$redcap_form_name, c("full_access", "remove_phi_access", "deidentify_phi_access"))

  # Errors if only instruments with no access were requested
  httptest::with_mock_api({
    read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_RESTRICTED_ACCESS_API, forms = "no_access") %>%
      expect_error(class = "no_data_access")
  })
})

test_that("read_redcap returns expected vals from repeating events databases", {
  httptest::with_mock_api({
    out <- read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_REPEATING_EVENT_API)
  })

  nonrepeat_out <- out %>%
    filter(redcap_form_name == "nr_instrument") %>%
    select(redcap_data) %>%
    pluck(1, 1)

  repeat_out <- out %>%
    filter(redcap_form_name == "r_instrument") %>%
    select(redcap_data) %>%
    pluck(1, 1)

  expected_nonrepeat_cols <- c(
    "record_id",
    "redcap_event",
    "redcap_event_instance",
    "form_status_complete"
  )

  expected_repeat_cols <- c(
    "record_id",
    "redcap_event",
    "redcap_form_instance",
    "form_status_complete"
  )

  expect_true(all(expected_nonrepeat_cols %in% names(nonrepeat_out)))
  expect_s3_class(nonrepeat_out, "tbl")
  expect_true(nrow(nonrepeat_out) > 0)

  expect_true(all(expected_repeat_cols %in% names(repeat_out)))
  expect_s3_class(repeat_out, "tbl")
  expect_true(nrow(repeat_out) > 0)
})

test_that("read_redcap metadata contains skimr metrics", {
  httptest::with_mock_api({
    out <-
      read_redcap(creds$REDCAP_URI, creds$REDCAPTIDIER_CLASSIC_API) %>%
      # suppress expected warning
      suppressWarnings(classes = c(
        "field_missing_categories",
        "empty_parse_warning",
        "duplicate_labels"
      ))
  })

  # Check for existence of common skimr metric columns in all
  expected_cols <- c(
    "skim_type",
    "n_missing",
    "complete_rate"
  )

  redcap_metadata_names <- lapply(out$redcap_metadata, names)

  out <- purrr::map(redcap_metadata_names, \(x) all(expected_cols %in% x))

  expect_true(all(unlist(out)))
})
