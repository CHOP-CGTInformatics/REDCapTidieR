# Load Sample REDCapTidier Database Longitudinal Output
redcaptidier_longitudintal_db <- readRDS(system.file("testdata/redcaptidier_longitudinal_db.RDS", package = "REDCapTidieR"))

test_that("extract_tables works with a vector and tidyselect selectors", {
  # Test tidyselectors work
  expected_everything_out <- list(
    repeated = redcaptidier_longitudintal_db$redcap_data[[1]],
    nonrepeated = redcaptidier_longitudintal_db$redcap_data[[2]],
    nonrepeated2 = redcaptidier_longitudintal_db$redcap_data[[3]]
  )
  expected_starts_with_out <- list(
    nonrepeated = redcaptidier_longitudintal_db$redcap_data[[2]],
    nonrepeated2 = redcaptidier_longitudintal_db$redcap_data[[3]]
  )
  expected_ends_with_out <- list(
    nonrepeated2 = redcaptidier_longitudintal_db$redcap_data[[3]]
  )
  expected_traditional_out <- list(
    repeated = redcaptidier_longitudintal_db$redcap_data[[1]],
    nonrepeated = redcaptidier_longitudintal_db$redcap_data[[2]]
  )

  expect_equal(
    redcaptidier_longitudintal_db %>%
      extract_tables(tbls = everything()),
    expected_everything_out
  )
  expect_equal(
    redcaptidier_longitudintal_db %>%
      extract_tables(tbls = starts_with("non")),
    expected_starts_with_out
  )
  expect_equal(
    redcaptidier_longitudintal_db %>%
      extract_tables(tbls = ends_with("2")),
    expected_ends_with_out
  )
  expect_equal(
    redcaptidier_longitudintal_db %>%
      extract_tables(tbls = c("repeated", "nonrepeated")),
    expected_traditional_out
  )
  expect_error(redcaptidier_longitudintal_db %>%
                 extract_tables(tbls = c("repeated", "fake_instrument_name")))
})

test_that("extract_table works", {
  expect_error(extract_table(redcaptidier_longitudintal_db, "fake_instrument_name"))

  expected_out <- redcaptidier_longitudintal_db$redcap_data[[1]]
  expect_equal(expected_out,
               redcaptidier_longitudintal_db %>%
                 extract_table(tbl = "repeated")
  )
})
