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

test_that("write_supertibble_xlsx without labels works", {
  withr::with_dir(
    tempdir(), {
      write_supertibble_xlsx(supertbl,
                             file = paste0(tempdir(), "supertbl_wb.xlsx"),
                             incl_meta = FALSE,
                             incl_supertbl = FALSE)
      sheet_1 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "supertbl_wb.xlsx"), sheet = 1, startRow = 1)
      # For some reason, read_xlsx resets row names and starts at 2, likely due
      # to reading the column names as a row
      rownames(sheet_1) <- seq_len(nrow(sheet_1))

      sheet_2 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "supertbl_wb.xlsx"), sheet = 2)
      rownames(sheet_2) <- seq_len(nrow(sheet_2))

      # Ignore attr applied by openxlsx2 read_xlsx
      expect_equal(tibble::tibble(sheet_1), redcap_data_a, ignore_attr = TRUE)
      expect_equal(tibble::tibble(sheet_2), redcap_data_b, ignore_attr = TRUE)

      unlink(paste0(tempdir(), "supertbl_wb.xlsx"))
    }
  )
})


test_that("write_supertibble_xlsx with labels works", {
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
      write_supertibble_xlsx(labelled_supertbl,
                             labelled = TRUE,
                             file = paste0(tempdir(), "labelled_supertbl_wb.xlsx"),
                             incl_supertbl = FALSE,
                             incl_meta = FALSE)
      sheet_1 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "labelled_supertbl_wb.xlsx"), sheet = 1)
      sheet_2 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "labelled_supertbl_wb.xlsx"), sheet = 2)

      expect_equal(tibble::tibble(sheet_1), labelled_sheet_1, ignore_attr = TRUE)
      expect_equal(tibble::tibble(sheet_2), labelled_sheet_2, ignore_attr = TRUE)

      unlink(paste0(tempdir(), "labelled_supertbl_wb.xlsx"))
    }
  )
})

test_that("write_supertibble_xlsx has expected supertibble and metadata outputs", {
  # tribble for readability
  expected_supertibble <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label,
    "a",                "A",
    "b",                "B"
  ) %>%
    as.data.frame()

  expected_meta <- tibble::tribble(
    ~field_name, ~field_label,
    "record_id",  "Record ID",
    "col_a",      "Label A",
    "col_b",      "Label B"
  ) %>%
    as.data.frame()

  withr::with_dir(
    tempdir(), {
      write_supertibble_xlsx(supertbl,
                             labelled = FALSE,
                             file = paste0(tempdir(), "default_supertbl_wb.xlsx"),
                             incl_supertbl = TRUE,
                             incl_meta = TRUE)
      sheet_1 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "default_supertbl_wb.xlsx"), sheet = 1)
      sheet_2 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "default_supertbl_wb.xlsx"), sheet = 2)

      expect_equal(sheet_1, expected_supertibble, ignore_attr = TRUE)
      expect_equal(sheet_2, expected_meta, ignore_attr = TRUE)

      unlink(paste0(tempdir(), "default_supertbl_wb.xlsx"))
    }
  )

  expected_supertibble_labels <- c(
    "REDCap Instrument Name",
    "REDCap Instrument Description"
  )

  expected_meta_labels <- c(
    "Variable / Field Name",
    "Field Label"
  )

  withr::with_dir(
    tempdir(), {
      write_supertibble_xlsx(supertbl %>% make_labelled(),
                             labelled = TRUE,
                             file = paste0(tempdir(), "default_labelled_supertbl_wb.xlsx"),
                             incl_supertbl = TRUE,
                             incl_meta = TRUE)
      sheet_1 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "default_labelled_supertbl_wb.xlsx"),
                                     sheet = 1,
                                     sep.names = " ")
      sheet_2 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "default_labelled_supertbl_wb.xlsx"),
                                     sheet = 2,
                                     sep.names = " ")

      expect_setequal(names(sheet_1), expected_supertibble_labels)
      expect_setequal(names(sheet_2), expected_meta_labels)

      unlink(paste0(tempdir(), "default_labelled_supertbl_wb.xlsx"))
    }
  )

})
