nonrepeat_data <- tibble::tribble(
  ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3",
  1, TRUE, FALSE, FALSE,
  2, TRUE, TRUE, FALSE,
  3, FALSE, FALSE, FALSE
)

nonrepeat_metadata <- tibble::tribble(
  ~"field_name", ~"select_choices_or_calculations",
  "study_id", NA,
  "multi___1", "1, Red | 2, Yellow | 3, Blue",
  "multi___2", "1, Red | 2, Yellow | 3, Blue",
  "multi___3", "1, Red | 2, Yellow | 3, Blue"
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
  out <- reduce_multi_to_single_column(supertbl = supertbl,
                                tbl = "nonrepeat_instrument",
                                cols = starts_with("multi"),
                                cols_to = "new_col",
                                multi_val = "multiple", # multi_val declared
                                no_val = "none") # no_val declared

  expected_out <- tibble::tribble(
    ~"study_id", ~"multi___1", ~"multi___2", ~"multi___3", ~"new_col",
    1, TRUE, FALSE, FALSE, "Red",
    2, TRUE, TRUE, FALSE, "multiple",
    3, FALSE, FALSE, FALSE, "none"
  ) %>%
    mutate(
      new_col = factor(new_col, levels = c("Red", "Yellow", "Blue", "multiple", "none"))
    )

  expect_equal(out, expected_out)
})

test_that("reduce_multo_to_single works for repeat instrument", {
  out <- reduce_multi_to_single_column(supertbl = supertbl,
                                       tbl = "repeat_instrument",
                                       cols = starts_with("repeat"),
                                       cols_to = "new_col")

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
