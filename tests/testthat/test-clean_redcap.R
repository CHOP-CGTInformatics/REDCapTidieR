# Classic projects ----
db_data_classic <-
  readRDS(system.file("testdata/db_data_classic.RDS", package = "REDCapTidieR"))
db_metadata_classic <-
  readRDS(system.file("testdata/db_metadata_classic.RDS", package = "REDCapTidieR"))
db_data_classic_norepeat <-
  readRDS(system.file("testdata/db_data_classic_norepeat.RDS", package = "REDCapTidieR"))
db_metadata_classic_norepeat <-
  readRDS(system.file("testdata/db_metadata_classic_norepeat.RDS", package = "REDCapTidieR"))

test_that("clean_redcap works", {
  db_metadata_classic <- db_metadata_classic %>%
    filter(.data$field_name_updated %in% names(db_data_classic))

  form_structure <- tibble(
    redcap_form_name = c(
      "nonrepeated",
      "nonrepeated2",
      "repeated",
      "data_field_types",
      "text_input_validation_types",
      "api_no_access",
      "api_no_access_2",
      "survey",
      "repeat_survey"
    ),
    structure = c(
      "nonrepeating",
      "nonrepeating",
      "repeating",
      "nonrepeating",
      "nonrepeating",
      "nonrepeating",
      "nonrepeating",
      "nonrepeating",
      "repeating"
    )
  )

  out <- clean_redcap(
    db_data = db_data_classic,
    db_metadata = db_metadata_classic,
    form_structure = form_structure
  )

  # Check general structure
  expect_true(is_tibble(out))
  expect_identical(
    out$redcap_form_name,
    c("repeated", "repeat_survey", form_structure$redcap_form_name[form_structure$structure == "nonrepeating"])
  )
  expect_true(!is.null(out$redcap_data))
})

test_that("clean_redcap works with databases containing no repeating instruments", {
  db_metadata_classic_norepeat <- db_metadata_classic_norepeat %>%
    filter(.data$field_name_updated %in% names(db_data_classic_norepeat))

  form_structure <- tibble(
    redcap_form_name = c(
      "nonrepeated",
      "nonrepeated2",
      "data_field_types",
      "text_input_validation_types",
      "api_no_access",
      "api_no_access_2"
    ),
    structure = "nonrepeating"
  )

  out <- clean_redcap(
    db_data = db_data_classic_norepeat,
    db_metadata = db_metadata_classic_norepeat,
    form_structure = form_structure
  )

  # Check general structure
  expect_true(is_tibble(out))
  expect_true(!"repeating" %in% out$structure)
  expect_true("nonrepeating" %in% out$structure)
  expect_true(!is.null(out$redcap_data))
})

test_that("an empty instrument selection returns a typed empty tibble", {
  forms <- tibble(redcap_form_name = character(), structure = character())
  expect_identical(
    clean_redcap(tibble(), tibble(), forms),
    tibble(redcap_form_name = character(), redcap_data = list(), structure = character())
  )
})

test_that("classic nonrepeating instruments preserve REDCap field types", {
  out <- clean_redcap(
    db_data = db_data_classic,
    db_metadata = db_metadata_classic,
    form_structure = tibble(redcap_form_name = "data_field_types", structure = "nonrepeating")
  )$redcap_data[[1]]

  # Check to ensure field names do not appear from other instruments
  # (See GH Issue #39 / PR #40)
  field_names_from_other_forms <- db_metadata_classic %>%
    filter(form_name != "data_field_types", field_name != "record_id") %>%
    pull(field_name)

  expect_true(!any(field_names_from_other_forms %in% names(out)))

  # Check general structure
  expect_true(is_tibble(out))

  # Check checkbox elements are present
  checkbox_cols <- c(
    "checkbox_multiple___1",
    "checkbox_multiple___2",
    "checkbox_multiple___3",
    "checkbox_multiple___4",
    "checkbox_multiple___5",
    "checkbox_multiple___6",
    "checkbox_multiple___7",
    "checkbox_multiple___8",
    "checkbox_multiple___9",
    "checkbox_multiple___10",
    "checkbox_multiple_2___aa",
    "checkbox_multiple_2___b1b",
    "checkbox_multiple_2___ccc2",
    "checkbox_multiple_2___3dddd",
    "checkbox_multiple_2___4eeee5"
  )
  expect_true(all(checkbox_cols %in% names(out)))

  # Check all data types are expected
  expect_character(out$text)
  expect_character(out$note)
  expect_double(out$calculated)
  expect_character(out$dropdown_single)
  expect_character(out$radio_single)
  expect_double(out$checkbox_multiple___1)
  expect_double(out$yesno)
  expect_double(out$truefalse)
  expect_character(out$signature)
  expect_character(out$fileupload)
  expect_double(out$slider)

  # Check last columns are form_status_complete
  expect_true(
    names(out[, ncol(out)]) == "form_status_complete"
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument", "redcap_event", "redcap_arm") %in% names(out))
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(out$record_id))
  )
})

test_that("classic repeating instruments retain form instance keys", {
  out <- clean_redcap(
    db_data = db_data_classic,
    db_metadata = db_metadata_classic,
    form_structure = tibble(redcap_form_name = "repeated", structure = "repeating")
  )$redcap_data[[1]]

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[, ncol(out)]) == "form_status_complete"
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument", "redcap_event", "redcap_arm") %in% names(out))
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(c(out$record_id, out$redcap_form_instance)))
  )
})

# Longitudinal projects ----
# Arms datasets
db_data_long <- readRDS(
  system.file("testdata/db_data_long.RDS", package = "REDCapTidieR")
)
db_metadata_long <- readRDS(
  system.file("testdata/db_metadata_long.RDS", package = "REDCapTidieR")
)
linked_arms_long <- readRDS(
  system.file("testdata/linked_arms_long.RDS", package = "REDCapTidieR")
)
db_data_long_norepeat <- readRDS(
  system.file("testdata/db_data_long_norepeat.RDS", package = "REDCapTidieR")
)
db_metadata_long_norepeat <- readRDS(
  system.file("testdata/db_metadata_long_norepeat.RDS", package = "REDCapTidieR")
)
linked_arms_long_norepeat <- readRDS(
  system.file("testdata/linked_arms_long_norepeat.RDS", package = "REDCapTidieR")
)
# No arms datasets
db_data_long_noarms <- readRDS(
  system.file("testdata/db_data_long_noarms.RDS", package = "REDCapTidieR")
)
db_metadata_long_noarms <- readRDS(
  system.file("testdata/db_metadata_long_noarms.RDS", package = "REDCapTidieR")
)
linked_arms_long_noarms <- readRDS(
  system.file("testdata/linked_arms_long_noarms.RDS", package = "REDCapTidieR")
)
db_mixed_structure <- readRDS(
  system.file("testdata/db_mixed_structure.RDS", package = "REDCapTidieR")
)
db_metadata_mixed_structure <- readRDS(
  system.file("testdata/db_metadata_mixed_structure.RDS", package = "REDCapTidieR")
)
db_mixed_structure_linked_arms <- readRDS(
  system.file("testdata/db_mixed_structure_linked_arms.RDS", package = "REDCapTidieR")
)

# Run Tests ----
test_that("clean_redcap with arms works", {
  form_structure <- tibble(
    redcap_form_name = c("nonrepeated", "nonrepeated2", "repeated"),
    structure = c("nonrepeating", "nonrepeating", "repeating")
  )

  ## Check longitudinal structure with arms ----
  out <- clean_redcap(
    db_data = db_data_long,
    db_metadata = db_metadata_long,
    linked_arms = linked_arms_long,
    form_structure = form_structure
  )

  expect_true(is_tibble(out))
  expect_identical(out$redcap_form_name, c("repeated", "nonrepeated", "nonrepeated2"))
  expect_identical(out$structure, c("repeating", "nonrepeating", "nonrepeating"))
  expect_true(!is.null(out$redcap_data))
})

test_that("clean_redcap works with databases containing no repeating instruments and arms", {
  form_structure <- tibble(
    redcap_form_name = c("nonrepeated", "nonrepeated2"),
    structure = "nonrepeating"
  )

  ## Check longitudinal structure with arms ----
  out <- clean_redcap(
    db_data = db_data_long_norepeat,
    db_metadata = db_metadata_long_norepeat,
    linked_arms = linked_arms_long_norepeat,
    form_structure = form_structure
  )

  # Check general structure
  expect_true(is_tibble(out))
  expect_true(!"repeating" %in% out$structure)
  expect_true("nonrepeating" %in% out$structure)
  expect_true(!is.null(out$redcap_data))
})


test_that("clean_redcap without arms works", {
  form_structure <- tibble(
    redcap_form_name = c("nonrepeated", "nonrepeated2", "repeated"),
    structure = c("nonrepeating", "nonrepeating", "repeating")
  )

  ## Check longitudinal structure without arms ----
  out <- clean_redcap(
    db_data = db_data_long_noarms,
    db_metadata = db_metadata_long_noarms,
    linked_arms = linked_arms_long_noarms,
    form_structure = form_structure
  )

  expect_true(is_tibble(out))
  expect_true(all(c("repeating", "nonrepeating") %in% out$structure))
  expect_true(!is.null(out$redcap_data))
})

test_that("clean_redcap with mixed structure works", {
  form_structure <- tibble(
    redcap_form_name = c("nonrepeat_form", "repeat_form", "mixed_structure_form"),
    structure = c("nonrepeating", "repeating", "mixed")
  )

  # Required since amendments take place before clean_redcap call in read_redcap
  db_metadata_mixed_structure <- update_field_names(db_metadata_mixed_structure)

  # Expect error when allow_mixed_structure not specified
  expect_error(
    clean_redcap(
      db_data = db_mixed_structure,
      db_metadata = db_metadata_mixed_structure,
      linked_arms = db_mixed_structure_linked_arms,
      form_structure = form_structure
    ),
    class = "repeat_nonrepeat_instrument"
  )

  out <- clean_redcap(
    db_data = db_mixed_structure,
    db_metadata = db_metadata_mixed_structure,
    linked_arms = db_mixed_structure_linked_arms,
    form_structure = form_structure,
    allow_mixed_structure = TRUE
  )

  # Check general structure, check all three structure types present
  expect_true(is_tibble(out))
  expect_true("mixed" %in% out$structure)
  expect_true("nonrepeating" %in% out$structure)
  expect_true("repeating" %in% out$structure)
  expect_true(!is.null(out$redcap_data))

  # Check redcap_data contents for mixed and nonrepeating structure
  expected_mixed_data <- tibble::tribble(
    ~record_id, ~redcap_event, ~redcap_form_instance, ~mixed_structure_1, ~form_status_complete,
    1, "event_1", 1, "Mixed Nonrepeat 1", 0,
    1, "event_2", 1, "Mixed Repeat 1", 0,
    1, "event_2", 2, "Mixed Repeat 2", 0
  )

  expected_nonrepeat_data <- tibble::tribble(
    ~record_id, ~redcap_event, ~nonrepeat_1, ~form_status_complete,
    1, "event_1", "Nonrepeat 1", 0,
    1, "event_2", "Nonrepeat 2", 0
  )

  expect_equal(
    out$redcap_data[out$redcap_form_name == "mixed_structure_form"][[1]],
    expected_mixed_data
  )

  expect_equal(
    out$redcap_data[out$redcap_form_name == "nonrepeat_form"][[1]],
    expected_nonrepeat_data
  )
})

test_that("longitudinal nonrepeating instruments retain event and arm keys", {
  ## Check longitudinal structure with arms ----
  out <- clean_redcap(
    db_data = db_data_long,
    db_metadata = db_metadata_long,
    form_structure = tibble(redcap_form_name = "nonrepeated", structure = "nonrepeating"),
    linked_arms = linked_arms_long
  )$redcap_data[[1]]

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[, ncol(out)]) == "form_status_complete"
  )

  # Check for expected longitudinal arms columns
  expect_true(
    all(c("redcap_event", "redcap_arm") %in% names(out))
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(c(out$record_id, out$redcap_event, out$redcap_arm)))
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument", "redcap_form_instance") %in% names(out))
  )
})

test_that(
  "longitudinal nonrepeating instruments omit the arm key for a single arm",
  {
    ## Check longitudinal structure without arms ----
    out <- clean_redcap(
      db_data = db_data_long_noarms,
      db_metadata = db_metadata_long_noarms,
      form_structure = tibble(redcap_form_name = "nonrepeated", structure = "nonrepeating"),
      linked_arms = linked_arms_long_noarms
    )$redcap_data[[1]]

    # Check general structure
    expect_true(is_tibble(out))

    # Check last columns are form_status_complete
    expect_true(
      names(out[, ncol(out)]) == "form_status_complete"
    )

    # Check for expected longitudinal arms columns
    expect_true(
      "redcap_event" %in% names(out)
    )

    # Check partial keys are filled out
    expect_false(
      any(is.na(c(out$record_id, out$redcap_event)))
    )

    # Check columns expected to be missing aren't included
    expect_false(
      any(c("redcap_repeat_instrument", "redcap_form_instance", "redcap_arm") %in% names(out))
    )
  }
)

test_that("longitudinal repeating instruments retain event, arm, and form instance keys", {
  ## Check longitudinal structure with arms ----
  out <- clean_redcap(
    db_data = db_data_long,
    db_metadata = db_metadata_long,
    form_structure = tibble(redcap_form_name = "repeated", structure = "repeating"),
    linked_arms = linked_arms_long
  )$redcap_data[[1]]

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[, ncol(out)]) == "form_status_complete"
  )

  # Check for expected longitudinal arms columns
  expect_true(
    all(
      c("redcap_form_instance", "redcap_event", "redcap_arm") %in% names(out)
    )
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(c(out$record_id, out$redcap_event, out$redcap_arm)))
  )

  # Check columns expected to be missing aren't included
  expect_false(
    "redcap_repeat_instrument" %in% names(out)
  )
})

test_that("longitudinal repeating instruments omit the arm key for a single arm", {
  ## Check longitudinal structure without arms ----
  out <- clean_redcap(
    db_data = db_data_long_noarms,
    db_metadata = db_metadata_long_noarms,
    form_structure = tibble(redcap_form_name = "repeated", structure = "repeating"),
    linked_arms = linked_arms_long_noarms
  )$redcap_data[[1]]

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[, ncol(out)]) == "form_status_complete"
  )

  # Check for expected longitudinal no arms columns
  expect_true(
    all(c("redcap_form_instance", "redcap_event") %in% names(out))
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(c(out$record_id, out$redcap_event)))
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument", "redcap_arm") %in% names(out))
  )
})

test_that("survey and data access group fields follow project-specific row rules", {
  visit_timestamp <- as.POSIXct("2020-01-01", tz = "UTC")
  data <- tibble(
    id = 1:6,
    redcap_event_name = c("visit_arm_1b", "visit_arm_1b", "other_arm_2", rep("visit_arm_1b", 3)),
    redcap_repeat_instrument = c(rep(NA_character_, 4), "repeat_form", "repeat_form"),
    redcap_repeat_instance = c(1L, 2L, NA_integer_, NA_integer_, 1L, 2L),
    redcap_data_access_group = c("group", NA, "group", NA, "group", NA),
    visit_value = c(NA, NA, "unmapped", NA, NA, NA),
    repeat_value = c(NA, NA, NA, NA, "repeat", NA),
    visit_timestamp = visit_timestamp[c(1L, 1L, 1L, 1L, NA_integer_, NA_integer_)],
    redcap_survey_identifier = c(rep("survey", 4), NA, NA),
    visit_complete = c(rep(2L, 4), NA_integer_, NA_integer_),
    repeat_form_complete = c(rep(NA_integer_, 4), 2L, 2L)
  )
  forms <- tibble(redcap_form_name = c("visit", "repeat_form"), structure = c("nonrepeating", "repeating"))
  metadata <- tibble(form_name = forms$redcap_form_name, field_name_updated = c("visit_value", "repeat_value"))
  event_mapping <- tibble(
    form = c("visit", "repeat_form", "unrequested"),
    unique_event_name = c("visit_arm_1b", "visit_arm_1b", "other_arm_2")
  )

  longitudinal <- clean_redcap(data, metadata, forms, linked_arms = event_mapping)
  expect_identical(longitudinal$redcap_form_name, c("repeat_form", "visit"))
  expect_identical(
    longitudinal$redcap_data[[1]],
    tibble(
      id = 5L, redcap_event = "visit", redcap_arm = "1b", redcap_form_instance = 1L,
      redcap_data_access_group = "group", repeat_value = "repeat", form_status_complete = 2L
    )
  )
  expect_identical(
    longitudinal$redcap_data[[2]],
    tibble(
      id = 1L, redcap_event = "visit", redcap_arm = "1b", redcap_event_instance = 1L,
      redcap_data_access_group = "group", visit_value = NA_character_,
      redcap_survey_identifier = "survey", redcap_survey_timestamp = visit_timestamp,
      form_status_complete = 2L
    )
  )

  empty <- clean_redcap(data, metadata, forms, linked_arms = event_mapping[0, ])
  expect_identical(
    empty$redcap_data,
    list(
      select(longitudinal$redcap_data[[1]][0, ], -"redcap_arm", -"redcap_form_instance"),
      select(longitudinal$redcap_data[[2]][0, ], -"redcap_arm", -"redcap_event_instance")
    )
  )

  classic <- clean_redcap(select(data, -"redcap_event_name"), metadata, forms)
  expect_identical(classic$redcap_data[[1]]$id, c(5L, 6L))
  expect_identical(
    names(classic$redcap_data[[1]]),
    c("id", "redcap_form_instance", "redcap_data_access_group", "repeat_value", "form_status_complete")
  )
  expect_identical(
    classic$redcap_data[[2]],
    tibble(
      id = 3:4, redcap_data_access_group = c("group", NA), visit_value = c("unmapped", NA),
      redcap_survey_identifier = rep("survey", 2), redcap_survey_timestamp = rep(visit_timestamp, 2),
      form_status_complete = rep(2L, 2)
    )
  )
})

test_that("a form_name field does not affect repeating instrument selection", {
  data <- tibble(
    record_id = 1:2,
    redcap_repeat_instrument = c("follow_up", "other"),
    redcap_repeat_instance = c(1L, 1L),
    redcap_data_access_group = c("a", "b"),
    follow_up_value = c("response", NA),
    form_name = c(NA, "other"),
    follow_up_complete = c(2L, NA_integer_),
    other_complete = c(NA_integer_, 2L)
  )
  forms <- tibble(redcap_form_name = c("follow_up", "other"), structure = "repeating")
  metadata <- tibble(
    form_name = forms$redcap_form_name,
    field_name_updated = c("follow_up_value", "form_name")
  )
  event_mapping <- tibble(form = forms$redcap_form_name, unique_event_name = "visit_arm_1")

  classic <- clean_redcap(data, metadata, forms)
  expect_identical(map(classic$redcap_data, "record_id"), list(1L, 2L))

  longitudinal_data <- mutate(data, redcap_event_name = "visit_arm_1")
  longitudinal <- clean_redcap(longitudinal_data, metadata, forms, linked_arms = event_mapping)
  expect_identical(map(longitudinal$redcap_data, "record_id"), list(1L, 2L))
})

test_that("mixed instruments independently retain rows from a shared repeating event", {
  data <- tibble(
    id = rep(1L, 3),
    redcap_event_name = c("together_arm_1", "separate_arm_1", "separate_arm_1"),
    redcap_repeat_instrument = c(NA, "first", "second"),
    redcap_repeat_instance = rep(1L, 3),
    first_value = c("first together", "first separately", NA),
    second_value = c("second together", NA, "second separately"),
    first_complete = c(2L, 2L, NA_integer_),
    second_complete = c(2L, NA_integer_, 2L)
  )
  forms <- tibble(redcap_form_name = c("first", "second"), structure = "mixed")
  metadata <- tibble(
    form_name = forms$redcap_form_name,
    field_name = c("first_value", "second_value"),
    field_name_updated = field_name
  )
  event_mapping <- tidyr::expand_grid(
    form = forms$redcap_form_name,
    unique_event_name = c("together_arm_1", "separate_arm_1")
  )

  out <- clean_redcap(data, metadata, forms, linked_arms = event_mapping, allow_mixed_structure = TRUE)
  expected <- tibble(
    id = c(1L, 1L), redcap_event = c("together", "separate"),
    redcap_form_instance = c(NA_real_, 1), redcap_event_instance = c(1, NA_real_),
    first_value = c("first together", "first separately"), form_status_complete = c(2L, 2L)
  )
  expect_identical(out$redcap_data[[1]], expected)

  expected <- mutate(expected, first_value = c("second together", "second separately"))
  expected <- rename(expected, second_value = "first_value")
  expect_identical(out$redcap_data[[2]], expected)
})
