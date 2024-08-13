# Load Sample Databases ----
db_data_classic <- readRDS(system.file("testdata/db_data_classic.RDS", package = "REDCapTidieR"))
db_metadata_classic <- readRDS(system.file("testdata/db_metadata_classic.RDS", package = "REDCapTidieR"))

test_that("update_data_field_names works", {
  test_data <- tibble::tribble(
    ~`checkbox____99`,   ~`checkbox____98`,
    0,                   1,
    1,                   0,
    1,                   0
  )

  test_meta <- tibble::tribble(
    ~field_name_updated,
    "checkbox___-99",
    "checkbox___-98",
    "test_column"
  )

  out <- update_data_col_names(
    db_data = test_data,
    db_metadata = test_meta
  )

  expect_true(all(c("checkbox___-99", "checkbox___-98") %in% names(out)))
})

test_that("multi_choice_to_labels works", {
  db_data_classic <- update_data_col_names(
    db_data_classic,
    db_metadata_classic
  )

  # Expect warning on misconfigured variables
  multi_choice_to_labels(
    db_data = db_data_classic,
    db_metadata = db_metadata_classic
  ) %>%
    # radio button is created for a descriptive text field
    expect_warning(class = "empty_parse_warning") %>%
    expect_warning(class = "field_missing_categories") %>%
    # radio button with duplicate labels
    expect_warning(class = "duplicate_labels")

  out <- multi_choice_to_labels(
    db_data = db_data_classic,
    db_metadata = db_metadata_classic
  ) %>%
    suppressWarnings(classes = c(
      "empty_parse_warning",
      "field_missing_categories",
      "duplicate_labels"
    ))

  # Test general structure
  expect_true(is.data.frame(out))
  expect_true(nrow(out) > 0)

  # Test multichoice options return expected values and datatypes
  expect_logical(out$yesno)
  expect_logical(out$truefalse)
  expect_logical(out$checkbox_multiple___1)
  expect_logical(out$checkbox_multiple_2___4eeee5)

  expect_factor(out$dropdown_single)
  expect_equal(levels(out$dropdown_single), c("one", "two", "three"))
  expect_factor(out$radio_single)
  expect_equal(levels(out$radio_single), c("A", "B", "C"))

  expect_factor(out$data_field_types_complete)
  expect_equal(levels(out$data_field_types_complete), c("Incomplete", "Unverified", "Complete"))

  # Haven option works
  skip_if_not_installed("labelled")

  out <- multi_choice_to_labels(
    db_data = db_data_classic,
    db_metadata = db_metadata_classic,
    raw_or_label = "haven"
  ) %>%
    suppressWarnings(classes = c(
      "empty_parse_warning",
      "field_missing_categories",
      "duplicate_labels"
    ))

  expect_s3_class(out$dropdown_single, "haven_labelled")
  expect_equal(
    labelled::val_labels(out$dropdown_single),
    c("one" = "choice_1", "two" = "choice_2", "three" = "choice_3")
  )
  expect_s3_class(out$radio_single, "haven_labelled")
  expect_equal(labelled::val_labels(out$radio_single), c("A" = "choice_1", "B" = "choice_2", "C" = "choice_3"))
  expect_s3_class(out$data_field_types_complete, "haven_labelled")
  expect_equal(
    labelled::val_labels(out$data_field_types_complete), c("Incomplete" = 0, "Unverified" = 1, "Complete" = 2)
  )
  expect_s3_class(out$repeatsurvey_radio_v2, "haven_labelled")
  expect_equal(labelled::val_labels(out$repeatsurvey_radio_v2), c("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3))
})

test_that("parse_labels works", {
  # Note: implicitly testing strip_html_field_embedding() by checking that
  # parse_labels successfully stips html tags and field embedding logic
  valid_string <- "choice_1, one | choice_2, two {abc} | choice_3, <b>three</b>"
  valid_tibble_output <- tibble::tribble(
    ~raw,       ~label,
    "choice_1", "one",
    "choice_2", "two",
    "choice_3", "three"
  )
  valid_vector_output <- c("one", "two", "three")
  names(valid_vector_output) <- c("choice_1", "choice_2", "choice_3")

  invalid_string_1 <- "raw, label | that has | pipes but no other | commas"
  invalid_string_2 <- "raw, la|bel with pipe"

  warning_string_1 <- NA_character_

  expect_equal(parse_labels(valid_string), valid_tibble_output)
  expect_equal(
    parse_labels(valid_string, return_vector = TRUE),
    valid_vector_output
  )
  expect_error(
    parse_labels(invalid_string_1),
    class = "label_parse_error"
  )
  expect_error(
    parse_labels(invalid_string_2),
    class = "label_parse_error"
  )
  expect_warning(
    parse_labels(warning_string_1),
    class = "empty_parse_warning"
  )

  # Check that parse_labels can account for splits where no white space exists

  ## between pipes
  valid_string_no_ws1 <- "choice_1, one|choice_2, two {abc}|choice_3, <b>three</b>"
  expect_equal(parse_labels(valid_string_no_ws1), valid_tibble_output)

  ## between commas
  valid_string_no_ws2 <- "choice_1,one|choice_2,two {abc}|choice_3,<b>three</b>"
  expect_equal(parse_labels(valid_string_no_ws2), valid_tibble_output)

  # Check that return_stripped_text_flag works

  ## When html/embedding was stripped
  expect_equal(
    parse_labels(valid_string, return_stripped_text_flag = TRUE),
    list(valid_tibble_output, TRUE)
  )

  expect_equal(
    parse_labels(valid_string, return_vector = TRUE, return_stripped_text_flag = TRUE),
    list(valid_vector_output, TRUE)
  )

  ## When nothing was stripped
  valid_string_no_html <- "choice_1, one | choice_2, two | choice_3, three"

  expect_equal(
    parse_labels(valid_string_no_html, return_stripped_text_flag = TRUE),
    list(valid_tibble_output, FALSE)
  )

  expect_equal(
    parse_labels(valid_string_no_html, return_vector = TRUE, return_stripped_text_flag = TRUE),
    list(valid_vector_output, FALSE)
  )

  ## Flag returns FALSE when there were no labels
  parse_labels(warning_string_1, return_stripped_text_flag = TRUE) |>
    suppressWarnings(classes = "empty_parse_warning") |>
    purrr::pluck(2) |>
    expect_equal(FALSE)
})

test_that("parse_logical_cols", {
  db_data <- tibble::tibble(
    record_id = 1:3,
    yes_no = c("1", "0", "UNK"),
    other_field = letters[1:3]
  )
  db_metadata <- tibble::tibble(
    field_name_updated = c("yes_no", "other_field"),
    field_type = c("yesno", "text")
  )

  expect_warning(parse_logical_cols(db_data, db_metadata), class = "field_is_logical")

  out <- parse_logical_cols(db_data, db_metadata) |>
    suppressWarnings(classes = "field_is_logical")

  expect_equal(dim(out), dim(db_data))
  expect_equal(out$record_id, db_data$record_id)
  expect_equal(out$yes_no, c(TRUE, FALSE, NA))
  expect_equal(out$other_field, db_data$other_field)

  db_data <- tibble::tibble(
    record_id = 1:3,
    other_field = letters[1:3]
  )
  db_metadata <- tibble::tibble(
    field_name_updated = "other_field",
    field_type = "text"
  )
  expect_equal(parse_logical_cols(db_data, db_metadata), db_data)
})

test_that("link_arms works", {
  skip_on_cran()

  out <- link_arms(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API"))

  # output is a tibble
  expect_s3_class(out, "tbl")

  # output contains expected columns
  expected_cols <- c("arm_num", "unique_event_name", "form", "arm_name")
  expect_setequal(expected_cols, names(out))

  # all arms are represented in output (test redcap has 2 arms)
  n_unique_arms <- length(unique(out$arm_num))
  expect_equal(n_unique_arms, 2)
})

test_that("update_field_names works", {
  # nolint start: line_length_linter
  test_meta <- tibble::tribble(
    ~field_name,         ~form_name,    ~field_type, ~field_label,                          ~select_choices_or_calculations,
    "record_id",         NA_character_, "text",      NA_character_,                         NA_character_,
    "checkbox",          "my_form",     "checkbox",  "Field Label",                         "1, 1 | -99, <b>Unknown</b> {embedded logic}",
    "checkbox_no_label", "my_form",     "checkbox",  NA_character_,                         "1, 1",
    "checkbox_w_colon",  "my_form",     "checkbox",  "Field Label:",                        "1, 1",
    "checkbox_no_opts",  "my_form",     "checkbox",  "Field Label:",                        NA_character_,
    "field",             "my_form",     "text",      "<b>Field Label</b> {embedded logic}", NA_character_
  )
  # nolint end: line_length_linter

  out <- update_field_names(test_meta) %>%
    suppressWarnings(classes = "empty_parse_warning")

  # Check cols are present and correctly ordered
  expected_cols <- c(
    "field_name", "form_name", "field_type", "field_label",
    "select_choices_or_calculations", "field_name_updated"
  )

  expect_equal(colnames(out), expected_cols)

  # Check field_name_updated was created correctly
  field_name_updated <- out$field_name_updated[-1] # drop record_id row

  expect_equal(
    field_name_updated,
    c(
      "checkbox___1", "checkbox___-99", "checkbox_no_label___1",
      "checkbox_w_colon___1", "checkbox_no_opts___NA", "field"
    )
  )

  # Check field_label was correctly updated in place

  ## Checkbox labs appended in parentheses
  ## field embedding logic stripped
  ## Missing field labels converted to NA
  field_label <- out$field_label[-1] # drop record_id row

  expect_equal(
    field_label,
    c(
      "Field Label: 1", "Field Label: Unknown", NA_character_,
      "Field Label: 1", NA_character_, "Field Label"
    )
  )
})

test_that("update_field_names handles metadata without checkbox fields", {
  test_meta <- tibble::tribble(
    ~field_name, ~form_name,    ~field_type, ~field_label,  ~select_choices_or_calculations,
    "record_id", NA_character_, "text",      NA_character_, NA_character_,
    "my_radio",  NA_character_, "radio",     "xyz",         "abc"
  )

  out <- update_field_names(test_meta)

  # field_name_update is the same as field_name

  expect_equal(out$field_name, out$field_name_updated)

  # field_label is unchanged

  expect_equal(out$field_label, test_meta$field_label)
})

test_that("try_redcapr works", {
  # Passes along data when success is TRUE
  try_redcapr(list(success = TRUE, data = "some_data")) %>%
    expect_equal("some_data")

  # Throws expected errors for internal REDCapR errors
  try_redcapr(stop()) %>%
    expect_error(class = "unexpected_error")

  # Throws expected errors when REDCapR returns success = FALSE
  try_redcapr(stop("Could not resolve host")) %>%
    expect_error(class = "cannot_resolve_host")

  try_redcapr(list(success = FALSE, status_code = 403)) %>%
    expect_error(class = "api_token_rejected")

  try_redcapr(list(success = FALSE, status_code = 405)) %>%
    expect_error(class = "cannot_post")

  # Unexpected error, no message
  cnd <- try_redcapr(list(success = FALSE, status_code = "")) %>%
    catch_cnd()
  expect_s3_class(cnd, "unexpected_error")
  expect_null(cnd$parent)

  # Unexpected error, w/ message
  cnd <- try_redcapr(list(success = FALSE, status_code = "", outcome_message = "some error")) %>%
    catch_cnd()
  expect_s3_class(cnd, "unexpected_error")
  expect_equal(cnd$parent$message, "some error")

  # Unexpected error, w/ message, works with multiline expr
  cnd <- try_redcapr({
    list(success = FALSE, status_code = "", outcome_message = "some error")
  }) %>%
    catch_cnd()
  expect_s3_class(cnd, "unexpected_error")
  expect_equal(cnd$parent$message, "some error")

  try_redcapr(list(success = TRUE, data = as.numeric("A"))) %>%
    expect_warning(class = "unexpected_warning")
})

test_that("add_partial_keys works", {
  test_data <- tibble::tribble(
    ~record_id, ~redcap_event_name, ~redcap_repeat_instrument, ~redcap_repeat_instance,
    1, "nr_event_arm_1", NA, NA,
    1, "nr_event_arm_1", "r_instrument", 1,
    3, "nr_event_arm_1", "r_instrument", 1,
    4, "r_event_arm_1", NA, 1
  )

  out <- test_data %>%
    add_partial_keys(var = .data$redcap_event_name)

  expected_cols <- c(
    "record_id",
    "redcap_event_name",
    "redcap_repeat_instrument",
    "redcap_form_instance",
    "redcap_event_instance",
    "redcap_event",
    "redcap_arm"
  )

  expect_true(all(expected_cols %in% names(out)))
  expect_s3_class(out, "data.frame")
  expect_true(nrow(out) > 0)
})

test_that("create_repeat_instance_vars works", {
  repeat_events <- tibble::tribble(
    ~record_id, ~redcap_event, ~redcap_arm, ~redcap_repeat_instrument, ~redcap_repeat_instance,
    1, "nr_event", 1, NA, NA,
    1, "nr_event", 1, "r_instrument", 1,
    3, "nr_event", 1, "r_instrument", 1,
    4, "r_event", 1, NA, 1
  )

  no_repeat_events <- tibble::tribble(
    ~record_id, ~redcap_event, ~redcap_arm, ~redcap_repeat_instrument, ~redcap_repeat_instance,
    1, "nr_event", 1, NA, NA,
    1, "nr_event", 1, "r_instrument", 1,
    3, "nr_event", 1, "r_instrument", 1
  )

  expected_cols <- c(
    "record_id",
    "redcap_event",
    "redcap_arm",
    "redcap_repeat_instrument",
    "redcap_form_instance",
    "redcap_event_instance"
  )

  repeat_out <- create_repeat_instance_vars(repeat_events)
  nonrepeat_out <- create_repeat_instance_vars(no_repeat_events)

  expect_true(all(expected_cols %in% names(repeat_out)))
  expect_s3_class(repeat_out, "data.frame")
  expect_true(nrow(repeat_out) > 0)

  expect_true(all(expected_cols[1:5] %in% names(nonrepeat_out)))
  expect_s3_class(nonrepeat_out, "data.frame")
  expect_true(nrow(nonrepeat_out) > 0)
})

test_that("remove_empty_rows works", {
  my_record_id <- "record_id"

  complete_out <- tibble::tribble(
    ~record_id, ~redcap_event, ~redcap_event_instance, ~data, ~form_status_complete,
    1, "event1", 1, "A", "Complete",
    1, "event2", 2, "B", "Incomplete",
    2, "event1", 1, "C", "Complete",
  )

  complete_out %>%
    remove_empty_rows(my_record_id) %>%
    expect_equal(complete_out)

  empty_out <- tibble::tribble(
    ~record_id, ~redcap_event, ~redcap_event_instance, ~data, ~form_status_complete,
    1, "event1", 1, "A", "Complete",
    1, "event2", 2, NA, "Incomplete",
    2, "event1", 1, "C", "Complete",
  )

  expected_out <- tibble::tribble(
    ~record_id, ~redcap_event, ~redcap_event_instance, ~data, ~form_status_complete,
    1, "event1", 1, "A", "Complete",
    2, "event1", 1, "C", "Complete",
  )

  empty_out %>%
    remove_empty_rows(my_record_id) %>%
    expect_equal(expected_out)
})

test_that("is_labelled works", {
  df <- tibble::tribble(
    ~"one", ~"two", ~"three",
    1, 2, 3
  )

  is_labelled <- is_labelled(df)
  expect_false(is_labelled)

  labels <- c("One", "Two", "Three")
  labelled::var_label(df) <- labels

  is_labelled <- is_labelled(df)
  expect_true(is_labelled)
})

test_that("make_skimr_labels works", {
  skimr_labels <- make_skimr_labels()

  # Test for named character vector output
  expect_true(is.vector(skimr_labels))
  expect_true(is.character(skimr_labels))
  expect_true(!is.null(attr(skimr_labels, "name")))
})

test_that("invert_vec works", {
  expect_equal(invert_vec(c("a" = 1, "b" = 2)), c("1" = "a", "2" = "b"))
  expect_equal(invert_vec(1:2), 1:2)
})

test_that("apply_labs_haven works", {
  skip_if_not_installed("labelled")

  # Testing all classes where labelled has built in val_labels<- methods
  out <- apply_labs_haven(1:3, c("1" = "a", "2" = "b", "3" = "c"), integer())
  expect_s3_class(out, "haven_labelled")
  expect_equal(labelled::val_labels(out), c(a = 1, b = 2, c = 3))

  out <- apply_labs_haven(c(1.1, 2, 3.3), c("1.1" = "a", "2" = "b", "3.3" = "c"), numeric())
  expect_s3_class(out, "haven_labelled")
  expect_equal(labelled::val_labels(out), c(a = 1.1, b = 2.0, c = 3.3))

  out <- apply_labs_haven(letters[1:3], c("a" = "x", "b" = "y", "c" = "z"), character())
  expect_s3_class(out, "haven_labelled")
  expect_equal(labelled::val_labels(out), c(x = "a", y = "b", z = "c"))

  # Case with mismatching data types between labels from metadata and data values
  out <- apply_labs_haven(1:2, c("1" = "a", "2" = "b", "3.3" = "c"), integer())
  expect_s3_class(out, "haven_labelled")
  expect_equal(labelled::val_labels(out), c(a = "1", b = "2", c = "3.3"))
})

test_that("apply_labs_factor works", {
  out <- apply_labs_factor(1:3, c("1" = "a", "2" = "b", "3" = "c"))
  expect_s3_class(out, "factor")
  expect_equal(out, factor(letters[1:3]))
})

test_that("force_cast converts non chr/numerics to chr", {
  expect_character(force_cast("2023-01-01", as.Date(NA)))
})

test_that("get_record_id_field works", {
  data_tbl <- tibble::tribble(
    ~"test_name", ~"test_value",
    1, 2
  )

  expect_equal(get_record_id_field(data_tbl), "test_name")
})

test_that("extract_metadata_tibble works", {
  inst_1_metadata <- tibble::tribble(
    ~"field_name", ~"field_type",
    "study_id", "text",
    "text", "text",
  )

  inst_2_metadata <- tibble::tribble(
    ~"field_name", ~"field_type",
    "study_id", "text",
    "calulated", "calc",
  )

  supertbl <- tibble::tribble(
    ~"redcap_form_name", ~"redcap_metadata",
    "inst_1", inst_1_metadata,
    "inst_2", inst_2_metadata
  )

  class(supertbl) <- c("redcap_supertbl", class(supertbl))

  out <- extract_metadata_tibble(supertbl = supertbl, redcap_form_name = "inst_1")

  expect_equal(out, inst_1_metadata)
})
