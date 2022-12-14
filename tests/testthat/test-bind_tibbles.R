# Load Sample Longitudinal Database
redcaptidier_longitudintal_db <- readRDS(
  system.file(
    "testdata/redcaptidier_longitudinal_db.RDS",
    package = "REDCapTidieR"
  )
)

test_that("bind_tibbles works with no specifications", {
  redcaptidier_longitudintal_db %>%
    bind_tibbles()

  expect_true(exists("nonrepeated", envir = global_env()))
  expect_true(exists("nonrepeated2", envir = global_env()))
  expect_true(exists("repeated", envir = global_env()))
  expect_s3_class(nonrepeated, "data.frame")
  expect_s3_class(nonrepeated2, "data.frame")
  expect_s3_class(repeated, "data.frame")
  rm(
    list = c("nonrepeated", "repeated", "nonrepeated2"),
    envir = global_env()
  )
})

test_that("bind_tibbles works with environment specification", {
  sample_env <- new_environment()

  redcaptidier_longitudintal_db %>%
    bind_tibbles(environment = sample_env)

  expect_true(exists("nonrepeated", envir = sample_env))
  expect_true(exists("nonrepeated2", envir = sample_env))
  expect_true(exists("repeated", envir = sample_env))
})

test_that("bind_tibbles works with forms specification", {
  redcaptidier_longitudintal_db %>%
    bind_tibbles(tbls = c("nonrepeated", "repeated"))

  expect_true(exists("nonrepeated", envir = global_env()))
  expect_false(exists("nonrepeated2", envir = global_env()))
  expect_true(exists("repeated", envir = global_env()))
  rm(list = c("nonrepeated", "repeated"), envir = global_env())
})

test_that("bind_tibbles errors with bad inputs", {
  expect_error(bind_tibbles(123), class = "arg_not_df")
  expect_error(bind_tibbles(tibble(), environment = "abc"), class = "arg_not_env")
  expect_error(bind_tibbles(tibble(), tbls = 123), class = "arg_not_character")
})
