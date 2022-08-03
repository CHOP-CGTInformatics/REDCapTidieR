# Load Sample Databases ----
# Arms datasets
db_data_long <- readRDS(system.file("testdata/db_data_long.RDS", package = "REDCapTidieR"))
db_metadata_long <- readRDS(system.file("testdata/db_metadata_long.RDS", package = "REDCapTidieR"))
linked_arms_long <- readRDS(system.file("testdata/linked_arms_long.RDS", package = "REDCapTidieR"))
# No arms datasets
db_data_long_noarms <- readRDS(system.file("testdata/db_data_long_noarms.RDS", package = "REDCapTidieR"))
db_metadata_long_noarms <- readRDS(system.file("testdata/db_metadata_long_noarms.RDS", package = "REDCapTidieR"))
linked_arms_long_noarms <- readRDS(system.file("testdata/linked_arms_long_noarms.RDS", package = "REDCapTidieR"))

# Run Tests ----
test_that("clean_redcap_long works", {
  ## Check longitudinal structure with arms ----
  out_arms <- clean_redcap_long(db_data = db_data_long,
                                db_metadata = db_metadata_long,
                                linked_arms = linked_arms_long)

  expect_true(is_tibble(out_arms))
  expect_true(all(c("repeating", "nonrepeating") %in% out_arms$structure))
  expect_true(!is.null(out_arms$redcap_data))

  ## Check longitudinal structure without arms ----
  out_noarms <- clean_redcap_long(db_data = db_data_long_noarms,
                                  db_metadata = db_metadata_long_noarms,
                                  linked_arms = linked_arms_long_noarms)

  expect_true(is_tibble(out_noarms))
  expect_true(all(c("repeating", "nonrepeating") %in% out_noarms$structure))
  expect_true(!is.null(out_noarms$redcap_data))
})

test_that("extract_nonrepeat_table_long tibble contains expected columns for longitudinal REDCap databases ", {
  ## Check longitudinal structure with arms ----
  out_arms <- extract_nonrepeat_table_long(form_name = "nonrepeated",
                                           db_data = db_data_long,
                                           db_metadata = db_metadata_long,
                                           linked_arms = linked_arms_long)

  # Check general structure
  expect_true(is_tibble(out_arms))

  # Check last columns are form_status_complete
  expect_true(
    names(out_arms[,ncol(out_arms)]) == "form_status_complete"
  )

  # Check for expected longitudinal arms columns
  expect_true(
    all(c("redcap_event", "redcap_arm") %in% names(out_arms))
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(c(out_arms$redcap_event, out_arms$redcap_arm)))
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument","redcap_repeat_instance") %in% names(out_arms))
  )

  ## Check longitudinal structure without arms ----
  out_noarms <- extract_nonrepeat_table_long(form_name = "nonrepeated",
                                             db_data = db_data_long_noarms,
                                             db_metadata = db_metadata_long_noarms,
                                             linked_arms = linked_arms_long_noarms)

  # Check general structure
  expect_true(is_tibble(out_noarms))

  # Check last columns are form_status_complete
  expect_true(
    names(out_noarms[,ncol(out_noarms)]) == "form_status_complete"
  )

  # Check for expected longitudinal arms columns
  expect_true(
    "redcap_event" %in% names(out_noarms)
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(out_noarms$redcap_event))
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument","redcap_repeat_instance", "redcap_arm") %in% names(out_noarms))
  )
})

test_that("extract_repeat_table_long returns tables", {
  ## Check longitudinal structure with arms ----
  out_arms <- extract_repeat_table_long(form_name = "repeated",
                                        db_data_long = db_data_long,
                                        db_metadata_long = db_metadata_long,
                                        linked_arms = linked_arms_long)

  # Check general structure
  expect_true(is_tibble(out_arms))

  # Check last columns are form_status_complete
  expect_true(
    names(out_arms[,ncol(out_arms)]) == "form_status_complete"
  )

  # Check for expected longitudinal arms columns
  expect_true(
    all(c("redcap_repeat_instance", "redcap_event", "redcap_arm") %in% names(out_arms))
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(c(out_arms$redcap_event, out_arms$redcap_arm)))
  )

  # Check columns expected to be missing aren't included
  expect_false(
    "redcap_repeat_instrument" %in% names(out_arms)
  )

  ## Check longitudinal structure without arms ----
  out_noarms <- extract_repeat_table_long(form_name = "repeated",
                                          db_data_long = db_data_long_noarms,
                                          db_metadata_long = db_metadata_long_noarms,
                                          linked_arms = linked_arms_long_noarms)

  # Check general structure
  expect_true(is_tibble(out_noarms))

  # Check last columns are form_status_complete
  expect_true(
    names(out_noarms[,ncol(out_noarms)]) == "form_status_complete"
  )

  # Check for expected longitudinal no arms columns
  expect_true(
    all(c("redcap_repeat_instance", "redcap_event") %in% names(out_noarms))
  )

  # Check partial keys are filled out
  expect_false(
    any(is.na(out_noarms$redcap_event))
  )

  # Check columns expected to be missing aren't included
  expect_false(
    any(c("redcap_repeat_instrument", "redcap_arm") %in% names(out_noarms))
  )
})
