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

  expected_output <- tribble(
    ~field_name_updated,  ~form_name,
    "field_1",           "form_1",
    "field_2",           "form_2"
  )

  out <- check_user_rights(db_data = test_data, db_metadata = test_metadata) %>%
    suppressWarnings()

  expect_equal(out, expected_output)
  expect_warning(check_user_rights(db_data = test_data, db_metadata = test_metadata))
})
