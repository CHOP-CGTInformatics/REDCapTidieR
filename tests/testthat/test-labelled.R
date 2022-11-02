
test_that("make_labelled applies labels to supertibble",{
  supertbl <- tibble::tribble(
    ~ redcap_form_name, ~ redcap_data, ~ redcap_metadata,
    "form_1", tibble(x = letters[1:3]), tibble(field_name = "x", field_label = "X Label"),
    "form_2", tibble(y = letters[1:3]), tibble(field_name = "y", field_label = "Y Label")
  )

  out <- make_labelled(supertbl)

  # Main labels are applied
  labs <- labelled::var_label(out)

  expected_labs <- list(
    redcap_form_name = "Form Name",
    redcap_data = "Data",
    redcap_metadata = "Metadata"
  )

  expect_equal(labs, expected_labs)

  # Labels are applied to both metadata tibbles
  expected_metadata_labs <- list(
    field_name = "Field Name",
    field_label = "Field Label"
  )

  metadata_labs1 <- labelled::var_label(out$redcap_metadata[[1]])
  metadata_labs2 <- labelled::var_label(out$redcap_metadata[[2]])

  expect_equal(metadata_labs1, expected_metadata_labs)
  expect_equal(metadata_labs2, expected_metadata_labs)

  # TODO: Labels are applied to both data tibbles

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

test_that("make_labelled errors if redcap_metadata column is absent", {
  supertbl <- tibble::tribble(
    ~ redcap_form_name, ~ redcap_data,
    "form_1", tibble(x = letters[1:3])
  )

  make_labelled(supertbl) %>%
    expect_error(class = "missing_metadata")

})

