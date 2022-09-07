# Load Sample Databases ----
# Arms datasets
db_data_long <- readRDS(system.file("testdata/db_data_long.RDS", package = "REDCapTidieR"))
db_metadata_long <- readRDS(system.file("testdata/db_metadata_long.RDS", package = "REDCapTidieR"))
linked_arms_long <- readRDS(system.file("testdata/linked_arms_long.RDS", package = "REDCapTidieR"))
db_data_long_norepeat <- readRDS(system.file("testdata/db_data_long_norepeat.RDS", package = "REDCapTidieR"))
db_metadata_long_norepeat <- readRDS(system.file("testdata/db_metadata_long_norepeat.RDS", package = "REDCapTidieR"))
linked_arms_long_norepeat <- readRDS(system.file("testdata/linked_arms_long_norepeat.RDS", package = "REDCapTidieR"))
# No arms datasets
db_data_long_noarms <- readRDS(system.file("testdata/db_data_long_noarms.RDS", package = "REDCapTidieR"))
db_metadata_long_noarms <- readRDS(system.file("testdata/db_metadata_long_noarms.RDS", package = "REDCapTidieR"))
linked_arms_long_noarms <- readRDS(system.file("testdata/linked_arms_long_noarms.RDS", package = "REDCapTidieR"))

# Run Tests ----
test_that("clean_redcap_long with arms works", {
  ## Check longitudinal structure with arms ----
  out <- clean_redcap_long(db_data_long = db_data_long,
                           db_metadata_long = db_metadata_long,
                           linked_arms = linked_arms_long)

  expect_true(is_tibble(out))
  expect_true(all(c("repeating", "nonrepeating") %in% out$structure))
  expect_true(!is.null(out$redcap_data))
})

test_that("clean_redcap_long works with databases containing no repeating instruments and arms", {
  ## Check longitudinal structure with arms ----
  out <- clean_redcap_long(db_data_long = db_data_long_norepeat,
                           db_metadata_long = db_metadata_long_norepeat,
                           linked_arms = linked_arms_long_norepeat)

  # Check general structure
  expect_true(is_tibble(out))
  expect_true(!"repeating" %in% out$structure)
  expect_true("nonrepeating" %in% out$structure)
  expect_true(!is.null(out$redcap_data))
})


test_that("clean_redcap_long without arms works", {
  ## Check longitudinal structure without arms ----
  out <- clean_redcap_long(db_data_long = db_data_long_noarms,
                           db_metadata_long = db_metadata_long_noarms,
                           linked_arms = linked_arms_long_noarms)

  expect_true(is_tibble(out))
  expect_true(all(c("repeating", "nonrepeating") %in% out$structure))
  expect_true(!is.null(out$redcap_data))
})

test_that("distill_nonrepeat_table_long tibble contains expected columns for longitudinal REDCap databases with arms", {
  ## Check longitudinal structure with arms ----
  out <- distill_nonrepeat_table_long(form_name = "nonrepeated",
                                      db_data_long = db_data_long,
                                      db_metadata_long = db_metadata_long,
                                      linked_arms = linked_arms_long)

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[,ncol(out)]) == "form_status_complete"
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
    any(c("redcap_repeat_instrument","redcap_repeat_instance") %in% names(out))
  )
})

test_that("distill_nonrepeat_table_long tibble contains expected columns for longitudinal REDCap databases without arms", {
  ## Check longitudinal structure without arms ----
  out <- distill_nonrepeat_table_long(form_name = "nonrepeated",
                                      db_data_long = db_data_long_noarms,
                                      db_metadata_long = db_metadata_long_noarms,
                                      linked_arms = linked_arms_long_noarms)

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[,ncol(out)]) == "form_status_complete"
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
    any(c("redcap_repeat_instrument","redcap_repeat_instance", "redcap_arm") %in% names(out))
  )
})

test_that("distill_repeat_table_long returns tables for REDCap dbs with arms", {
  ## Check longitudinal structure with arms ----
  out <- distill_repeat_table_long(form_name = "repeated",
                                   db_data_long = db_data_long,
                                   db_metadata_long = db_metadata_long,
                                   linked_arms = linked_arms_long)

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[,ncol(out)]) == "form_status_complete"
  )

  # Check for expected longitudinal arms columns
  expect_true(
    all(c("redcap_repeat_instance", "redcap_event", "redcap_arm") %in% names(out))
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
  out <- distill_repeat_table_long(form_name = "repeated",
                                   db_data_long = db_data_long_noarms,
                                   db_metadata_long = db_metadata_long_noarms,
                                   linked_arms = linked_arms_long_noarms)

  # Check general structure
  expect_true(is_tibble(out))

  # Check last columns are form_status_complete
  expect_true(
    names(out[,ncol(out)]) == "form_status_complete"
  )

  # Check for expected longitudinal no arms columns
  expect_true(
    all(c("redcap_repeat_instance", "redcap_event") %in% names(out))
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

