# Load Sample REDCapTidieR Database Longitudinal Output
redcaptidier_longitudintal_db <-
  readRDS(system.file("testdata/redcaptidier_longitudinal_db.RDS", package = "REDCapTidieR"))

test_that("extract_tibbles works with a vector and tidyselect selectors", {
  # Test tidyselectors work
  expected_everything_out <- list(
    nonrepeated = redcaptidier_longitudintal_db$redcap_data[[1]],
    nonrepeated2 = redcaptidier_longitudintal_db$redcap_data[[2]],
    repeated = redcaptidier_longitudintal_db$redcap_data[[3]]
  )
  expected_starts_with_out <- list(
    nonrepeated = redcaptidier_longitudintal_db$redcap_data[[1]],
    nonrepeated2 = redcaptidier_longitudintal_db$redcap_data[[2]]
  )
  expected_ends_with_out <- list(
    nonrepeated2 = redcaptidier_longitudintal_db$redcap_data[[2]]
  )
  expected_traditional_out <- list(
    nonrepeated = redcaptidier_longitudintal_db$redcap_data[[1]],
    repeated = redcaptidier_longitudintal_db$redcap_data[[3]]
  )

  expect_equal(
    redcaptidier_longitudintal_db %>%
      extract_tibbles(tbls = everything()),
    expected_everything_out
  )
  expect_equal(
    redcaptidier_longitudintal_db %>%
      extract_tibbles(tbls = starts_with("non")),
    expected_starts_with_out
  )
  expect_equal(
    redcaptidier_longitudintal_db %>%
      extract_tibbles(tbls = ends_with("2")),
    expected_ends_with_out
  )
  expect_equal(
    redcaptidier_longitudintal_db %>%
      extract_tibbles(tbls = c("nonrepeated", "repeated")),
    expected_traditional_out
  )
  expect_error(redcaptidier_longitudintal_db %>%
    extract_tibbles(tbls = c("repeated", "fake_instrument_name")))
})

test_that("extract_tibble works", {
  expect_error(extract_tibble(redcaptidier_longitudintal_db, "fake_instrument_name"))

  expected_out <- redcaptidier_longitudintal_db$redcap_data[[1]]
  expect_equal(
    expected_out,
    redcaptidier_longitudintal_db %>%
      extract_tibble(tbl = "nonrepeated")
  )
})
