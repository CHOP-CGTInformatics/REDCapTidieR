# Load Sample Databases ----
`%notin%` <- Negate(`%in%`)
db_data <- readRDS(system.file("testdata/db_data.RDS", package = "REDCapTidieR"))
db_metadata <- readRDS(system.file("testdata/db_metadata.RDS", package = "REDCapTidieR"))

test_that("clean_redcap works", {
  out <- clean_redcap(db_data = db_data,
                      db_metadata = db_metadata)

  # Check general structure
  expect_true(is_tibble(out))
  expect_true(all(c("repeating", "nonrepeating") %in% out$structure))
  expect_true(!is.null(out$redcap_data))
})

test_that("extract_nonrepeat_table returns correct data types and tables", {
  nonrepeated <- extract_nonrepeat_table(form_name = "nonrepeated",
                                         db_data = db_data,
                                         db_metadata = db_metadata)

  data_field_types <- extract_nonrepeat_table(form_name = "data_field_types",
                                              db_data = db_data,
                                              db_metadata = db_metadata)

  # Check general structure
  expect_true(is_tibble(nonrepeated))
  expect_true(is_tibble(data_field_types))

  # Check checkbox elements are present
  expect_true("checkbox_multiple___1" %in% names(data_field_types))

  # Check all data types are expected
  expect_character(data_field_types$text)
  expect_character(data_field_types$note)
  expect_double(data_field_types$calculated)
  expect_double(data_field_types$dropdown_single)
  expect_double(data_field_types$radio_single)
  expect_double(data_field_types$checkbox_multiple___1)
  expect_double(data_field_types$yesno)
  expect_double(data_field_types$truefalse)
  expect_character(data_field_types$signature)
  expect_character(data_field_types$fileupload)
  expect_double(data_field_types$slider)

  # Check last columns are form_status_complete
  expect_true(
    names(data_field_types[,ncol(data_field_types)]) == "form_status_complete"
  )
  expect_true(
    names(nonrepeated[,ncol(nonrepeated)]) == "form_status_complete"
  )
})

test_that("extract_nonrepeat_table returns tables", {
  repeated <- extract_repeat_table(form_name = "repeated",
                                   db_data = db_data,
                                   db_metadata = db_metadata)

  # Check general structure
  expect_true(is_tibble(repeated))

  # Check last columns are form_status_complete
  expect_true(
    names(repeated[,ncol(repeated)]) == "form_status_complete"
  )
})
