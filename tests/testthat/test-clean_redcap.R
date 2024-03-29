# Load Sample Databases ----
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

  out <- clean_redcap(
    db_data = db_data_classic,
    db_metadata = db_metadata_classic
  )

  # Check general structure
  expect_true(is_tibble(out))
  expect_true(all(c("repeating", "nonrepeating") %in% out$structure))
  expect_true(!is.null(out$redcap_data))
})

test_that("clean_redcap works with databases containing no repeating instruments", {
  db_metadata_classic_norepeat <- db_metadata_classic_norepeat %>%
    filter(.data$field_name_updated %in% names(db_data_classic_norepeat))

  out <- clean_redcap(
    db_data = db_data_classic_norepeat,
    db_metadata = db_metadata_classic_norepeat
  )

  # Check general structure
  expect_true(is_tibble(out))
  expect_true(!"repeating" %in% out$structure)
  expect_true("nonrepeating" %in% out$structure)
  expect_true(!is.null(out$redcap_data))
})

test_that("distill_nonrepeat_table tibble contains expected columns and data types for all REDCap field types", {
  out <- distill_nonrepeat_table(
    form_name = "data_field_types",
    db_data = db_data_classic,
    db_metadata = db_metadata_classic
  )

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

test_that("distill_repeat_table returns tables", {
  out <- distill_repeat_table(
    form_name = "repeated",
    db_data = db_data_classic,
    db_metadata = db_metadata_classic
  )

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
