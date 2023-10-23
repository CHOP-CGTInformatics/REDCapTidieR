test_that("make_labelled applies labels to all elements of supertibble", {
  skip_if_not_installed(pkg = "labelled")
  supertbl <- tibble::tribble(
    ~redcap_data, ~redcap_metadata, ~redcap_events,
    tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"), tibble(redcap_event = "event_a"),
    tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label"), tibble(redcap_event = "event_b")
  ) %>%
    as_supertbl()

  out <- make_labelled(supertbl)

  # Main labels are applied
  main_labels <- labelled::var_label(out)

  expected_main_labels <- list(
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    redcap_events = "Events and Arms Associated with this Instrument"
  )

  expect_equal(main_labels, expected_main_labels)

  # Labels are applied to both metadata tibbles
  expected_metadata_labels <- list(
    field_name = "Variable / Field Name",
    field_label = "Field Label"
  )

  metadata_labels1 <- labelled::var_label(out$redcap_metadata[[1]])
  metadata_labels2 <- labelled::var_label(out$redcap_metadata[[2]])

  expect_equal(metadata_labels1, expected_metadata_labels)
  expect_equal(metadata_labels2, expected_metadata_labels)

  # Labels are applied to both data tibbles

  data_labels1 <- labelled::var_label(out$redcap_data[[1]])
  data_labels2 <- labelled::var_label(out$redcap_data[[2]])

  expect_equal(data_labels1, list(x = "X Label"))
  expect_equal(data_labels2, list(y = "Y Label"))

  # Labels are applied to both event tibbles
  event_labels1 <- labelled::var_label(out$redcap_events[[1]])
  event_labels2 <- labelled::var_label(out$redcap_events[[2]])

  expect_equal(event_labels1, list(redcap_event = "Event Name"))
  expect_equal(event_labels2, list(redcap_event = "Event Name"))
})

test_that("make_labelled applies all predefined labeles", {
  skip_if_not_installed(pkg = "labelled")
  # Set up supertibble
  supertbl <- tibble(
    redcap_form_name = NA,
    redcap_form_label = NA,
    redcap_data = NA,
    redcap_metadata = NA,
    redcap_events = NA,
    structure = NA,
    data_rows = NA,
    data_cols = NA,
    data_size = NA,
    data_na_pct = NA
  ) %>%
    as_supertbl()


  supertbl$redcap_data <- list(tibble::tribble(
    ~redcap_form_instance,
    ~redcap_event_instance,
    ~redcap_event,
    ~redcap_arm,
    ~redcap_data_access_group,
    ~redcap_survey_timestamp,
    ~redcap_survey_identifier,
    ~form_status_complete
  ))

  supertbl$redcap_metadata <- list(tibble::tribble(
    ~field_name,
    ~field_label,
    ~field_type,
    ~section_header,
    ~field_note,
    ~text_validation_type_or_show_slider_number,
    ~text_validation_min,
    ~text_validation_max,
    ~identifier,
    ~branching_logic,
    ~required_field,
    ~custom_alignment,
    ~question_number,
    ~matrix_group_name,
    ~matrix_ranking,
    ~field_annotation
  ))

  supertbl$redcap_events <- list(tibble::tribble(
    ~redcap_event,
    ~redcap_arm,
    ~arm_name
  ))

  out <- make_labelled(supertbl)

  # Check main labs
  main_labels <- labelled::var_label(out)

  expected_main_labels <- list(
    redcap_form_name = "REDCap Instrument Name",
    redcap_form_label = "REDCap Instrument Description",
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    redcap_events = "Events and Arms Associated with this Instrument",
    structure = "Repeating or Nonrepeating?",
    data_rows = "# of Rows in Data",
    data_cols = "# of Columns in Data",
    data_size = "Data size in Memory",
    data_na_pct = "% of Data Missing"
  )

  expect_equal(main_labels, expected_main_labels)

  # Check metadata labs

  metadata_labels <- labelled::var_label(out$redcap_metadata[[1]])

  expected_metadata_labels <- list(
    field_name = "Variable / Field Name",
    field_label = "Field Label",
    field_type = "Field Type",
    section_header = "Section Header Prior to this Field",
    field_note = "Field Note",
    text_validation_type_or_show_slider_number = "Text Validation Type OR Show Slider Number",
    text_validation_min = "Minimum Accepted Value for Text Validation",
    text_validation_max = "Maximum Accepted Value for Text Validation",
    identifier = "Is this Field an Identifier?",
    branching_logic = "Branching Logic (Show field only if...)",
    required_field = "Is this Field Required?",
    custom_alignment = "Custom Alignment",
    question_number = "Question Number (surveys only)",
    matrix_group_name = "Matrix Group Name",
    matrix_ranking = "Matrix Ranking?",
    field_annotation = "Field Annotation"
  )

  expect_equal(metadata_labels, expected_metadata_labels)

  # Check data labs
  data_labels <- labelled::var_label(out$redcap_data[[1]])

  expected_data_labels <- list(
    redcap_form_instance = "REDCap Form Instance",
    redcap_event_instance = "REDCap Event Instance",
    redcap_event = "REDCap Event",
    redcap_arm = "REDCap Arm",
    redcap_data_access_group = "REDCap Data Access Group",
    redcap_survey_timestamp = "REDCap Survey Timestamp",
    redcap_survey_identifier = "REDCap Survey Identifier",
    form_status_complete = "REDCap Instrument Completed?"
  )

  expect_equal(data_labels, expected_data_labels)

  # Check event labs

  event_labels <- labelled::var_label(out$redcap_events[[1]])

  expected_event_labels <- list(
    redcap_event = "Event Name",
    redcap_arm = "Arm Name",
    arm_name = "Arm Description"
  )

  expect_equal(event_labels, expected_event_labels)
})

test_that("make_labelled handles supertibble with extra columns", {
  skip_if_not_installed(pkg = "labelled")

  supertbl <- tibble::tribble(
    ~redcap_form_name, ~redcap_data, ~redcap_metadata, ~extra_field,
    "form_1", tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"), "extra"
  ) %>%
    as_supertbl()

  out <- make_labelled(supertbl)

  labs <- labelled::var_label(out)

  expected_labels <- list(
    redcap_form_name = "REDCap Instrument Name",
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    extra_field = NULL
  )

  expect_equal(labs, expected_labels)
})

test_that("make_labelled handles redcap_metadata tibbles of different sizes ", {
  supertbl <- tibble::tribble(
    ~redcap_form_name, ~redcap_data, ~redcap_metadata,
    "form_1", tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"),
    "form_2", tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label", some_extra_metadata = "123")
  ) %>%
    as_supertbl()

  out <- make_labelled(supertbl)

  base_metadata_labels <- list(
    field_name = "Variable / Field Name",
    field_label = "Field Label"
  )

  # Second instrument has normal metadata fields plus an additional field we
  # need to label correctly
  extra_metadata_labels <- c(
    base_metadata_labels, list(some_extra_metadata = NULL)
  )

  metadata_labels1 <- labelled::var_label(out$redcap_metadata[[1]])
  metadata_labels2 <- labelled::var_label(out$redcap_metadata[[2]])

  expect_equal(metadata_labels1, base_metadata_labels)
  expect_equal(metadata_labels2, extra_metadata_labels)
})

test_that("make_labelled handles supertibbles with NULL redcap_events", {
  skip_if_not_installed(pkg = "labelled")

  supertbl <- tibble::tribble(
    ~redcap_data, ~redcap_metadata, ~redcap_events,
    tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"), tibble(redcap_event = "event_a"),
    tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label"), NULL
  ) %>%
    as_supertbl()

  out <- make_labelled(supertbl)

  event_labels1 <- labelled::var_label(out$redcap_events[[1]])
  event_labels2 <- labelled::var_label(out$redcap_events[[2]])

  expect_false(is.null(event_labels1))
  expect_null(event_labels2)
})

test_that("format helpers work", {
  expect_equal(fmt_strip_whitespace("My   Label "), "My Label")
  expect_equal(fmt_strip_trailing_colon("My Label:"), "My Label")
  expect_equal(fmt_strip_trailing_punct("My Label-"), "My Label")
  expect_equal(fmt_strip_html("<b>My Label</b>"), "My Label")
  expect_equal(fmt_strip_field_embedding("My Label{abc}"), "My Label")
})

test_that("make_labelled accepts all valid input types to format_labels", {
  skip_if_not_installed(pkg = "labelled")

  # This implicitly tests resolve_formatter
  supertbl <- tibble::tribble(
    ~redcap_data, ~redcap_metadata,
    tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label")
  ) %>%
    as_supertbl()

  # NULL
  out <- make_labelled(supertbl, format_labels = NULL)

  labs <- labelled::var_label(out$redcap_data[[1]])

  expect_equal(labs, list(x = "X Label"))

  # function
  out <- make_labelled(supertbl, format_labels = tolower)

  labs <- labelled::var_label(out$redcap_data[[1]])

  expect_equal(labs, list(x = "x label"))

  # character
  out <- make_labelled(supertbl, format_labels = "tolower")

  labs <- labelled::var_label(out$redcap_data[[1]])

  expect_equal(labs, list(x = "x label"))

  # formula function
  out <- make_labelled(supertbl, format_labels = ~ paste0(., "!"))

  labs <- labelled::var_label(out$redcap_data[[1]])

  expect_equal(labs, list(x = "X Label!"))

  # list
  out <- make_labelled(supertbl, format_labels = list(tolower, ~ paste0(., "!")))

  labs <- labelled::var_label(out$redcap_data[[1]])

  expect_equal(labs, list(x = "x label!"))

  # unsupported
  make_labelled(supertbl, format_labels = 1) %>%
    expect_error(class = "unresolved_formatter")
})

test_that("make_labelled errors with bad inputs", {
  # Input to format_labels is tested above

  expect_error(make_labelled(123), class = "check_supertbl")
  skip_if_not_installed(pkg = "labelled")

  missing_col_supertbl <- tibble(redcap_data = list()) %>%
    as_supertbl()
  missing_list_col_supertbl <- tibble(redcap_data = list(), redcap_metadata = 123) %>%
    as_supertbl()

  expect_error(make_labelled(missing_col_supertbl), class = "missing_req_cols")
  expect_error(make_labelled(missing_list_col_supertbl), class = "missing_req_list_cols")
})

test_that("make_labelled preserves S3 class", {
  out <- make_labelled(superheroes_supertbl)

  expect_s3_class(out, "redcap_supertbl")
})

test_that("make_labelled returns expected skimr labels", {
  skip_if_not_installed(pkg = "labelled")

  supertbl_skimr_meta <- make_skimr_labels() %>%
    names() %>%
    as_tibble() %>%
    dplyr::rename("name" = value) %>%
    dplyr::mutate(value = NA) %>%
    tidyr::pivot_wider()

  # Add skimr metadata to a sample supertbl
  supertbl <- tibble::tribble(
    ~redcap_data, ~redcap_metadata, ~redcap_events,
    tibble(x = letters[1:3]),
    tibble(field_name = "x", field_label = "X Label", supertbl_skimr_meta),
    tibble(redcap_event = "event_a")
  ) %>%
    as_supertbl()

  # Create expectations
  out <- make_labelled(supertbl)

  skimr_labels <- labelled::var_label(out$redcap_metadata[[1]])

  expected_skimr_labels <- c(
    field_name = "Variable / Field Name",
    field_label = "Field Label",
    skim_type = "Data Type",
    n_missing = "Count of Missing Values",
    complete_rate = "Proportion of Non-Missing Values",
    AsIs.n_unique = "Count of Unique Values in AsIs",
    AsIs.min_length = "Minimum Length of AsIs Values",
    AsIs.max_length = "Maximum Length of AsIs Values",
    character.min = "Shortest Value (Fewest Characters)",
    character.max = "Longest Value (Most Characters)",
    character.empty = "Count of Empty Values",
    character.n_unique = "Count of Unique Values",
    character.whitespace = "Count of Values that are all Whitespace",
    Date.min = "Earliest",
    Date.max = "Latest",
    Date.median = "Median",
    Date.n_unique = "Count of Unique Values",
    difftime.min = "Minimum",
    difftime.max = "Maximum",
    difftime.median = "Median",
    difftime.n_unique = "Count of Unique Values",
    factor.ordered = "Is the Categorical Value Ordered?",
    factor.n_unique = "Count of Unique Values",
    factor.top_counts = "Most Frequent Values",
    logical.mean = "Proportion of TRUE Values",
    logical.count = "Count of Logical Values",
    numeric.mean = "Mean",
    numeric.sd = "Standard Deviation ",
    numeric.p0 = "Minimum",
    numeric.p25 = "25th Percentile",
    numeric.p50 = "Median",
    numeric.p75 = "75th Percentile",
    numeric.p100 = "Maximum",
    numeric.hist = "Histogram",
    POSIXct.min = "Earliest",
    POSIXct.max = "Latest",
    POSIXct.median = "Median",
    POSIXct.n_unique = "Count of Unique Values"
  )

  expect_true(all(skimr_labels %in% expected_skimr_labels))
})
