# Load Sample Databases ----
db_data_classic <- readRDS(system.file("testdata/db_data_classic.RDS", package = "REDCapTidieR"))
db_metadata_classic <- readRDS(system.file("testdata/db_metadata_classic.RDS", package = "REDCapTidieR"))

test_that("update_data_field_names works", {
  test_data <- tibble::tribble(
    ~`checkbox____99`,   ~`checkbox____98`,
    0,                    1,
    1,                    0,
    1,                    0
  )

  test_meta <- tibble::tribble(
    ~field_name_updated,
    "checkbox___-99",
    "checkbox___-98",
    "test_column"
  )

  out <- update_data_col_names(db_data = test_data,
                               db_metadata = test_meta)

  expect_true(all(c("checkbox___-99", "checkbox___-98") %in% names(out)))
})

test_that("multi_choice_to_labels works", {

  db_data_classic <- update_data_col_names(db_data_classic,
                                           db_metadata_classic)

  # Expect warning on error variable where a radio button is created for a descriptive text field
  expect_warning(multi_choice_to_labels(db_data = db_data_classic,
                                        db_metadata = db_metadata_classic))

  out <- multi_choice_to_labels(db_data = db_data_classic,
                                db_metadata = db_metadata_classic) %>% suppressWarnings()

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
})

test_that("parse_labels works", {

  valid_string <- "choice_1, one | choice_2, two | choice_3, three"
  valid_output <- tibble::tribble(
    ~raw,       ~label,
    "choice_1", "one",
    "choice_2", "two",
    "choice_3", "three"
  )

  invalid_string_1 <- "raw, label | that has | pipes but no other | commas"

  invalid_string_2 <- "raw, label | structure, | with odd matrix dimensions"

  warning_string_1 <- NA_character_

  expect_equal(parse_labels(valid_string), valid_output)
  expect_error(parse_labels(invalid_string_1))
  expect_error(parse_labels(invalid_string_2))
  expect_warning(parse_labels(warning_string_1), regexp = NA)
})
