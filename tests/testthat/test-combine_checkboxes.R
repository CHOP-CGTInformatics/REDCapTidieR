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
    cols = starts_with("multi")
  ) # values_fill declared

  expect_setequal(class(out), c("redcap_supertbl", "tbl_df", "tbl", "data.frame"))
  expect_equal(nrow(out), 2)
})

test_that("combine_checkboxes works for nonrepeat instrument", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = starts_with("multi"),
    multi_value_label = "multiple", # multi_value_label declared
    values_fill = "none" # values_fill declared
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"single_checkbox___1", ~"extra_data", ~"multi",
    1, TRUE, FALSE, FALSE, TRUE, 1, "Red",
    2, TRUE, TRUE, FALSE, TRUE, 2, "multiple",
    3, FALSE, FALSE, FALSE, FALSE, 3, "none"
  ) %>%
    mutate(
      multi = factor(multi, levels = c("Red", "Yellow", "Blue", "multiple", "none"))
    )

  expect_equal(out, expected_out)
})

test_that("combine_checkboxes glue spec works", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = starts_with("multi"),
    names_glue = "{.value}_suffix",
    multi_value_label = "multiple", # multi_value_label declared
    values_fill = "none" # values_fill declared
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"single_checkbox___1", ~"extra_data", ~"multi_suffix",
    1, TRUE, FALSE, FALSE, TRUE, 1, "Red",
    2, TRUE, TRUE, FALSE, TRUE, 2, "multiple",
    3, FALSE, FALSE, FALSE, FALSE, 3, "none"
  ) %>%
    mutate(
      multi_suffix = factor(multi_suffix, levels = c("Red", "Yellow", "Blue", "multiple", "none"))
    )

  expect_equal(out, expected_out)

  # glue spec with multiple values
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = c(starts_with("multi"), starts_with("single_checkbox")),
    names_glue = "{.value}_suffix",
    multi_value_label = "multiple", # multi_value_label declared
    values_fill = "none" # values_fill declared
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"single_checkbox___1",
    ~"extra_data", ~"multi_suffix", ~"single_checkbox_suffix",
    1, TRUE, FALSE, FALSE, TRUE, 1, "Red", "Green",
    2, TRUE, TRUE, FALSE, TRUE, 2, "multiple", "Green",
    3, FALSE, FALSE, FALSE, FALSE, 3, "none", "none"
  ) %>%
    mutate(
      multi_suffix = factor(multi_suffix, levels = c("Red", "Yellow", "Blue", "multiple", "none")),
      single_checkbox_suffix = factor(single_checkbox_suffix, levels = c("Green", "multiple", "none"))
    )

  expect_equal(out, expected_out)
})

test_that("combine_checkboxes works for nonrepeat instrument and drop old values", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = starts_with("multi"),
    keep = FALSE # Test keep = FALSE
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"single_checkbox___1", ~"extra_data", ~"multi",
    1, TRUE, 1, "Red",
    2, TRUE, 2, "Multiple",
    3, FALSE, 3, NA
  ) %>%
    mutate(
      multi = factor(multi, levels = c("Red", "Yellow", "Blue", "Multiple"))
    )

  expect_equal(out, expected_out)
})

test_that("combine_checkboxes works for repeat instrument", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "repeat_instrument",
    cols = starts_with("repeat")
  ) %>%
    pull(redcap_data) %>%
    dplyr::nth(2)

  expected_out <- tibble::tribble(
    ~"study_id", ~"redcap_event", ~"redcap_form_instance", ~"repeat___1", ~"repeat___2", ~"repeat___3", ~"repeat",
    1, "event_1", 1, TRUE, FALSE, FALSE, "A",
    2, "event_1", 1, TRUE, TRUE, TRUE, "Multiple",
    2, "event_1", 2, FALSE, FALSE, FALSE, NA
  ) %>%
    mutate(
      `repeat` = factor(`repeat`, levels = c("A", "B", "C", "Multiple"))
    )

  expect_equal(out, expected_out)
})

test_that("get_metadata_spec works", {
  out <- get_metadata_spec(
    metadata_tbl = supertbl$redcap_metadata[[1]],
    selected_cols = c("multi___1", "multi___2", "multi___3"),
    names_prefix = "", names_sep = "_", names_glue = NULL # Mimic defaults
  )

  expected_out <- tibble::tribble(
    ~"field_name", ~".value", ~".new_value", ~"raw", ~"label",
    "multi___1", "multi", "multi", "1", "Red",
    "multi___2", "multi", "multi", "2", "Yellow",
    "multi___3", "multi", "multi", "3", "Blue"
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
    keep = FALSE
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"extra_data", ~"multi", ~"single_checkbox",
    1, 1, "Red", "Green",
    2, 2, "Multiple", "Green",
    3, 3, NA, NA
  ) %>%
    mutate(
      multi = factor(multi, levels = c("Red", "Yellow", "Blue", "Multiple")),
      single_checkbox = factor(single_checkbox, levels = c("Green", "Multiple"))
    )

  expect_equal(out, expected_out)
})

test_that("combine_checkboxes works for multiple checkbox fields with logicals", {
  out <- combine_checkboxes(
    supertbl = supertbl,
    tbl = "nonrepeat_instrument",
    cols = c(starts_with("multi") | starts_with("single_checkbox")),
    keep = FALSE
  ) %>%
    pull(redcap_data) %>%
    dplyr::first()

  expected_out <- tibble::tribble(
    ~"study_id", ~"extra_data", ~"multi", ~"single_checkbox",
    1, 1, "Red", "Green",
    2, 2, "Multiple", "Green",
    3, 3, NA, NA
  ) %>%
    mutate(
      multi = factor(multi, levels = c("Red", "Yellow", "Blue", "Multiple")),
      single_checkbox = factor(single_checkbox, levels = c("Green", "Multiple"))
    )

  expect_equal(out, expected_out)
})

test_that("convert_checkbox_vals works()", {
  metadata <- tibble::tribble(
    ~"field_name", ~".value", ~"raw", ~"label",
    "multi___1", "multi", "1", "Red",
    "multi___2", "multi", "2", "Yellow",
    "multi___3", "multi", "3", "Blue"
  )

  # Same as nonrepeat data tbl but with NAs for FALSEs, post processed with metadata spec vals
  data_tbl <- tibble::tribble(
    ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"single_checkbox___1", ~"extra_data",
    1, "Red", NA, NA, "Green", 1,
    2, "Red", "Yellow", NA, "Green", 2,
    3, NA, NA, NA, NA, 3
  )

  out <- convert_checkbox_vals(
    metadata = metadata, .new_value = "_multi", data_tbl = data_tbl,
    raw_or_label = "label", multi_value_label = "multi", values_fill = NA
  )

  expected_out <- tibble(
    `_multi` = factor(c("Red", "multi", NA), levels = c("Red", "Yellow", "Blue", "multi"))
  )

  expect_equal(out, expected_out)
})

test_that("combine_and_repair_tbls works", {
  data_tbl <- tibble(
    id = 1,
    x___1 = TRUE,
    x___2 = FALSE,
    x = "val"
  )

  data_tbl_mod <- tibble(
    id = 1,
    x___1 = "A",
    x___2 = NA,
    x = "val"
  )

  new_cols <- list(x = "A")

  expect_error(combine_and_repair_tbls(data_tbl, data_tbl_mod, new_cols, names_repair = "check_unique"))
  expect_no_error(combine_and_repair_tbls(data_tbl, data_tbl_mod, new_cols, names_repair = "unique")) %>%
    suppressMessages()

  expected_out <- tibble(
    id = 1,
    x___1 = TRUE,
    x___2 = FALSE,
    x...4 = "val",
    x...5 = "A"
  )

  expect_equal(
    expected_out,
    combine_and_repair_tbls(data_tbl, data_tbl_mod, new_cols, names_repair = "unique")
  ) %>%
    suppressMessages()
})
