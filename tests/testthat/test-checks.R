# Load Sample Databases ----

test_that("check_user_rights works", {
  test_data <- tibble::tribble(
    ~field_1,  ~field_2,
    "1",       "2"
  )

  test_metadata <- tibble::tribble(
    ~field_name_updated,  ~form_name,
    "field_1",           "form_1",
    "field_2",           "form_2",
    "missing_field",     "missing_form"
  )

  expect_warning(
    check_user_rights(db_data = test_data, db_metadata = test_metadata)
    )
})

test_that("check_repeat_and_nonrepeat works", {
  test_data_longitudinal <- tibble::tribble(
    ~record_id,  ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~combination_variable,
    1,            "event_1",         NA,                        NA,                      "A",
    2,            "event_2",         "combination",             1,                       "B",
    3,            "event_3",         "combination",             2,                       "C"
  )

  test_data_not_longitudinal <- tibble::tribble(
    ~new_record_id,  ~redcap_repeat_instrument, ~redcap_repeat_instance, ~combination_variable,
    1,                NA,                        NA,                      "A",
    2,                "combination",             1,                       "B",
    3,                "combination",             2,                       "C"
  )

  expect_error(check_repeat_and_nonrepeat(db_data = test_data_longitudinal))
  expect_error(check_repeat_and_nonrepeat(db_data = test_data_not_longitudinal))
})

test_that("check_repeat_and_nonrepeat works", {
  test_data <- tibble::tribble()

  expect_error(check_redcap_populated(db_data = test_data))
})

test_that("check_forms_exist works", {
  metadata <- tibble(form_name = letters[1:4])
  forms <- letters[3:6]

  expect_error(check_forms_exist(metadata, forms), regexp = "e and f")
})
