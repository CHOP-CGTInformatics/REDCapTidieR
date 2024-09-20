# Load Sample Databases ----
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
test_that("clean_redcap_long with arms works", {
  ## Check longitudinal structure with arms ----
  out <- clean_redcap_long(
    db_data_long = db_data_long,
    db_metadata_long = db_metadata_long,
    linked_arms = linked_arms_long
  )

  expect_true(is_tibble(out))
  expect_true(all(c("repeating", "nonrepeating") %in% out$structure))
  expect_true(!is.null(out$redcap_data))
})

test_that("clean_redcap_long works with databases containing no repeating instruments and arms", {
  ## Check longitudinal structure with arms ----
  out <- clean_redcap_long(
    db_data_long = db_data_long_norepeat,
    db_metadata_long = db_metadata_long_norepeat,
    linked_arms = linked_arms_long_norepeat
  )

  # Check general structure
  expect_true(is_tibble(out))
  expect_true(!"repeating" %in% out$structure)
  expect_true("nonrepeating" %in% out$structure)
  expect_true(!is.null(out$redcap_data))
})


test_that("clean_redcap_long without arms works", {
  ## Check longitudinal structure without arms ----
  out <- clean_redcap_long(
    db_data_long = db_data_long_noarms,
    db_metadata_long = db_metadata_long_noarms,
    linked_arms = linked_arms_long_noarms
  )

  expect_true(is_tibble(out))
  expect_true(all(c("repeating", "nonrepeating") %in% out$structure))
  expect_true(!is.null(out$redcap_data))
})

test_that("clean_redcap_long with mixed structure works", {
  # Required since amendments take place before clean_redcap_long call in read_redcap
  db_metadata_mixed_structure <- update_field_names(db_metadata_mixed_structure)

  # Expect error when allow_mixed_structure not specified
  expect_error(
    clean_redcap_long(
      db_data_long = db_mixed_structure,
      db_metadata_long = db_metadata_mixed_structure,
      linked_arms = db_mixed_structure_linked_arms
    ),
    class = "repeat_nonrepeat_instrument"
  )

  out <- clean_redcap_long(
    db_data_long = db_mixed_structure,
    db_metadata_long = db_metadata_mixed_structure,
    linked_arms = db_mixed_structure_linked_arms,
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
    1, "event_1", NA, "Mixed Nonrepeat 1", 0,
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

test_that("distill_nonrepeat_table_long tibble contains expected columns for longitudinal REDCap databases with arms", {
  ## Check longitudinal structure with arms ----
  out <- distill_nonrepeat_table_long(
    form_name = "nonrepeated",
    db_data_long = db_data_long,
    db_metadata_long = db_metadata_long,
    linked_arms = linked_arms_long
  )

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

test_that(paste(
  "distill_nonrepeat_table_long tibble contains expected columns",
  "for longitudinal REDCap databases without arms"
), {
  ## Check longitudinal structure without arms ----
  out <- distill_nonrepeat_table_long(
    form_name = "nonrepeated",
    db_data_long = db_data_long_noarms,
    db_metadata_long = db_metadata_long_noarms,
    linked_arms = linked_arms_long_noarms
  )

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
})

test_that("distill_repeat_table_long returns tables for REDCap dbs with arms", {
  ## Check longitudinal structure with arms ----
  out <- distill_repeat_table_long(
    form_name = "repeated",
    db_data_long = db_data_long,
    db_metadata_long = db_metadata_long,
    linked_arms = linked_arms_long
  )

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

test_that("distill_repeat_table_long no arms returns tables  for REDCap dbs without arms", {
  ## Check longitudinal structure without arms ----
  out <- distill_repeat_table_long(
    form_name = "repeated",
    db_data_long = db_data_long_noarms,
    db_metadata_long = db_metadata_long_noarms,
    linked_arms = linked_arms_long_noarms
  )

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

test_that("get_mixed_structure_fields works", {
  mixed_structure_db <- tibble::tribble(
    ~record_id, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~mixed_structure_variable,
    1, NA, NA, "A",
    2, "mixed_structure_form", 1, "B"
  )

  expected_out <- data.frame(
    field_name = "mixed_structure_variable",
    rep_and_nonrep = TRUE
  )

  out <- get_mixed_structure_fields(mixed_structure_db)

  expect_equal(out, expected_out)
})

test_that("convert_mixed_instrument works", {
  mixed_structure_db <- tibble::tribble(
    ~record_id, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~mixed_structure_variable,
    ~repeat_form_variable, ~mixed_repeat_var,
    1, NA, NA, "A", NA, NA,
    2, "mixed_structure_form", 1, "B", NA, NA,
    3, "repeat_form", 1, NA, "C", NA,
    4, "repeat_form", 2, NA, "D", NA,
    5, "mixed_repeat_together", 1, NA, NA, "E",
    5, "mixed_repeat_together", 2, NA, NA, "F"
  )

  mixed_structure_ref <- tibble::tribble(
    ~field_name, ~rep_and_nonrep, ~form_name,
    "mixed_structure_variable", TRUE, "mixed_structure_form",
    "mixed_repeat_var", TRUE, "mixed_repeat_together"
  )

  expected_out <- tibble::tribble(
    ~record_id, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~mixed_structure_variable,
    ~repeat_form_variable, ~mixed_repeat_var,
    1, "mixed_structure_form", NA, "A", NA, NA,
    2, "mixed_structure_form", 1, "B", NA, NA,
    3, "repeat_form", 1, NA, "C", NA,
    4, "repeat_form", 2, NA, "D", NA,
    5, "mixed_repeat_together", 1, NA, NA, "E",
    5, "mixed_repeat_together", 2, NA, NA, "F"
  )

  out <- convert_mixed_instrument(mixed_structure_db, mixed_structure_ref)

  expect_equal(out, expected_out)
})
