test_that("supertibble prints with style", {
  tibble(redcap_form_name = letters[1:5], redcap_data = list(NULL)) %>%
    as_supertbl() %>%
    expect_snapshot()
})
