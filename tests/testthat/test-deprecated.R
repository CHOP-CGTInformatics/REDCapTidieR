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
      suppressWarnings(classes = "lifecycle_warning_deprecated")
  })

  expect_identical(out_1, out_2)
})

test_that("bind_tables and bind_tibbles produce the same output", {

  redcaptidier_longitudintal_db <- readRDS(
    system.file(
      "testdata/redcaptidier_longitudinal_db.RDS", package = "REDCapTidieR"
    )
  )

  env_1 <- new_environment()

  redcaptidier_longitudintal_db %>%
    bind_tibbles(tbls = c("nonrepeated", "repeated"),
                 environment = env_1)

  env_2 <- new_environment()

  redcaptidier_longitudintal_db %>%
    bind_tables(tbls = c("nonrepeated", "repeated"),
                 environment = env_2) %>%
    suppressWarnings(classes = "lifecycle_warning_deprecated")

  expect_true(all.equal(env_1, env_2))

})

test_that("extact_table and extract_tibble produce the same output", {

  redcaptidier_longitudintal_db <- readRDS(
    system.file(
      "testdata/redcaptidier_longitudinal_db.RDS", package = "REDCapTidieR"
    )
  )

  out_1 <- redcaptidier_longitudintal_db %>%
    extract_tibble(tbl = "nonrepeated")

  out_2 <- redcaptidier_longitudintal_db %>%
    extract_table(tbl = "nonrepeated") %>%
    suppressWarnings(classes = "lifecycle_warning_deprecated")

  expect_equal(out_1, out_2)

})

test_that("extact_tables and extract_tibbles produce the same output", {

  redcaptidier_longitudintal_db <- readRDS(
    system.file(
      "testdata/redcaptidier_longitudinal_db.RDS", package = "REDCapTidieR"
    )
  )

  out_1 <- redcaptidier_longitudintal_db %>%
    extract_tibbles(tbls = starts_with("non"))

  out_2 <- redcaptidier_longitudintal_db %>%
    extract_tables(tbls = starts_with("non")) %>%
    suppressWarnings(classes = "lifecycle_warning_deprecated")

  expect_equal(out_1, out_2)

})
