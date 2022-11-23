# Tell httptest where to looks for mocks
# Need this here since devtools::test_path doesn't work in helper.R
# https://github.com/r-lib/testthat/issues/1270
httptest::.mockPaths(test_path("fixtures"))

test_that("read_redcap_tidy and import_redcap produce the same output", {

  httptest::with_mock_api({
    out_1 <-
      import_redcap(redcap_uri, longitudinal_token)

    out_2 <-
      read_redcap_tidy(redcap_uri, longitudinal_token) %>%
      suppressWarnings() # Suppress deprecation warning
  })

  expect_identical(out_1, out_2)
})
