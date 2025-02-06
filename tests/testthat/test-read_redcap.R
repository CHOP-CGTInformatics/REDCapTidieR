skip_on_cran()

test_that("read_redcap works for a classic database with a nonrepeating instrument", {
  # Define partial key columns that should be in a nonrepeating table
  # from a classic database
  expected_present_cols <- c("record_id")
  expected_absent_cols <- c("redcap_form_instance", "redcap_event", "redcap_arm")

  # Pull a nonrepeating table from a classic database
  out <-
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API")) %>%
    # suppress expected warning
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    )) %>%
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

test_that("read_redcap works for a classic database with a repeating instrument", {
  # Define partial key columns that should be in a repeating table
  # from a classic database
  expected_present_cols <- c("record_id", "redcap_form_instance")
  expected_absent_cols <- c("redcap_event", "redcap_arm")

  # Pull a repeating table from a classic database
  out <-
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API")) %>%
    # suppress expected warning
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    )) %>%
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

test_that("read_redcap returns checkbox fields", {
  # Pull a nonrepeating table from a classic database
  out <-
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API")) %>%
    # suppress expected warning
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    )) %>%
    filter(redcap_form_name == "data_field_types") %>%
    select(redcap_data) %>%
    pluck(1, 1)

  expect_true("checkbox_multiple___1" %in% names(out))
})

test_that("supplying forms is equivalent to post-hoc filtering for a classic database", {
  # Explicitly testing form that doesn't contain identifiers
  filtered_by_api <-
    read_redcap(Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_CLASSIC_API"),
      forms = "repeated"
    )

  filtered_locally <-
    read_redcap(
      Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_CLASSIC_API")
    ) %>%
    # suppress expected warning
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    )) %>%
    filter(redcap_form_name == "repeated")

  expect_equal(
    filtered_by_api, filtered_locally
  )
})

test_that("supplying forms is equivalent to post-hoc filtering for a longitudinal database", {
  # Explicitly testing form that doesn't contain identifiers
  filtered_by_api <-
    read_redcap(Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API"),
      forms = "repeated"
    )

  filtered_locally <-
    read_redcap(
      Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
    ) %>%
    filter(redcap_form_name == "repeated")

  expect_equal(
    filtered_by_api, filtered_locally
  )
})

test_that("supplying forms is equivalent to post-hoc filtering for a database with a repeating first instrument", {
  # Explicitly testing form that doesn't contain identifiers
  filtered_by_api <-
    read_redcap(Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API"),
      forms = "form_2"
    )

  filtered_locally <-
    read_redcap(
      Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API")
    ) %>%
    filter(redcap_form_name == "form_2")

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
  out <-
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOARMS_API")) %>%
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

test_that("read_redcap works for a longitudinal, single arm database with a repeating instrument", {
  # Define partial key columns that should be in a repeating table
  # from a longitudinal, single arm database
  expected_present_cols <- c("record_id", "redcap_form_instance", "redcap_event")
  expected_absent_cols <- c("redcap_arm")

  # Pull a repeating table from a longitudinal, single arm database
  out <-
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOARMS_API")) %>%
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

test_that("read_redcap works for a longitudinal, multi-arm database with a nonrepeating instrument", {
  # Define partial key columns that should be in a nonrepeating table
  # from a longitudinal, multi-arm database
  expected_present_cols <- c("record_id", "redcap_event", "redcap_arm")
  expected_absent_cols <- c("redcap_form_instance")

  # Pull a nonrepeating table from a longitudinal, multi arm database
  out <-
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")) %>%
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

test_that("read_redcap works for a longitudinal, multi-arm database with a repeating instrument", {
  # Define partial key columns that should be in a repeating table
  # from a longitudinal, multi-arm database
  expected_present_cols <- c("record_id", "redcap_form_instance", "redcap_event", "redcap_arm")

  # Pull a repeating table from a longitudinal, multi arm database
  out <-
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")) %>%
    filter(redcap_form_name == "repeated") %>%
    select(redcap_data) %>%
    pluck(1, 1)

  expect_true(
    all(expected_present_cols %in% names(out))
  )
})

test_that("errors when non-existent form is supplied alone", {
  read_redcap(Sys.getenv("REDCAP_URI"),
    Sys.getenv("REDCAPTIDIER_CLASSIC_API"),
    forms = "fake-form"
  ) %>%
    expect_error(class = "form_does_not_exist")
})

test_that("errors when non-existent form is supplied with existing forms", {
  read_redcap(Sys.getenv("REDCAP_URI"),
    Sys.getenv("REDCAPTIDIER_CLASSIC_API"),
    forms = c("fake-form", "repeated")
  ) %>%
    expect_error(class = "form_does_not_exist")
})

test_that("get_fields_to_drop handles checkboxes", {
  # Example metadata
  test_meta <- tibble::tribble(
    ~field_name, ~form_name, ~field_type, ~select_choices_or_calculations, ~field_label,
    "record_id", NA_character_, "text", NA_character_, NA_character_,
    "my_checkbox", "my_form", "checkbox", "1, 1 | -99, Unknown", NA_character_
  )

  res <- get_fields_to_drop(test_meta, "my_form")

  expect_setequal(
    res,
    c("my_checkbox___1", "my_checkbox___-99", "my_form_complete")
  )
})

test_that("get_fields_to_drop handles record_id form with single field", {
  # Example metadata
  test_meta <- tibble::tribble(
    ~field_name, ~form_name, ~field_type, ~select_choices_or_calculations, ~field_label,
    "record_id", NA_character_, "text", NA_character_, NA_character_
  )

  res <- get_fields_to_drop(test_meta, "my_form")

  expect_equal(res, "my_form_complete")
})

test_that("read_redcap returns metadata", {
  out <- read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API"))

  expected_cols <- c(
    "redcap_form_name", "redcap_form_label", "redcap_data", "redcap_metadata",
    "redcap_events", "structure", "data_rows", "data_cols", "data_size",
    "data_na_pct", "form_complete_pct"
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
  expect_true(
    all(out$form_complete_pct >= 0) && all(out$form_complete_pct <= 100)
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
  out <- read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API")) %>%
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    ))

  expect_false("redcap_events" %in% names(out))
})

test_that("read_redcap preserves form_name order mirroring original REDCapR metadata order", {
  expected_order <- REDCapR::redcap_metadata_read(Sys.getenv("REDCAP_URI"),
    Sys.getenv("REDCAPTIDIER_CLASSIC_API"),
    verbose = FALSE
  )$data %>%
    pull(form_name) %>%
    unique()

  out <- read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API")) %>%
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    ))

  expect_equal(expected_order, out$redcap_form_name)
})

test_that("read_redcap returns expected survey fields", {
  out <- read_redcap(Sys.getenv("REDCAP_URI"),
    Sys.getenv("REDCAPTIDIER_CLASSIC_API"),
    export_survey_fields = TRUE
  ) %>%
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    ))

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
  expect_error(read_redcap(123, Sys.getenv("REDCAPTIDIER_CLASSIC_API")), class = "check_character")
  expect_error(read_redcap(letters[1:3], Sys.getenv("REDCAPTIDIER_CLASSIC_API")), class = "check_character")
  expect_error(
    read_redcap("https://www.google.comm", Sys.getenv("REDCAPTIDIER_CLASSIC_API")),
    class = "cannot_resolve_host"
  )

  # token
  expect_error(read_redcap(Sys.getenv("REDCAP_URI"), 123), class = "check_character")
  expect_error(read_redcap(Sys.getenv("REDCAP_URI"), letters[1:3]), class = "check_character")
  expect_error(read_redcap(Sys.getenv("REDCAP_URI"), "abc"), class = "invalid_token")
  expect_error(read_redcap(Sys.getenv("REDCAP_URI"), ""), class = "invalid_token")
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), "CC0CE44238EF65C5DA26A55DD749AF7"), # 31 hex characters
    class = "invalid_token"
  )
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), "CC0CE44238EF65C5DA26A55DD749AF7A"), # will be rejected
    class = "api_token_rejected"
  )

  # raw_or_label
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API"), raw_or_label = "bad option"),
    class = "check_choice"
  )

  # forms
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API"), forms = 123),
    class = "check_character"
  )

  # export_survey_fields
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API"), export_survey_fields = 123),
    class = "check_logical"
  )
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API"), export_survey_fields = c(TRUE, TRUE)),
    class = "check_logical"
  )

  # suppress_redcapr_messages
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API"), suppress_redcapr_messages = 123),
    class = "check_logical"
  )
  expect_error(
    read_redcap(
      Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_CLASSIC_API"),
      suppress_redcapr_messages = c(TRUE, TRUE)
    ),
    class = "check_logical"
  )

  # export_data_access_group
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_DAG_API"), export_data_access_groups = "TRUE"),
    class = "check_logical"
  )
  expect_error(
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_DAG_API"), export_data_access_groups = 123),
    class = "check_logical"
  )
  expect_error(
    read_redcap(
      Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_DAG_API"),
      export_data_access_groups = c(TRUE, TRUE)
    ),
    class = "check_logical"
  )
})

test_that("read_redcap returns S3 object", {
  out <- read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API"))

  expect_s3_class(out, "redcap_supertbl")
})

test_that("read_redcap handles access restrictions", {
  # Warns due to partial data access
  read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_RESTRICTED_ACCESS_API")) %>%
    expect_warning(class = "partial_data_access")

  out <- read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_RESTRICTED_ACCESS_API")) %>%
    suppressWarnings(classes = "redcap_user_rights")

  # Response has expected instruments
  expect_equal(out$redcap_form_name, c("full_access", "remove_phi_access", "deidentify_phi_access"))

  # Errors if only instruments with no access were requested
  read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_RESTRICTED_ACCESS_API"), forms = "no_access") %>%
    expect_error(class = "no_data_access")
})

test_that("read_redcap returns expected vals from repeating events databases", {
  out <- read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_REPEATING_EVENT_API"))

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

test_that("read_redcap works for a large sparse database", {
  out <- read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LARGE_SPARSE_API"))

  expected_col_types <- c(
    "numeric",
    "logical",
    "numeric",
    "logical",
    "Date",
    "factor",
    "factor",
    "character",
    "factor"
  )

  names(expected_col_types) <- c(
    "record_id",
    "empty_int_column",
    "partial_empty_int_column",
    "empty_date_column",
    "partial_empty_date_column",
    "empty_factor_column",
    "partial_empty_factor_column",
    "data_type_switch",
    "form_status_complete"
  )

  out %>%
    extract_tibble("form_1") %>%
    vapply(class, character(1)) %>%
    expect_equal(expected_col_types)

  out_low_max <- read_redcap(Sys.getenv("REDCAP_URI"),
    Sys.getenv("REDCAPTIDIER_LARGE_SPARSE_API"),
    guess_max = 500
  )

  out_low_max %>%
    extract_tibble("form_1") %>%
    vapply(class, character(1)) %>%
    expect_equal(expected_col_types)
})

test_that("read_redcap works with non-longitudinal Data Access Groups", {
  out_dag <- read_redcap(
    Sys.getenv("REDCAP_URI"),
    Sys.getenv("REDCAPTIDIER_DAG_API")
  )

  # Check for expected column and data
  dag_data <- out_dag$redcap_data[[1]]

  expect_true("redcap_data_access_group" %in% names(dag_data))
  expect_true(is.character(dag_data$redcap_data_access_group))
  expect_equal(dag_data$redcap_data_access_group, c("DAG1", "DAG2", "DAG3", NA))

  # Check for expected label
  out_dag_labelled <- out_dag %>% make_labelled()

  dag_label <- labelled::lookfor(out_dag_labelled$redcap_data[[1]])
  dag_label <- dag_label$label[dag_label$variable == "redcap_data_access_group"]

  expect_equal(dag_label, c("redcap_data_access_group" = "REDCap Data Access Group"))
})

test_that("read_redcap works with longitudinal Data Access Groups", {
  out_dag_long <- read_redcap(
    Sys.getenv("REDCAP_URI"),
    Sys.getenv("REDCAPTIDIER_LONGITUDINAL_DAG_API")
  )

  # Check for expected column and data
  dag_data_long <- out_dag_long$redcap_data[[1]]

  expect_true("redcap_data_access_group" %in% names(dag_data_long))
  expect_true(is.character(dag_data_long$redcap_data_access_group))
  expect_equal(dag_data_long$redcap_data_access_group, c("DAG1", "DAG1", "DAG2", "DAG2", "DAG3"))

  # Check for expected label
  out_dag_long_labelled <- out_dag_long %>% make_labelled()

  dag_label_long <- labelled::lookfor(out_dag_long_labelled$redcap_data[[1]])
  dag_label_long <- dag_label_long$label[dag_label_long$variable == "redcap_data_access_group"]

  expect_equal(dag_label_long, c("redcap_data_access_group" = "REDCap Data Access Group"))
})

test_that("read_redcap doesn't return the redcap_data_access_group column for non DAG databases", {
  out_no_dag <- read_redcap(
    Sys.getenv("REDCAP_URI"),
    Sys.getenv("REDCAPTIDIER_CLASSIC_API")
  ) %>%
    # suppress expected warning
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    ))

  # retrieve all names from all redcap_data list elements
  no_dag_all_names <- lapply(out_no_dag$redcap_data, names) %>% unlist()
  expect_true(!"redcap_data_access_group" %in% no_dag_all_names)
})

test_that("read_redcap fails if DAG or survey columns are explicitly requested but don't exist", {
  expect_error(
    out_no_dag <- read_redcap(Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_CLASSIC_API"),
      export_data_access_groups = TRUE
    ),
    class = "nonexistent_arg_requested"
  )

  expect_error(
    out_no_dag <- read_redcap(Sys.getenv("REDCAP_URI"),
      Sys.getenv("REDCAPTIDIER_DAG_API"),
      export_survey_fields = TRUE
    ),
    class = "nonexistent_arg_requested"
  )
})

test_that("read_redcap handles missing data codes", {
  out <- read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_MDC_API")) |>
    suppressWarnings(classes = c("field_is_logical", "extra_field_values")) |>
    extract_tibble("form_1")

  # logicals are not converted to NA
  expect_type(out$yesno, "logical")
  expect_true(!all(is.na(out$yesno)))
  # categoricals remove missing data codes
  expect_factor(out$dropdown)
  expect_true(all(is.na(out$dropdown) | out$dropdown != "UNK"))

  withr::with_options(list(redcaptidier.allow.mdc = TRUE), {
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_MDC_API"))
  }) |>
    expect_no_warning()
})

test_that("get_repeat_event_types() works", {
  mixed_data_structure <- tibble::tribble(
    ~"record_id", ~"redcap_event_name", ~"redcap_repeat_instrument", ~"redcap_repeat_instance",
    1, "nonrepeat", NA, NA,
    1, "repeat_together", NA, 1,
    1, "repeat_separate", "mixed_structure_form", 1
  )

  expected_out <- tibble::tribble(
    ~"redcap_event_name", ~"repeat_type",
    "nonrepeat", "nonrepeating",
    "repeat_together", "repeat_together",
    "repeat_separate", "repeat_separate"
  )

  out <- get_repeat_event_types(mixed_data_structure)

  expect_equal(out, expected_out)

  # Example with nonrepeating arm that contains repeating and non repeating forms
  mixed_data_structure <- tibble::tribble(
    ~"record_id", ~"redcap_event_name", ~"redcap_repeat_instrument", ~"redcap_repeat_instance",
    1, "nonrepeat", NA, NA,
    1, "nonrepeat", "repeat_form", 1,
    1, "repeat_together", NA, 1,
    1, "repeat_separate", "mixed_structure_form", 1
  )

  out <- get_repeat_event_types(mixed_data_structure)

  expected_out <- tibble::tribble(
    ~"redcap_event_name", ~"repeat_type",
    "nonrepeat", "repeat_separate",
    "repeat_together", "repeat_together",
    "repeat_separate", "repeat_separate"
  )

  expect_equal(out, expected_out)
})

test_that("update_dag_cols() works for labels", {
  dag_data <- tibble::tribble(
    ~"data_access_group_name", ~"unique_group_name", ~"data_access_group_id",
    "DAG1", "dag1", 28130,
    "DAG2", "dag2", 28131,
    "DAG3", "dag3", 28132
  )

  data <- tibble::tribble(
    ~record_id, ~redcap_data_access_group,
    1, "dag1",
    2, "dag2",
    3, "dag3"
  )

  out <- update_dag_cols(data, dag_data, raw_or_label = "label")

  expected_out <- tibble::tribble(
    ~record_id, ~redcap_data_access_group,
    1, "DAG1",
    2, "DAG2",
    3, "DAG3"
  )

  expect_equal(out, expected_out)
})

test_that("update_dag_cols() works for haven labels", {
  dag_data <- tibble::tribble(
    ~"data_access_group_name", ~"unique_group_name", ~"data_access_group_id",
    "DAG1", "dag1", 28130,
    "DAG2", "dag2", 28131,
    "DAG3", "dag3", 28132
  )

  data <- tibble::tribble(
    ~record_id, ~redcap_data_access_group,
    1, "dag1",
    2, "dag2",
    3, "dag3"
  )

  out <- update_dag_cols(data, dag_data, raw_or_label = "haven")

  labelled_vec <- data$redcap_data_access_group
  names(labelled_vec) <- dag_data$data_access_group_name

  expected_vec <- labelled::set_value_labels(data$redcap_data_access_group,
    .labels = labelled_vec
  )

  expected_out <- tibble::tibble(
    record_id = c(1, 2, 3),
    redcap_data_access_group = expected_vec
  )

  expected_out$redcap_data_access_group <- expected_vec

  expect_equal(out$redcap_data_access_group, expected_vec)
  expect_equal(out, expected_out)
})
