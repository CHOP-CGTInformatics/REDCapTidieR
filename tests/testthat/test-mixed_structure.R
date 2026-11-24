test_that("get_mixed_structure_fields works", {
  mixed_structure_db <- tibble::tribble(
    ~record_id, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~mixed_structure_variable,
    1, NA, NA, "A",
    2, "mixed_structure_form", 1, "B"
  )

  expected_out <- data.frame(
    field_name = "mixed_structure_variable",
    rep_and_nonrep = TRUE
  )

  out <- get_mixed_structure_fields(mixed_structure_db)

  expect_equal(out, expected_out)
})

test_that("convert_mixed_instrument works", {
  mixed_structure_db <- tibble::tribble(
    ~record_id, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~mixed_structure_variable,
    ~repeat_form_variable, ~mixed_repeat_var,
    1, NA, NA, "A", NA, NA,
    2, "mixed_structure_form", 1, "B", NA, NA,
    3, "repeat_form", 1, NA, "C", NA,
    4, "repeat_form", 2, NA, "D", NA,
    5, "mixed_repeat_together", 1, NA, NA, "E",
    5, "mixed_repeat_together", 2, NA, NA, "F"
  )

  mixed_structure_ref <- tibble::tribble(
    ~field_name, ~rep_and_nonrep, ~form_name,
    "mixed_structure_variable", TRUE, "mixed_structure_form",
    "mixed_repeat_var", TRUE, "mixed_repeat_together"
  )

  expected_out <- tibble::tribble(
    ~record_id, ~redcap_repeat_instrument, ~redcap_repeat_instance, ~mixed_structure_variable,
    ~repeat_form_variable, ~mixed_repeat_var,
    1, "mixed_structure_form", 1, "A", NA, NA,
    2, "mixed_structure_form", 1, "B", NA, NA,
    3, "repeat_form", 1, NA, "C", NA,
    4, "repeat_form", 2, NA, "D", NA,
    5, "mixed_repeat_together", 1, NA, NA, "E",
    5, "mixed_repeat_together", 2, NA, NA, "F"
  )

  out <- convert_mixed_instrument(mixed_structure_db, mixed_structure_ref)

  expect_equal(out, expected_out)
})
