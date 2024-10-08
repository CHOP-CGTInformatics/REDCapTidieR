test_that("check_user_rights works", {
  test_data <- tibble::tribble(
    ~record_id, ~field_1,  ~field_2,
    1,          "1",       "2"
  )

  test_data_empty <- tibble::tribble(
    ~record_id,
    1
  )

  test_metadata <- tibble::tribble(
    ~field_name_updated, ~form_name,
    "record_id",         NA_character_,
    "field_1",           "form_1",
    "field_2",           "form_2",
    "missing_field",     "missing_form",
    "missing_field_2",   "missing_form",
    "missing_field_3",   "missing_form2"
  )

  expect_warning(
    check_user_rights(test_data, test_metadata),
    class = "partial_data_access"
  )

  expect_error(
    check_user_rights(test_data_empty, test_metadata),
    class = "no_data_access"
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

  test_repeating_event <- tibble::tribble(
    ~record_id, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~combination_variable,
    1, NA, NA, "A",
    1, NA, 1, "B",
    2, "combination", 2, NA
  )

  expect_error(check_repeat_and_nonrepeat(db_data = test_data_longitudinal),
    class = "repeat_nonrepeat_instrument"
  )
  expect_error(check_repeat_and_nonrepeat(db_data = test_data_not_longitudinal),
    class = "repeat_nonrepeat_instrument"
  )
  expect_no_error(check_repeat_and_nonrepeat(db_data = test_repeating_event))
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

test_that("check_parsed_labels works", {
  check_parsed_labels(letters[1:2], "field_name") %>%
    expect_no_warning()

  cnd <- check_parsed_labels(rep("a", 2), "field_name") %>%
    rlang::catch_cnd(classes = "duplicate_labels")

  expect_equal(cnd$field, "field_name")

  cnd <- check_parsed_labels(c(a = ""), "field_name") %>%
    rlang::catch_cnd(classes = "blank_labels")

  expect_equal(cnd$field, "field_name")
})

test_that("checkmate wrappers work", {
  # supertbl
  expect_error(check_arg_is_supertbl(123), class = "check_supertbl")

  missing_col_supertbl <- tibble(redcap_data = list()) %>%
    as_supertbl()

  missing_list_col_supertbl <- tibble(redcap_data = list(), redcap_metadata = 123) %>%
    as_supertbl()

  good_supertbl <- tibble(redcap_data = list(), redcap_metadata = list()) %>%
    as_supertbl()

  expect_error(check_arg_is_supertbl(missing_col_supertbl), class = "missing_req_cols")
  expect_error(check_arg_is_supertbl(missing_list_col_supertbl), class = "missing_req_list_cols")
  expect_true(check_arg_is_supertbl(good_supertbl))

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

  # token
  expect_error(check_arg_is_valid_token("abc"), class = "invalid_token")
  expect_true(check_arg_is_valid_token("123456789ABCDEF123456789ABCDEF01"))

  # extension
  expect_warning(check_arg_is_valid_extension("temp.docx", valid_extensions = "xlsx"),
    class = "invalid_file_extension"
  )
  expect_warning(check_arg_is_valid_extension("xlsx.", valid_extensions = "xlsx"),
    class = "invalid_file_extension"
  )
  expect_true(check_arg_is_valid_extension("temp.xlsx", valid_extensions = "xlsx"))
})

test_that("check_data_arg_exists works", {
  missing_fields <- tibble::tribble(
    ~record_id, ~field_1,
    1,          "1"
  )

  included_fields <- tibble::tribble(
    ~record_id, ~redcap_data_access_group, ~redcap_survey_identifier, ~field_1,
    1, "A", NA, "1"
  )

  expect_error(
    check_data_arg_exists(
      db_data = missing_fields,
      col = "redcap_data_access_group",
      arg = "export_data_access_groups"
    ),
    class = "nonexistent_arg_requested"
  )
  expect_no_error(
    check_data_arg_exists(
      db_data = included_fields,
      col = "redcap_data_access_group",
      arg = "export_data_access_groups"
    ),
    class = "nonexistent_arg_requested"
  )
  expect_error(
    check_data_arg_exists(
      db_data = missing_fields,
      col = "redcap_survey_identifier",
      arg = "export_survey_fields"
    ),
    class = "nonexistent_arg_requested"
  )
  expect_no_error(
    check_data_arg_exists(
      db_data = included_fields,
      col = "redcap_survey_identifier",
      arg = "export_survey_fields"
    ),
    class = "nonexistent_arg_requested"
  )
})

test_that("check_file_exists works", {
  withr::with_tempdir({
    dir <- getwd()
    filepath <- paste0(dir, "/temp.csv")
    expect_no_error(
      check_file_exists(file = filepath, overwrite = FALSE)
    )
  })

  withr::with_tempdir({
    dir <- getwd()
    tempfile <- write.csv(x = mtcars, file = "temp.csv")
    filepath <- paste0(dir, "/temp.csv")
    expect_error(
      check_file_exists(file = filepath, overwrite = FALSE),
      class = "check_file_overwrite"
    )
  })
})

test_that("check_field_is_logical works", {
  expect_equal(
    check_field_is_logical(c(TRUE, FALSE, NA)),
    list(parsed = c(TRUE, FALSE, NA), problems = NULL)
  )
  expect_equal(
    check_field_is_logical(c(1, 0, NA)),
    list(parsed = c(TRUE, FALSE, NA), problems = NULL)
  )
  expect_equal(
    check_field_is_logical(c(1, 0, "x")),
    list(parsed = c(TRUE, FALSE, NA), problems = "x")
  )
})

test_that("check_extra_field_values works", {
  check_extra_field_values(c(1, NA, 2), c("1", "2")) |>
    expect_null()

  check_extra_field_values(c(1, NA, 2), "1") |>
    expect_equal("2")
})

test_that("check_fields_exist works", {
  check_fields_exist(fields = character(0), expr = expr(starts_with("temp"))) %>%
    expect_error(class = "missing_checkbox_fields")

  check_fields_exist(fields = c(1, 2, 3), expr = expr(starts_with("temp"))) %>%
    expect_no_error()
})

test_that("check_metadata_fields_exist works", {
  metadata_valid <- tibble(
    field_name = c("var1", "var2", "var_3"),
  )
  valid_cols <- c("var1", "var2", "var_3")

  metadata_invalid <- tibble(
    field_name = c("var1", "var2", "var_3_edited"),
  )
  invalid_cols <- c("var1", "var2", "var_3_edited")

  check_metadata_fields_exist(metadata_valid, valid_cols) %>%
    expect_no_error()

  check_metadata_fields_exist(metadata_invalid, valid_cols) %>%
    expect_error(class = "missing_metadata_checkbox_fields")

  check_metadata_fields_exist(metadata_valid, invalid_cols) %>%
    expect_error(class = "missing_metadata_checkbox_fields")
})

test_that("check_fields_are_checkboxes works", {
  metadata <- tibble::tribble(
    ~field_name, ~field_type,
    "record_id", "text",
    "text_field", "text",
    "calc_field", "calc",
    "checkbox___1", "checkbox",
    "checkbox___2", "checkbox",
    "checkbox___3", "checkbox"
  )

  metadata_filtered <- metadata %>%
    filter("checkbox" %in% field_name)

  expect_error(check_fields_are_checkboxes(metadata), class = "non_checkbox_fields")
  expect_no_error(check_fields_are_checkboxes(metadata_filtered))
})

test_that("check_equal_col_summaries works", {
  data <- tibble::tribble(
    ~"id", ~"col1", ~"col2",
    1, "A", "A1",
    2, "B", "B1",
    3, "C", "C1"
  )

  expect_no_error(check_equal_col_summaries(data, col1, col2))

  error_data <- tibble::tribble(
    ~"id", ~"col1", ~"col2",
    1, "A", "A1",
    2, "A", "A2",
    3, "B", "B1",
    4, "B", "B2"
  )

  check_equal_col_summaries(error_data, col1, col2) %>%
    expect_error(class = "names_glue_multi_checkbox")
})
