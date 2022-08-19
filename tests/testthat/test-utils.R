# Load Sample Databases ----
db_data_classic <- readRDS(system.file("testdata/db_data_classic.RDS", package = "REDCapTidieR"))
db_metadata_classic <- readRDS(system.file("testdata/db_metadata_classic.RDS", package = "REDCapTidieR"))

test_that("multi_choice_to_labels works", {
  out <- multi_choice_to_labels(db_data = db_data_classic,
                                db_metadata = db_metadata_classic)

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
})

test_that("parse_labels works", {

  valid_string <- "choice_1, one | choice_2, two | choice_3, three"
  valid_output <- tribble(
    ~raw,       ~label,
    "choice_1", "one",
    "choice_2", "two",
    "choice_3", "three"
  )

  invalid_string_1 <- "raw, label | that has | pipes but no other | commas"

   invalid_string_2 <- "raw, label | structure, | with odd matrix dimensions"

  expect_equal(parse_labels(valid_string), valid_output)
  expect_error(parse_labels(invalid_string_1))
  expect_error(parse_labels(invalid_string_2))
})
