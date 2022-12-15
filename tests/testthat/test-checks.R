# Load Sample Databases ----

test_that("check_user_rights works", {
  test_data <- tibble::tribble(
    ~field_1,  ~field_2,
    "1",       "2"
  )

  test_metadata <- tibble::tribble(
    ~field_name_updated, ~form_name,
    "field_1",           "form_1",
    "field_2",           "form_2",
    "missing_field",     "missing_form",
    "missing_field_2",   "missing_form",
    "missing_field_3",   "missing_form2"
  )

  readable_metadata <- tibble::tribble(
    ~field_name_updated,  ~form_name,
    "field 1",            "form_1",
    "missing_field",      "missing_form"
  )

  expect_warning(
    check_user_rights(test_data, test_metadata)
  )
})

test_that("check_repeat_and_nonrepeat works", {
  test_data_longitudinal <- tibble::tribble(
    ~record_id,  ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~combination_variable,
    1,           "event_1",          NA,                        NA,                      "A",
    2,           "event_2",          "combination",             1,                       "B",
    3,           "event_3",          "combination",             2,                       "C"
  )

  test_data_not_longitudinal <- tibble::tribble(
    ~new_record_id,  ~redcap_repeat_instrument, ~redcap_repeat_instance, ~combination_variable,
    1,               NA,                        NA,                      "A",
    2,               "combination",             1,                       "B",
    3,               "combination",             2,                       "C"
  )

  expect_error(check_repeat_and_nonrepeat(db_data = test_data_longitudinal))
  expect_error(check_repeat_and_nonrepeat(db_data = test_data_not_longitudinal))
})

test_that("check_redcap_populated works", {
  test_data <- tibble()

  expect_error(check_redcap_populated(db_data = test_data), class = "redcap_unpopulated")
})

test_that("check_forms_exist works", {
  metadata <- tibble(form_name = letters[1:4])
  forms <- letters[3:6]

  expect_error(check_forms_exist(metadata, forms), regexp = "e and f")
})


test_that("check_req_labelled_fields works", {
  # Check data and metadata column errors
  supertbl_no_data <- tibble::tribble(
    ~redcap_metadata,
    tibble(field_name = "x", field_label = "X Label"),
    tibble(field_name = "y", field_label = "Y Label")
  )

  supertbl_no_metadata <- tibble::tribble(
    ~redcap_data,
    tibble(x = letters[1:3]),
    tibble(y = letters[1:3])
  )

  ## Errors when data is missing
  check_req_labelled_fields(supertbl_no_data) %>%
    expect_error(class = "missing_req_labelled_fields")

  ## Errors when metadata is missing
  check_req_labelled_fields(supertbl_no_metadata) %>%
    expect_error(class = "missing_req_labelled_fields")
})

test_that("check_req_labelled_metadata_fields works", {
  # Check field_name and field_label within metadata
  supertbl_no_field_name <- tibble::tribble(
    ~redcap_data, ~redcap_metadata,
    tibble(x = letters[1:3]), tibble(field_label = "X Label"),
    tibble(y = letters[1:3]), tibble(field_label = "Y Label")
  )

  supertbl_no_field_label <- tibble::tribble(
    ~redcap_data, ~redcap_metadata,
    tibble(x = letters[1:3]), tibble(field_name = "x"),
    tibble(y = letters[1:3]), tibble(field_name = "y")
  )

  ## Errors when field_name is missing
  check_req_labelled_metadata_fields(supertbl_no_field_name) %>%
    expect_error(class = "missing_req_labelled_metadata_fields")

  ## Errors when field_label is missing
  check_req_labelled_metadata_fields(supertbl_no_field_label) %>%
    expect_error(class = "missing_req_labelled_metadata_fields")
})

test_that("checkmate wrappers work", {
  # tibble or dataframe
  expect_error(check_arg_is_dataframe(123), class = "check_data_frame")
  expect_true(check_arg_is_dataframe(data.frame()))
  expect_true(check_arg_is_dataframe(tibble()))

  # environment
  expect_error(check_arg_is_env(123), class = "check_environment")
  expect_true(check_arg_is_env(new.env()))

  # character
  expect_error(check_arg_is_character(123), class = "check_character")
  expect_true(check_arg_is_character("abc"))

  # logical
  expect_error(check_arg_is_logical(123), class = "check_logical")
  expect_true(check_arg_is_logical(TRUE))

  # choices
  expect_error(check_arg_choices(123, choices = letters[1:3]), class = "check_choice")
  expect_true(check_arg_choices("a", choices = letters[1:3]))

})
