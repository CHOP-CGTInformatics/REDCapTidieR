nonrepeat_data <- tibble::tribble(
  ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"extra_data",
  1, TRUE, FALSE, FALSE, 1,
  2, TRUE, TRUE, FALSE, 2,
  3, FALSE, FALSE, FALSE, 3
)

nonrepeat_metadata <- tibble::tribble(
  ~"field_name", ~"select_choices_or_calculations",
  "study_id", NA,
  "multi___1", "1, Red | 2, Yellow | 3, Blue",
  "multi___2", "1, Red | 2, Yellow | 3, Blue",
  "multi___3", "1, Red | 2, Yellow | 3, Blue",
  "extra_data", "1, 1 | 2, 2 | 3,3"
)

repeat_data <- tibble::tribble(
  ~"study_id", ~"redcap_event", ~"redcap_form_instance", ~"repeat___1", ~"repeat___2",
  1, "event_1", 1, TRUE, FALSE,
  2, "event_1", 1, TRUE, TRUE,
  2, "event_1", 2, FALSE, FALSE
)

repeat_metadata <- tibble::tribble(
  ~"field_name", ~"select_choices_or_calculations",
  "study_id", NA,
  "repeat___1", "1, A | 2, B | 3, C",
  "repeat___2", "1, A | 2, B | 3, C"
)

supertbl <- tibble::tribble(
  ~"redcap_form_name", ~"redcap_data", ~"redcap_metadata",
  "nonrepeat_instrument", nonrepeat_data, nonrepeat_metadata,
  "repeat_instrument", repeat_data, repeat_metadata
)

class(supertbl) <- c("redcap_supertbl", class(supertbl))

test_that("reduce_multo_to_single works for nonrepeat instrument", {
  out <- combine_checkboxes(supertbl = supertbl,
                                form_name = "nonrepeat_instrument",
                                cols = starts_with("multi"),
                                values_to = "new_col",
                                multi_value_label = "multiple", # multi_value_label declared
                                values_fill = "none") # values_fill declared

  expected_out <- tibble::tribble(
    ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"extra_data", ~"new_col",
    1, TRUE, FALSE, FALSE, 1, "Red",
    2, TRUE, TRUE, FALSE, 2, "multiple",
    3, FALSE, FALSE, FALSE, 3, "none"
  ) %>%
    mutate(
      new_col = factor(new_col, levels = c("Red", "Yellow", "Blue", "multiple", "none"))
    )

  expect_equal(out, expected_out)
})

test_that("reduce_multo_to_single works for nonrepeat instrument and drop old values", {
  out <- combine_checkboxes(supertbl = supertbl,
                                       form_name = "nonrepeat_instrument",
                                       cols = starts_with("multi"),
                                       values_to = "new_col",
                                       keep = FALSE) # Test keep = FALSE

  expected_out <- tibble::tribble(
    ~"study_id", ~"extra_data", ~"new_col",
    1, 1, "Red",
    2, 2, "Multiple",
    3, 3, NA
  ) %>%
    mutate(
      new_col = factor(new_col, levels = c("Red", "Yellow", "Blue", "Multiple"))
    )

  expect_equal(out, expected_out)
})

test_that("reduce_multo_to_single works for repeat instrument", {
  out <- combine_checkboxes(supertbl = supertbl,
                                       form_name = "repeat_instrument",
                                       cols = starts_with("repeat"),
                                       values_to = "new_col")

  expected_out <- tibble::tribble(
    ~"study_id", ~"redcap_form_instance", ~"redcap_event", ~"repeat___1", ~"repeat___2", ~"new_col",
    1, 1, "event_1", TRUE, FALSE, "A",
    2, 1, "event_1", TRUE, TRUE, "Multiple",
    2, 2, "event_1", FALSE, FALSE, NA
  ) %>%
    mutate(
      new_col = factor(new_col, levels = c("A", "B", "Multiple"))
    )

  expect_equal(out, expected_out)
})
