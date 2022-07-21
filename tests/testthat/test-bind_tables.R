# Load initial variables
token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

test_that("bind_tables works with no specifications", {

  read_redcap_tidy(redcap_uri, token) %>%
    bind_tables()

  expect_true(exists("nonrepeated", envir = global_env()))
  expect_true(exists("nonrepeated2", envir = global_env()))
  expect_true(exists("repeated", envir = global_env()))
})

test_that("bind_tables works with environment specification", {

  sample_env <- new_environment()

  read_redcap_tidy(redcap_uri, token) %>%
    bind_tables(environment = sample_env)

  expect_true(exists("nonrepeated", envir = sample_env))
  expect_true(exists("nonrepeated2", envir = sample_env))
  expect_true(exists("repeated", envir = sample_env))
})

test_that("bind_tables works with forms specification", {

  sample_env <- new_environment()

  read_redcap_tidy(redcap_uri, token) %>%
    bind_tables(environment = sample_env, redcap_form_name = "nonrepeated")

  expect_true(exists("nonrepeated", envir = sample_env))
  expect_false(exists("nonrepeated2", envir = sample_env))
  expect_false(exists("repeated", envir = sample_env))
})

test_that("bind_tables works with structure specification", {

  sample_env <- new_environment()

  read_redcap_tidy(redcap_uri, token) %>%
    bind_tables(environment = sample_env, structure = "nonrepeating")

  expect_true(exists("nonrepeated", envir = sample_env))
  expect_true(exists("nonrepeated2", envir = sample_env))
  expect_false(exists("repeated", envir = sample_env))
})
