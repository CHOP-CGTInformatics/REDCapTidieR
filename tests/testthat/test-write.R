test_that("write_supertibble_xlsx works", {
  redcap_data_a <- tibble::tribble(
    ~record_id, ~col_a,
    1,          "A"
  )

  redcap_metadata_a <- tibble::tribble(
    ~field_name, ~field_label,
    "record_id",  "Record ID",
    "col_a",      "Label A"
  )

  redcap_data_b <- tibble::tribble(
    ~record_id, ~col_b,
    1,          "B"
  )

  redcap_metadata_b <- tibble::tribble(
    ~field_name, ~field_label,
    "record_id",  "Record ID",
    "col_b",      "Label B"
  )

  supertbl <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label, ~redcap_data,   ~redcap_metadata,
    "a",                "A",                redcap_data_a,  redcap_metadata_a,
    "b",                "B",                redcap_data_b,  redcap_metadata_b
  ) %>%
    as_supertbl()

  withr::with_dir(
    tempdir(), {
      write_supertibble_xlsx(supertbl, file = paste0(tempdir(), "supertbl_wb.xlsx"))
      sheet_1 <- openxlsx::read.xlsx(xlsxFile = paste0(tempdir(), "supertbl_wb.xlsx"), sheet = 1)
      sheet_2 <- openxlsx::read.xlsx(xlsxFile = paste0(tempdir(), "supertbl_wb.xlsx"), sheet = 2)

      expect_equal(tibble::tibble(sheet_1), redcap_data_a)
      expect_equal(tibble::tibble(sheet_2), redcap_data_b)
    }
  )

  labelled_supertbl <- make_labelled(supertbl)

  labelled_sheet_1 <- tibble::tribble(
    ~"Record.ID", ~"Label.A",
    "record_id",   "col_a",
    "1",           "A"
  )

  labelled_sheet_2 <- tibble::tribble(
    ~"Record.ID", ~"Label.B",
    "record_id",   "col_b",
    "1",           "B"
  )

  withr::with_dir(
    tempdir(), {
      write_supertibble_xlsx(labelled_supertbl, labelled = TRUE, file = paste0(tempdir(), "labelled_supertbl_wb.xlsx"))
      sheet_1 <- openxlsx::read.xlsx(xlsxFile = paste0(tempdir(), "labelled_supertbl_wb.xlsx"), sheet = 1)
      sheet_2 <- openxlsx::read.xlsx(xlsxFile = paste0(tempdir(), "labelled_supertbl_wb.xlsx"), sheet = 2)

      expect_equal(tibble::tibble(sheet_1), labelled_sheet_1)
      expect_equal(tibble::tibble(sheet_2), labelled_sheet_2)
    }
  )
})
