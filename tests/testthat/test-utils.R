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
  expect_factor(out$yesno)
  expect_equal(levels(out$yesno), c("yes", "no"))
  expect_logical(out$truefalse)

  checkbox_col_types <- map(out %>% select(contains("checkbox")), class)
  checkbox_col_types <- data.frame(
    matrix(unlist(checkbox_col_types),
           nrow = length(checkbox_col_types))
  )
  expect_true(all(checkbox_col_types[,1] == "logical"))

  expect_factor(out$dropdown_single)
  expect_equal(levels(out$dropdown_single), c("one", "two", "three"))
  expect_factor(out$radio_single)
  expect_equal(levels(out$radio_single), c("A", "B", "C"))
})
