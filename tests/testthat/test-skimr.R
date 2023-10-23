test_that("add_skimr_metadata works", {
  skip_if_not_installed(pkg = "skimr")
  # Test two data field types for proof of concept: character and numeric
  supertbl <- tibble::tribble(
    ~redcap_data, ~redcap_metadata,
    tibble(record_id = c(1, 2, 3), x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"),
    tibble(record_id = c(1, 2, 3), y = seq(1:3)), tibble(field_name = "y", field_label = "Y Label")
  ) %>%
    as_supertbl()

  out <- add_skimr_metadata(supertbl)

  expected_skimr_char_cols <- c(
    "field_name",
    "field_label",
    "skim_type",
    "n_missing",
    "complete_rate",
    "character.min",
    "character.max",
    "character.empty",
    "character.n_unique",
    "character.whitespace"
  )

  expected_skimr_num_cols <- c(
    "field_name",
    "field_label",
    "skim_type",
    "n_missing",
    "complete_rate",
    "numeric.mean",
    "numeric.sd",
    "numeric.p0",
    "numeric.p25",
    "numeric.p50",
    "numeric.p75",
    "numeric.p100",
    "numeric.hist"
  )

  expect_true(all(expected_skimr_char_cols %in% names(out$redcap_metadata[[1]])))
  expect_true(all(expected_skimr_num_cols %in% names(out$redcap_metadata[[2]])))
})
