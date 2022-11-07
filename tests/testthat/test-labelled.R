
test_that("make_labelled applies labels to all elements of supertibble",{
  supertbl <- tibble::tribble(
    ~ redcap_data, ~ redcap_metadata,
    tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"),
    tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label")
  )

  out <- make_labelled(supertbl)

  # Main labels are applied
  main_labs <- labelled::var_label(out)

  expected_main_labs <- list(
    redcap_data = "Data",
    redcap_metadata = "Metadata"
  )

  expect_equal(main_labs, expected_main_labs)

  # Labels are applied to both metadata tibbles
  expected_metadata_labs <- list(
    field_name = "Field Name",
    field_label = "Field Label"
  )

  metadata_labs1 <- labelled::var_label(out$redcap_metadata[[1]])
  metadata_labs2 <- labelled::var_label(out$redcap_metadata[[2]])

  expect_equal(metadata_labs1, expected_metadata_labs)
  expect_equal(metadata_labs2, expected_metadata_labs)

  # Labels are applied to both data tibbles

  data_labs1 <- labelled::var_label(out$redcap_data[[1]])
  data_labs2 <- labelled::var_label(out$redcap_data[[2]])

  expect_equal(data_labs1, list(x = "X Label"))
  expect_equal(data_labs2, list(y = "Y Label"))

})

test_that("make_labelled applies all predefined labeles", {
  # Set up supertibble
  supertbl <- tibble(
    redcap_form_name = NA,
    redcap_form_label = NA,
    redcap_data = NA,
    redcap_metadata = NA,
    redcap_events = NA,
    structure = NA,
    data_rows = NA,
    data_cols = NA,
    data_size = NA,
    data_na_pct = NA
  )

  supertbl$redcap_data <- list(tibble::tribble(
    ~ redcap_repeat_instance,
    ~ redcap_event,
    ~ redcap_arm,
    ~ form_status_complete
  ))

  # These won't get predefined labels but need them so we don't error
  supertbl$redcap_metadata <- list(tibble::tribble(
    ~ field_name,
    ~ field_label
  ))

  out <- make_labelled(supertbl)

  # Check main labs
  main_labs <- labelled::var_label(out)

  expected_main_labs <- list(
    redcap_form_name = "Form Name",
    redcap_form_label = "Form Label",
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    redcap_events = "Events",
    structure = "Form Structure",
    data_rows = "# Rows",
    data_cols = "# Columns",
    data_size = "Memory Size",
    data_na_pct = "% NA"
  )

  expect_equal(main_labs, expected_main_labs)

  # Check data labs
  data_labs <- labelled::var_label(out$redcap_data[[1]])

  expected_data_labs <- list(
    redcap_repeat_instance = "Repeat Instance",
    redcap_event = "Event",
    redcap_arm = "Arm",
    form_status_complete = "Form Status"
  )

  expect_equal(data_labs, expected_data_labs)

})

test_that("make_labelled handles supertibble with extra columns", {
  supertbl <- tibble::tribble(
    ~ redcap_form_name, ~ redcap_data, ~ redcap_metadata, ~ extra_field,
    "form_1", tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"), "extra"
  )

  out <- make_labelled(supertbl)

  labs <- labelled::var_label(out)

  expected_labs <- list(
    redcap_form_name = "Form Name",
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    extra_field = NULL
  )

  expect_equal(labs, expected_labs)
})

test_that("make_labelled handles redcap_metadata tibbles of different sizes ", {
  supertbl <- tibble::tribble(
    ~ redcap_form_name, ~ redcap_data, ~ redcap_metadata,
    "form_1", tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"),
    "form_2", tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label", some_extra_metadata = "123")
  )

  out <- make_labelled(supertbl)

  base_metadata_labs <- list(
    field_name = "Field Name",
    field_label = "Field Label"
  )

  # Second instrument has normal metadata fields plus an additional field we
  # need to label correctly
  extra_metadata_labs <- c(
    base_metadata_labs, list(some_extra_metadata = "Some Extra Metadata")
  )

  metadata_labs1 <- labelled::var_label(out$redcap_metadata[[1]])
  metadata_labs2 <- labelled::var_label(out$redcap_metadata[[2]])

  expect_equal(metadata_labs1, base_metadata_labs)
  expect_equal(metadata_labs2, extra_metadata_labs)

})
