nonrepeat_data <- tibble::tribble(
  ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"single_checkbox___1", ~"extra_data",
  1, TRUE, FALSE, FALSE, TRUE, 1,
  2, TRUE, TRUE, FALSE, TRUE, 2,
  3, FALSE, FALSE, FALSE, FALSE, 3
)

nonrepeat_metadata <- tibble::tribble(
  ~"field_name", ~"field_type", ~"select_choices_or_calculations",
  "study_id", "text", NA,
  "multi___1", "checkbox", "1, Red | 2, Yellow | 3, Blue",
  "multi___2", "checkbox", "1, Red | 2, Yellow | 3, Blue",
  "multi___3", "checkbox", "1, Red | 2, Yellow | 3, Blue",
  "single_checkbox___1", "checkbox", "4, Green",
  "extra_data", "dropdown", "1, 1 | 2, 2 | 3, 3"
)

repeat_data <- tibble::tribble(
  ~"study_id", ~"redcap_event", ~"redcap_form_instance", ~"repeat___1", ~"repeat___2", ~"repeat___3",
  1, "event_1", 1, TRUE, FALSE, FALSE,
  2, "event_1", 1, TRUE, TRUE, TRUE,
  2, "event_1", 2, FALSE, FALSE, FALSE
)

repeat_metadata <- tibble::tribble(
  ~"field_name", ~"field_type", ~"select_choices_or_calculations",
  "study_id", "text", NA,
  "repeat___1", "checkbox", "1, A | 2, B | 3, C",
  "repeat___2", "checkbox", "1, A | 2, B | 3, C",
  "repeat___3", "checkbox", "1, A | 2, B | 3, C"
)

supertbl <- tibble::tribble(
  ~"redcap_form_name", ~"redcap_data", ~"redcap_metadata",
  "nonrepeat_instrument", nonrepeat_data, nonrepeat_metadata,
  "repeat_instrument", repeat_data, repeat_metadata
)

class(supertbl) <- c("redcap_supertbl", class(supertbl))

test_that("combine_checkboxes returns an expected supertbl", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = starts_with("multi"),
    values_to = "new_col"
  ) # values_fill declared

  expect_setequal(class(out), c("redcap_supertbl", "tbl_df", "tbl", "data.frame"))
  expect_equal(nrow(out), 2)
})

test_that("combine_checkboxes works for nonrepeat instrument", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = starts_with("multi"),
    values_to = "new_col",
    multi_value_label = "multiple", # multi_value_label declared
    values_fill = "none" # values_fill declared
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"single_checkbox___1", ~"extra_data", ~"new_col",
    1, TRUE, FALSE, FALSE, TRUE, 1, "Red",
    2, TRUE, TRUE, FALSE, TRUE, 2, "multiple",
    3, FALSE, FALSE, FALSE, FALSE, 3, "none"
  ) %>%
    mutate(
      new_col = factor(new_col, levels = c("Red", "Yellow", "Blue", "multiple", "none"))
    )

  expect_equal(out, expected_out)
})

test_that("combine_checkboxes works for nonrepeat instrument and drop old values", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = starts_with("multi"),
    values_to = "new_col",
    keep = FALSE # Test keep = FALSE
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"single_checkbox___1", ~"extra_data", ~"new_col",
    1, TRUE, 1, "Red",
    2, TRUE, 2, "Multiple",
    3, FALSE, 3, NA
  ) %>%
    mutate(
      new_col = factor(new_col, levels = c("Red", "Yellow", "Blue", "Multiple"))
    )

  expect_equal(out, expected_out)
})

test_that("combine_checkboxes works for repeat instrument", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "repeat_instrument",
    cols = starts_with("repeat"),
    values_to = "new_col"
  ) %>%
    pull(redcap_data) %>%
    dplyr::nth(2)

  expected_out <- tibble::tribble(
    ~"study_id", ~"redcap_event", ~"redcap_form_instance", ~"repeat___1", ~"repeat___2", ~"repeat___3", ~"new_col",
    1, "event_1", 1, TRUE, FALSE, FALSE, "A",
    2, "event_1", 1, TRUE, TRUE, TRUE, "Multiple",
    2, "event_1", 2, FALSE, FALSE, FALSE, NA
  ) %>%
    mutate(
      new_col = factor(new_col, levels = c("A", "B", "C", "Multiple"))
    )

  expect_equal(out, expected_out)
})

test_that("get_metadata_ref works", {
  out <- get_metadata_ref(
    metadata_tbl = supertbl$redcap_metadata[[1]],
    selected_cols = c("multi___1", "multi___2", "multi___3")
  )

  expected_out <- tibble::tribble(
    ~"field_name", ~"original_field", ~"raw", ~"label",
    "multi___1", "multi", "1", "Red",
    "multi___2", "multi", "2", "Yellow",
    "multi___3", "multi", "3", "Blue"
  )

  expect_equal(out, expected_out)
})

test_that("replace_true works", {
  metadata <- tibble::tribble(
    ~"field_name", ~"raw", ~"label",
    "multi___1", "1", "Red",
    "multi___2", "2", "Yellow",
    "multi___3", "3", "Blue"
  )

  out <- replace_true(col = c(TRUE, TRUE, FALSE), col_name = "multi___1", metadata = metadata, raw_or_label = "raw")
  expected_out <- c("1", "1", NA)

  expect_equal(out, expected_out)

  out <- replace_true(col = c(TRUE, TRUE, FALSE), col_name = "multi___1", metadata = metadata, raw_or_label = "label")
  expected_out <- c("Red", "Red", NA)

  expect_equal(out, expected_out)
})

test_that("combine_checkboxes works for multiple checkbox fields", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = c(starts_with("multi"), starts_with("single_checkbox")),
    values_to = c("new_col1", "new_col2"),
    keep = FALSE
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"extra_data", ~"new_col1", ~"new_col2",
    1, 1, "Red", "Green",
    2, 2, "Multiple", "Green",
    3, 3, NA, NA
  ) %>%
    mutate(
      new_col1 = factor(new_col1, levels = c("Red", "Yellow", "Blue", "Multiple")),
      new_col2 = factor(new_col2, levels = c("Green", "Multiple"))
    )

  expect_equal(out, expected_out)
})

test_that("combine_checkboxes works for multiple checkbox fields with logicals", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = c(starts_with("multi") | starts_with("single_checkbox")),
    values_to = c("new_col1", "new_col2"),
    keep = FALSE
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"extra_data", ~"new_col1", ~"new_col2",
    1, 1, "Red", "Green",
    2, 2, "Multiple", "Green",
    3, 3, NA, NA
  ) %>%
    mutate(
      new_col1 = factor(new_col1, levels = c("Red", "Yellow", "Blue", "Multiple")),
      new_col2 = factor(new_col2, levels = c("Green", "Multiple"))
    )

  expect_equal(out, expected_out)
})
