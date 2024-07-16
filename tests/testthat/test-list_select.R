test_that("list_select works", {
  db <- extract_tibbles(supertbl = superheroes_supertbl)

  # list_select returns everything by default
  everything_out <- list_select(db)

  expect_equal(db, everything_out)

  # list_select works with tidyselect valid specification
  selected_out <- list_select(db, starts_with("hero"))

  expect_equal(db[1], selected_out)

  # list_select returns empty tidyselect
  empty_out <- list_select(db, starts_with("empty"))

  # Create an empty named list
  empty_named_list <- list()
  names(empty_named_list) <- character(0)

  expect_equal(empty_out, empty_named_list)

  # list_select errors for hard-coded strings that don't exist
  expect_error(list_select(db, c("heroes_information", "fake_tbl")))
})
