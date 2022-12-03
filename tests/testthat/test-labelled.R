
test_that("make_labelled applies labels to all elements of supertibble", {
  supertbl <- tibble::tribble(
    ~redcap_data, ~redcap_metadata, ~redcap_events,
    tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"), tibble(redcap_event = "event_a"),
    tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label"), tibble(redcap_event = "event_b")
  )

  out <- make_labelled(supertbl)

  # Main labels are applied
  main_labs <- labelled::var_label(out)

  expected_main_labs <- list(
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    redcap_events = "Events and Arms Associated with this Instrument"
  )

  expect_equal(main_labs, expected_main_labs)

  # Labels are applied to both metadata tibbles
  expected_metadata_labs <- list(
    field_name = "Variable / Field Name",
    field_label = "Field Label"
  )

  metadata_labs1 <- labelled::var_label(out$redcap_metadata[[1]])
  metadata_labs2 <- labelled::var_label(out$redcap_metadata[[2]])

  expect_equal(metadata_labs1, expected_metadata_labs)
  expect_equal(metadata_labs2, expected_metadata_labs)

  # Labels are applied to both data tibbles

  data_labs1 <- labelled::var_label(out$redcap_data[[1]])
  data_labs2 <- labelled::var_label(out$redcap_data[[2]])

  expect_equal(data_labs1, list(x = "X Label"))
  expect_equal(data_labs2, list(y = "Y Label"))

  # Labels are applied to both event tibbles
  event_labs1 <- labelled::var_label(out$redcap_events[[1]])
  event_labs2 <- labelled::var_label(out$redcap_events[[2]])

  expect_equal(event_labs1, list(redcap_event = "Event Name"))
  expect_equal(event_labs2, list(redcap_event = "Event Name"))
})

test_that("make_labelled applies all predefined labeles", {
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
  )

  supertbl$redcap_data <- list(tibble::tribble(
    ~redcap_repeat_instance,
    ~redcap_event,
    ~redcap_arm,
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
  main_labs <- labelled::var_label(out)

  expected_main_labs <- list(
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

  expect_equal(main_labs, expected_main_labs)

  # Check metadata labs

  metadata_labs <- labelled::var_label(out$redcap_metadata[[1]])

  expected_metadata_labs <- list(
    field_name = "Variable / Field Name",
    field_label = "Field Label",
    field_type = "Field Type",
    section_header = "Section Header",
    field_note = "Field Note",
    text_validation_type_or_show_slider_number = "Text Validation Type OR Show Slider Number",
    text_validation_min = "Text Validation Min",
    text_validation_max = "Text Validation Max",
    identifier = "Identifier?",
    branching_logic = "Branching Logic (Show field only if...)",
    required_field = "Required Field?",
    custom_alignment = "Custom Alignment",
    question_number = "Question Number (surveys only)",
    matrix_group_name = "Matrix Group Name",
    matrix_ranking = "Matrix Ranking?",
    field_annotation = "Field Annotation"
  )

  expect_equal(metadata_labs, expected_metadata_labs)

  # Check data labs
  data_labs <- labelled::var_label(out$redcap_data[[1]])

  expected_data_labs <- list(
    redcap_repeat_instance = "REDCap Repeat Instance",
    redcap_event = "REDCap Event",
    redcap_arm = "REDCap Arm",
    redcap_survey_timestamp = "REDCap Survey Timestamp",
    redcap_survey_identifier = "REDCap Survey Identifier",
    form_status_complete = "REDCap Instrument Completed?"
  )

  expect_equal(data_labs, expected_data_labs)

  # Check event labs

  event_labs <- labelled::var_label(out$redcap_events[[1]])

  expected_event_labs <- list(
    redcap_event = "Event Name",
    redcap_arm = "Arm Name",
    arm_name = "Arm Description"
  )

  expect_equal(event_labs, expected_event_labs)
})

test_that("make_labelled handles supertibble with extra columns", {
  supertbl <- tibble::tribble(
    ~redcap_form_name, ~redcap_data, ~redcap_metadata, ~extra_field,
    "form_1", tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"), "extra"
  )

  out <- make_labelled(supertbl)

  labs <- labelled::var_label(out)

  expected_labs <- list(
    redcap_form_name = "REDCap Instrument Name",
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    extra_field = NULL
  )

  expect_equal(labs, expected_labs)
})

test_that("make_labelled handles redcap_metadata tibbles of different sizes ", {
  supertbl <- tibble::tribble(
    ~redcap_form_name, ~redcap_data, ~redcap_metadata,
    "form_1", tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"),
    "form_2", tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label", some_extra_metadata = "123")
  )

  out <- make_labelled(supertbl)

  base_metadata_labs <- list(
    field_name = "Variable / Field Name",
    field_label = "Field Label"
  )

  # Second instrument has normal metadata fields plus an additional field we
  # need to label correctly
  extra_metadata_labs <- c(
    base_metadata_labs, list(some_extra_metadata = NULL)
  )

  metadata_labs1 <- labelled::var_label(out$redcap_metadata[[1]])
  metadata_labs2 <- labelled::var_label(out$redcap_metadata[[2]])

  expect_equal(metadata_labs1, base_metadata_labs)
  expect_equal(metadata_labs2, extra_metadata_labs)
})

test_that("make_labelled handles supertibbles with NULL redcap_events", {
  supertbl <- tibble::tribble(
    ~redcap_data, ~redcap_metadata, ~redcap_events,
    tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"), tibble(redcap_event = "event_a"),
    tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label"), NULL
  )

  out <- make_labelled(supertbl)

  event_labs1 <- labelled::var_label(out$redcap_events[[1]])
  event_labs2 <- labelled::var_label(out$redcap_events[[2]])

  expect_false(is.null(event_labs1))
  expect_null(event_labs2)
})

test_that("format helpers work", {
  expect_equal(fmt_strip_whitespace("My   Label "), "My Label")
  expect_equal(fmt_strip_trailing_colon("My Label:"), "My Label")
  expect_equal(fmt_strip_trailing_punct("My Label-"), "My Label")
  expect_equal(fmt_strip_html("<b>My Label</b>"), "My Label")
  expect_equal(fmt_strip_field_embedding("My Label{abc}"), "My Label")
})

test_that("make_labelled accepts all valid input types to format_labels", {
  # This implicitly tests resolve_formatter

  supertbl <- tibble::tribble(
    ~redcap_data, ~redcap_metadata,
    tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label")
  )

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
