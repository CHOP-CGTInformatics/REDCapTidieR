# Load Sample Databases ----

test_that("check_user_rights works", {
  test_data <- tribble(
    ~field_1,  ~field_2,
    "1",       "2"
  )

  test_metadata <- tribble(
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
  test_data2 <- tribble(
    ~record_id,  ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~combination_variable,
    1,            "event_1",         NA,                        NA,                      "A",
    2,            "event_2",         "combination",             1,                       "B",
    3,            "event_3",         "combination",             2,                       "C"
  )

  expect_error(check_repeat_and_nonrepeat(db_data = test_data))
})

test_that("check_repeat_and_nonrepeat works", {
  test_data <- tribble()

  expect_error(check_redcap_populated(db_data = test_data))
})
