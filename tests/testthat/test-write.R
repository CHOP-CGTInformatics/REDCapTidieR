redcap_data_a <- tibble::tribble(
  ~record_id, ~col_a,
  1,          "A"
)

redcap_metadata_a <- tibble::tribble(
  ~field_name, ~field_label, ~field_type,
  "record_id", "Record ID", "text",
  "col_a", "Label A", "text"
)

redcap_data_b <- tibble::tribble(
  ~record_id, ~col_b,
  1,          "B"
)

redcap_metadata_b <- tibble::tribble(
  ~field_name, ~field_label, ~field_type,
  "record_id", "Record ID", "text",
  "col_b", "Label B", "text"
)

supertbl <- tibble::tribble(
  ~redcap_form_name, ~redcap_form_label, ~redcap_data, ~redcap_metadata,
  "a", "A", redcap_data_a, redcap_metadata_a,
  "b", "B", redcap_data_b, redcap_metadata_b
) %>%
  as_supertbl()

test_that("write_redcap_xlsx without labels works", {
  withr::with_tempdir({
    write_redcap_xlsx(supertbl,
      file = "supertbl_wb.xlsx",
      include_metadata_sheet = FALSE,
      include_toc_sheet = FALSE,
      recode_logical = FALSE
    )
    sheet_1 <- openxlsx2::read_xlsx(file = "supertbl_wb.xlsx", sheet = 1, start_row = 1)
    # For some reason, read_xlsx resets row names and starts at 2, likely due
    # to reading the column names as a row
    rownames(sheet_1) <- seq_len(nrow(sheet_1))

    sheet_2 <- openxlsx2::read_xlsx(file = "supertbl_wb.xlsx", sheet = 2)
    rownames(sheet_2) <- seq_len(nrow(sheet_2))

    # Ignore attr applied by openxlsx2 read_xlsx
    expect_equal(tibble::tibble(sheet_1), redcap_data_a, ignore_attr = TRUE)
    expect_equal(tibble::tibble(sheet_2), redcap_data_b, ignore_attr = TRUE)
  })
})


test_that("write_redcap_xlsx with labels works", {
  labelled_supertbl <- make_labelled(supertbl)

  labelled_sheet_1 <- tibble::tribble(
    ~"Record ID", ~"Label A",
    "record_id", "col_a",
    "1", "A"
  )

  labelled_sheet_2 <- tibble::tribble(
    ~"Record ID", ~"Label B",
    "record_id", "col_b",
    "1", "B"
  )

  withr::with_tempdir({
    write_redcap_xlsx(labelled_supertbl,
      add_labelled_column_headers = TRUE,
      file = "labelled_supertbl_wb.xlsx",
      include_toc_sheet = FALSE,
      include_metadata_sheet = FALSE,
      recode_logical = FALSE
    )
    sheet_1 <- openxlsx2::read_xlsx(file = "labelled_supertbl_wb.xlsx", sheet = 1)
    sheet_2 <- openxlsx2::read_xlsx(file = "labelled_supertbl_wb.xlsx", sheet = 2)

    expect_equal(tibble::tibble(sheet_1), labelled_sheet_1, ignore_attr = TRUE)
    expect_equal(tibble::tibble(sheet_2), labelled_sheet_2, ignore_attr = TRUE)
  })
})

test_that("write_redcap_xlsx has expected supertibble and metadata outputs", {
  # tribble for readability
  expected_supertibble <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label, ~`Sheet #`,
    "a", "A", 1,
    "b", "B", 2,
    "REDCap Metadata", NA, 3
  ) %>%
    as.data.frame()

  expected_meta <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label, ~field_name, ~field_label, ~field_type,
    NA, NA, "record_id", "Record ID", "text",
    "a", "A", "col_a", "Label A", "text",
    "b", "B", "col_b", "Label B", "text"
  ) %>%
    as.data.frame()

  withr::with_tempdir({
    write_redcap_xlsx(supertbl,
      add_labelled_column_headers = FALSE,
      file = "default_supertbl_wb.xlsx",
      include_toc_sheet = TRUE,
      include_metadata_sheet = TRUE,
      recode_logical = FALSE
    )
    sheet_1 <- openxlsx2::read_xlsx(file = "default_supertbl_wb.xlsx", sheet = 1)
    # Address rowname discrepancies
    rownames(sheet_1) <- seq_len(nrow(sheet_1))
    sheet_4 <- openxlsx2::read_xlsx(file = "default_supertbl_wb.xlsx", sheet = 4)
    rownames(sheet_4) <- seq_len(nrow(sheet_4))

    expect_equal(sheet_1, expected_supertibble, ignore_attr = TRUE)
    expect_equal(sheet_4, expected_meta, ignore_attr = TRUE)
  })

  expected_supertibble_labels <- c(
    "REDCap Instrument Name",
    "REDCap Instrument Description",
    "Sheet #"
  )

  expected_meta_labels <- c(
    "REDCap Instrument Name",
    "REDCap Instrument Description",
    "Variable / Field Name",
    "Field Label",
    "Field Type"
  )

  withr::with_tempdir({
    write_redcap_xlsx(supertbl %>% make_labelled(),
      add_labelled_column_headers = TRUE,
      file = "default_labelled_supertbl_wb.xlsx",
      include_toc_sheet = TRUE,
      include_metadata_sheet = TRUE,
      recode_logical = FALSE
    )
    sheet_1 <- openxlsx2::read_xlsx(
      file = "default_labelled_supertbl_wb.xlsx",
      sheet = 1
    )
    sheet_4 <- openxlsx2::read_xlsx(
      file = "default_labelled_supertbl_wb.xlsx",
      sheet = 4
    )

    expect_setequal(names(sheet_1), expected_supertibble_labels)
    expect_setequal(names(sheet_4), expected_meta_labels)
  })
})

test_that("write_redcap_xlsx checks work", {
  withr::with_tempdir({
    supertbl %>%
      write_redcap_xlsx(
        add_labelled_column_headers = TRUE,
        file = "temp.xlsx",
        recode_logical = FALSE
      ) %>%
      expect_error()

    supertbl %>%
      make_labelled() %>%
      write_redcap_xlsx(
        add_labelled_column_headers = TRUE, file =
          "temp.xlsx",
        recode_logical = FALSE
      ) %>%
      expect_no_error()
  })
})

test_that("bind_supertbl_metadata works", {
  supertbl_meta <- bind_supertbl_metadata(supertbl)
  expected_meta <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label, ~field_name, ~field_label, ~field_type,
    NA, NA, "record_id", "Record ID", "text",
    "a", "A", "col_a", "Label A", "text",
    "b", "B", "col_b", "Label B", "text"
  )

  expect_equal(supertbl_meta, expected_meta)
})

test_that("supertbl_recode works", {
  # Set up testable yesno fields and metadata
  redcap_data_c <- tibble::tribble(
    ~record_id, ~yesno, ~checkbox,
    1,          TRUE,   TRUE,
    2,          FALSE,  FALSE,
    3,          NA,     NA
  )

  redcap_metadata_c <- tibble::tribble(
    ~field_name, ~field_type, ~field_label,
    "record_id", "text", "Record ID",
    "yesno", "yesno", "YesNo",
    "checkbox", "checkbox", "Checkbox"
  )

  supertbl_recoded <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label, ~redcap_data, ~redcap_metadata,
    "c", "C", redcap_data_c, redcap_metadata_c
  ) %>%
    as_supertbl() %>%
    make_labelled()

  # Pass through testing function
  supertbl_recoded_meta <- bind_supertbl_metadata(supertbl_recoded)

  out <- supertbl_recode(supertbl_recoded,
    supertbl_recoded_meta,
    add_labelled_column_headers = TRUE
  )

  # Set up expectations
  expected_out <- tibble::tribble(
    ~record_id, ~yesno, ~checkbox,
    1,          "yes",  "Checked",
    2,          "no",   "Unchecked",
    3,          NA,     NA
  )

  # Add labels to check for preservation
  labelled::var_label(expected_out) <- c("Record ID", "YesNo", "Checkbox")

  expect_equal(out[[1]], expected_out)
})

test_that("check_labelled works", {
  labelled_supertbl <- supertbl %>%
    make_labelled()

  # Check possibilities for unlabelled supertbl
  expect_false(check_labelled(supertbl, add_labelled_column_headers = NULL))
  expect_error(check_labelled(supertbl, add_labelled_column_headers = TRUE), class = "missing_labelled_labels")
  expect_false(check_labelled(supertbl, add_labelled_column_headers = FALSE))

  # Check possibilities for labelled supertbl
  expect_true(check_labelled(labelled_supertbl, add_labelled_column_headers = NULL))
  expect_true(check_labelled(labelled_supertbl, add_labelled_column_headers = TRUE))
  expect_false(check_labelled(labelled_supertbl, add_labelled_column_headers = FALSE))
})

test_that("key argument checks work", {
  # labelled arg
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", add_labelled_column_headers = "char"),
    class = "check_logical"
  )
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", add_labelled_column_headers = 1),
    class = "check_logical"
  )

  # use_labels_for_sheet_names arg
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", use_labels_for_sheet_names = NULL),
    class = "check_logical"
  )
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", use_labels_for_sheet_names = "char"),
    class = "check_logical"
  )
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", use_labels_for_sheet_names = 1),
    class = "check_logical"
  )
  # include_toc_sheet arg
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", include_toc_sheet = NULL),
    class = "check_logical"
  )
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", include_toc_sheet = "char"),
    class = "check_logical"
  )
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", include_toc_sheet = 1),
    class = "check_logical"
  )

  # include_metadata_sheet arg
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", include_metadata_sheet = NULL),
    class = "check_logical"
  )
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", include_metadata_sheet = "char"),
    class = "check_logical"
  )
  expect_error(
    write_redcap_xlsx(supertbl, file = "temp.xlsx", include_metadata_sheet = 1),
    class = "check_logical"
  )

  # recode_logical arg
  expect_error(write_redcap_xlsx(supertbl, file = "temp.xlsx", recode_logical = NULL), class = "check_logical")
  expect_error(write_redcap_xlsx(supertbl, file = "temp.xlsx", recode_logical = "char"), class = "check_logical")
  expect_error(write_redcap_xlsx(supertbl, file = "temp.xlsx", recode_logical = 1), class = "check_logical")

  # file arg
  withr::with_tempdir({
    expect_warning(write_redcap_xlsx(supertbl, file = "temp.docx"),
      class = "invalid_file_extension"
    )
  })
  withr::with_tempdir({
    expect_warning(write_redcap_xlsx(supertbl, file = "temp"),
      class = "invalid_file_extension"
    )
  })
  expect_error(write_redcap_xlsx(supertbl, file = TRUE), class = "check_character")
  expect_error(write_redcap_xlsx(supertbl, file = NULL), class = "check_character")
})

test_that("bind_supertbl_metadata works", {
  # Create a supertbl metadata table representing in the output and check all
  # expected elements are present
  expected_meta <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label, ~field_name, ~field_label, ~field_type,
    NA, NA, "record_id", "Record ID", "text",
    "a", "A", "col_a", "Label A", "text",
    "b", "B", "col_b", "Label B", "text"
  )

  supertbl_meta <- supertbl %>%
    bind_supertbl_metadata()

  expect_equal(expected_meta, supertbl_meta)
  expect_true(all(names(expected_meta) %in% names(supertbl_meta)))
})



test_that("Combining skimr, labelled, and xlsx returns expected snapshot", {
  skip_on_cran()
  skip_on_ci()
  out <-
    read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API")) %>%
    # Suppress expected warnings from the REDCapTidieR Classic database.
    # Warnings here are meant to validate checks in other tests.
    suppressWarnings(classes = c(
      "field_missing_categories",
      "empty_parse_warning",
      "duplicate_labels"
    ))

  withr::with_tempdir({
    wb_obj <- out %>%
      make_labelled() %>%
      add_skimr_metadata() %>%
      write_redcap_xlsx(file = "temp.xlsx")
  })

  # Extract all data from wb_obj per sheet, assign to a dataframe
  wb_obj_data <- purrr::map(wb_obj$tables$tab_sheet, ~ openxlsx2::wb_to_df(wb_obj, sheet = .x))

  # Select additional wb elements of interest, combine with wb_obj_data
  wb_list <- list(
    wb_obj_data,
    wb_obj$tables,
    wb_obj$workbook,
    wb_obj$workbook.xml.rels,
    wb_obj$sheetOrder,
    wb_obj$sheet_names
  )

  expect_snapshot(wb_list, cran = FALSE) # Not to be checked on CRAN
})

test_that("excel_trunc_unique works", {
  sheet_vals <- c(
    "A",
    "Really Really Long Form Name 111",
    "Really Really Long Form Name 1110",
    "Really Really Long Form Name 112",
    "Really Really Long Form Nam.(2)",
    "Really Really Long Form Name 113",
    "Really Really Long Form Name 114",
    "Really Really Long Form Name 115",
    "Really Really Long Form Name 116",
    "Really Really Long Form Name 117",
    "Really Really Long Form Name 118",
    "Really Really Long Form Name 119"
  )

  expected_out <- c(
    "A", # Regular cols handled the same
    "Really Really Long Form Name...", # Initial appended with ...
    "Really Really Long Form Nam.(3)",
    "Really Really Long Form Nam.(4)",
    "Really Really Long Form Nam.(2)", # Position locked
    "Really Really Long Form Nam.(5)",
    "Really Really Long Form Nam.(6)",
    "Really Really Long Form Nam.(7)",
    "Really Really Long Form Nam.(8)",
    "Really Really Long Form Nam.(9)",
    "Really Really Long Form Na.(10)", # Additional magnitudes of characters handled
    "Really Really Long Form Na.(11)"
  )

  expect_warning(excel_trunc_unique(sheet_vals))
  out <- suppressWarnings(excel_trunc_unique(sheet_vals))

  expect_equal(out, expected_out)
})
