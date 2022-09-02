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

  expect_warning(check_user_rights(db_data = test_data, db_metadata = test_metadata))
})

test_that("check_repeat_and_nonrepeat works", {
  test_data <- tibble(
    record_id = c(1, 2, 3),
    redcap_event_name = c("event_1", "event_2", "event_2"),
    redcap_repeat_instrument = c(NA, "combination", "combination"),
    redcap_repeat_instance = c(NA, 1, 2),
    combination_variable = c("A", "B", "C")
  )

  expect_error(check_repeat_and_nonrepeat(db_data = test_data))
})
