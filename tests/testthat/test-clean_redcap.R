# Load Sample Databases ----
db_data_classic <- readRDS(system.file("testdata/db_data_classic.RDS", package = "REDCapTidieR"))
db_metadata_classic <- readRDS(system.file("testdata/db_metadata_classic.RDS", package = "REDCapTidieR"))

test_that("clean_redcap works", {
  out <- clean_redcap(db_data = db_data_classic,
                      db_metadata = db_metadata_classic)

  # Check general structure
  expect_true(is_tibble(out))
  expect_true(all(c("repeating", "nonrepeating") %in% out$structure))
  expect_true(!is.null(out$redcap_data))
})

test_that("extract_nonrepeat_table tibble contains expected columns and data types for all REDCap field types", {

  out <- extract_nonrepeat_table(form_name = "data_field_types",
                                 db_data = db_data_classic,
                                 db_metadata = db_metadata_classic)

  # Check general structure
  expect_true(is_tibble(out))

  # Check checkbox elements are present
  expect_true("checkbox_multiple___1" %in% names(out))

  # Check all data types are expected
  expect_character(out$text)
  expect_character(out$note)
  expect_double(out$calculated)
  expect_double(out$dropdown_single)
  expect_double(out$radio_single)
  expect_double(out$checkbox_multiple___1)
  expect_double(out$yesno)
  expect_double(out$truefalse)
  expect_character(out$signature)
  expect_character(out$fileupload)
  expect_double(out$slider)

  # Check last columns are form_status_complete
  expect_true(
    names(out[,ncol(out)]) == "form_status_complete"
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument","redcap_repeat_instance", "redcap_event", "redcap_arm") %in% names(out))
  )
})

test_that("extract_repeat_table returns tables", {
  out <- extract_repeat_table(form_name = "repeated",
                              db_data = db_data_classic,
                              db_metadata = db_metadata_classic)

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[,ncol(out)]) == "form_status_complete"
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument","redcap_event", "redcap_arm") %in% names(out))
  )
})
