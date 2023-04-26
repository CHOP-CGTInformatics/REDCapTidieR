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

test_that("write_redcap_xlsx without labels works", {
  withr::with_dir(
    tempdir(), {
      write_redcap_xlsx(supertbl,
                        file = paste0(tempdir(), "supertbl_wb.xlsx"),
                        include_metadata = FALSE,
                        include_toc_from_supertbl = FALSE,
                        recode_yn = FALSE)
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


test_that("write_redcap_xlsx with labels works", {
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
      write_redcap_xlsx(labelled_supertbl,
                        labelled = TRUE,
                        file = paste0(tempdir(), "labelled_supertbl_wb.xlsx"),
                        include_toc_from_supertbl = FALSE,
                        include_metadata = FALSE,
                        recode_yn = FALSE)
      sheet_1 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "labelled_supertbl_wb.xlsx"), sheet = 1)
      sheet_2 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "labelled_supertbl_wb.xlsx"), sheet = 2)

      expect_equal(tibble::tibble(sheet_1), labelled_sheet_1, ignore_attr = TRUE)
      expect_equal(tibble::tibble(sheet_2), labelled_sheet_2, ignore_attr = TRUE)

      unlink(paste0(tempdir(), "labelled_supertbl_wb.xlsx"))
    }
  )
})

test_that("write_redcap_xlsx has expected supertibble and metadata outputs", {
  # tribble for readability
  expected_supertibble <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label, ~`Sheet #`,
    "a",                "A",                 1,
    "b",                "B",                 2,
    "REDCap Metadata",  NA,                  3
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
      write_redcap_xlsx(supertbl,
                        labelled = FALSE,
                        file = paste0(tempdir(), "default_supertbl_wb.xlsx"),
                        include_toc_from_supertbl = TRUE,
                        include_metadata = TRUE,
                        recode_yn = FALSE)
      sheet_1 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "default_supertbl_wb.xlsx"), sheet = 1)
      sheet_4 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "default_supertbl_wb.xlsx"), sheet = 4)

      expect_equal(sheet_1, expected_supertibble, ignore_attr = TRUE)
      expect_equal(sheet_4, expected_meta, ignore_attr = TRUE)

      unlink(paste0(tempdir(), "default_supertbl_wb.xlsx"))
    }
  )

  expected_supertibble_labels <- c(
    "REDCap Instrument Name",
    "REDCap Instrument Description",
    "Sheet #"
  )

  expected_meta_labels <- c(
    "Variable / Field Name",
    "Field Label"
  )

  withr::with_dir(
    tempdir(), {
      write_redcap_xlsx(supertbl %>% make_labelled(),
                        labelled = TRUE,
                        file = paste0(tempdir(), "default_labelled_supertbl_wb.xlsx"),
                        include_toc_from_supertbl = TRUE,
                        include_metadata = TRUE,
                        recode_yn = FALSE)
      sheet_1 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "default_labelled_supertbl_wb.xlsx"),
                                      sheet = 1,
                                      sep.names = " ")
      sheet_4 <- openxlsx2::read_xlsx(xlsxFile = paste0(tempdir(), "default_labelled_supertbl_wb.xlsx"),
                                      sheet = 4,
                                      sep.names = " ")

      expect_setequal(names(sheet_1), expected_supertibble_labels)
      expect_setequal(names(sheet_4), expected_meta_labels)

      unlink(paste0(tempdir(), "default_labelled_supertbl_wb.xlsx"))
    }
  )

})

test_that("write_redcap_xlsx checks work", {

  withr::with_dir(
    tempdir(), {
      supertbl %>%
        write_redcap_xlsx(labelled = TRUE,
                          file = paste0(tempdir(), "temp.xlsx"),
                          recode_yn = FALSE) %>%
        expect_error()

      supertbl %>%
        make_labelled() %>%
        write_redcap_xlsx(labelled = TRUE, file =
                            paste0(tempdir(), "temp.xlsx"),
                          recode_yn = FALSE) %>%
        expect_no_error()

      unlink(paste0(tempdir(), "temp.xlsx"))
    }
  )

})

test_that("bind_supertbl_metadata works", {

  supertbl_meta <- bind_supertbl_metadata(supertbl)
  expected_meta <- tibble::tribble(
    ~field_name, ~field_label,
    "record_id",  "Record ID",
    "col_a",      "Label A",
    "col_b",      "Label B"
  )

  expect_equal(supertbl_meta, expected_meta)

})

test_that("supertbl_recode works", {
  # Set up testable yesno fields and metadata
  redcap_data_c <- tibble::tribble(
    ~record_id, ~yesno,
    1,          TRUE,
    2,          FALSE,
    3,          NA
  )

  redcap_metadata_c <- tibble::tribble(
    ~field_name, ~field_type, ~field_label,
    "record_id",  "text",      "Record ID",
    "yesno",      "yesno",     "YesNo"
  )

  supertbl_recoded <- tibble::tribble(
    ~redcap_form_name, ~redcap_form_label, ~redcap_data,   ~redcap_metadata,
    "c",                "C",                redcap_data_c,  redcap_metadata_c
  ) %>%
    as_supertbl()

  # Pass through testing function
  supertbl_recoded_meta <- bind_supertbl_metadata(supertbl_recoded)

  out_false <- supertbl_recode(supertbl_recoded, supertbl_recoded_meta, recode_yn = FALSE)
  out_true <- supertbl_recode(supertbl_recoded, supertbl_recoded_meta, recode_yn = TRUE)

  # Set up expectations
  expected_out_true <- tibble::tribble(
    ~record_id, ~yesno,
    1,          "yes",
    2,          "no",
    3,          NA
  )


  expect_equal(out_false[[1]], redcap_data_c)
  expect_equal(out_true[[1]], expected_out_true)
})
