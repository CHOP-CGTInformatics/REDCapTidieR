# Load Sample Longitudinal Database
redcaptidier_longitudintal_db <- readRDS(
  system.file(
    "testdata/redcaptidier_longitudinal_db.RDS", package = "REDCapTidieR"
    )
  )

test_that("bind_tables works with no specifications", {
    redcaptidier_longitudintal_db %>%
      bind_tables()

    expect_true(exists("nonrepeated", envir = global_env()))
    expect_true(exists("nonrepeated2", envir = global_env()))
    expect_true(exists("repeated", envir = global_env()))
    expect_s3_class(nonrepeated, "data.frame")
    expect_s3_class(nonrepeated2, "data.frame")
    expect_s3_class(repeated, "data.frame")
    rm(list = c("nonrepeated", "repeated", "nonrepeated2"),
       envir = global_env())
})

test_that("bind_tables works with environment specification", {

  sample_env <- new_environment()

  redcaptidier_longitudintal_db %>%
    bind_tables(environment = sample_env)

  expect_true(exists("nonrepeated", envir = sample_env))
  expect_true(exists("nonrepeated2", envir = sample_env))
  expect_true(exists("repeated", envir = sample_env))
})

test_that("bind_tables works with forms specification", {

  redcaptidier_longitudintal_db %>%
    bind_tables(tbls = c("nonrepeated", "repeated"))

  expect_true(exists("nonrepeated", envir = global_env()))
  expect_false(exists("nonrepeated2", envir = global_env()))
  expect_true(exists("repeated", envir = global_env()))
  rm(list = c("nonrepeated", "repeated"), envir = global_env())
})

test_that("bind_tables works with structure specification", {

  redcaptidier_longitudintal_db %>%
    bind_tables(structure = "nonrepeating")

  expect_true(exists("nonrepeated", envir = global_env()))
  expect_true(exists("nonrepeated2", envir = global_env()))
  expect_false(exists("repeated", envir = global_env()))
  rm(list = c("nonrepeated", "nonrepeated2"), envir = global_env())
})
