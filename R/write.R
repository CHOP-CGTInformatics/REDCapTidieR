#' @title Write Supertibbles to XLSX
#'
#' @description
#' Write supertibble outputs to XLSX file outputs, where each REDCap data tibble
#' exists in a separate sheet.
#'
#' @param supertbl A supertibble generated using `read_redcap()`
#' @param labelled Whether or not to include labelled outputs, default `FALSE`.
#' Requires use of `make_labelled()`.
#' @param labelled_sheets Whether or not to include labels in the XLSX sheets
#' instead of raw values. Default `FALSE`.
#' @param file A character string naming an xlsx file
#' @param incl_supertbl Include a sheet capturing the supertibble output.
#' Default `TRUE`.
#' @param incl_meta Include a sheet capturing the combined output of the
#' supertibble `redcap_metadata`. Default `TRUE`.
#' @param tableStyle Any excel table style name or "none" (see "formatting"
#' vignette in \link[openxlsx]{writeDataTable}). Default "TableStyleLight10".
#'
#' @importFrom purrr map map2
#'
#' @return
#' A workbook object
#'
#' @examples
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' supertbl <- read_redcap(redcap_uri, token)
#' write_supertibble_xlsx(supertbl, file = "supertibble.xlsx")
#'
#' write_supertibble_xlsx(supertbl, labelled = TRUE, file = "supertibble.xlsx")
#' }
#'
#' @export

write_supertibble_xlsx <- function(supertbl,
                                   labelled = FALSE,
                                   labelled_sheets = FALSE,
                                   file,
                                   incl_supertbl = TRUE,
                                   incl_meta = TRUE,
                                   tableStyle = "TableStyleLight10" #nolint: object_name_linter
) {
  # Initialize Workbook object ----
  wb <- openxlsx::createWorkbook()

  # Assign sheet values based on use of labels
  sheet_vals <- if (labelled_sheets) {
    supertbl$redcap_form_label
  } else {
    supertbl$redcap_form_name
  }

  if (incl_supertbl) {
    openxlsx::addWorksheet(wb, sheetName = "supertibble")
    openxlsx::writeDataTable(wb, sheet = "supertibble",
                             x = supertbl %>%
                               mutate(redcap_data = "<tibble>",
                                      redcap_metadata = "<tibble>"),
                             startRow = ifelse(labelled, 2, 1),
                             tableStyle = tableStyle)
  }

  if (incl_meta) {
    supertbl_meta <- supertbl %>%
      select("redcap_metadata") %>% #nolint: object_usage_linter
      tidyr::unnest(cols = "redcap_metadata") %>% # record ID gets duplicated
      # since no other fields are allowed to be duplicated in REDCap,
      # can use filtering here for removal of duplicated record ID fields
      filter(!duplicated(.data$field_name))

    openxlsx::addWorksheet(wb, sheetName = "supertibble_metadata")
    openxlsx::writeDataTable(wb, sheet = "supertibble_metadata",
                             x = supertbl_meta,
                             startRow = ifelse(labelled, 2, 1),
                             tableStyle = tableStyle)
  }

  # Write all redcap_form_name to sheets
  map(
    sheet_vals,
    \(x) openxlsx::addWorksheet(wb, sheetName = x)
  )

  # Write all redcap_data to sheets
  map2(
    supertbl$redcap_data,
    sheet_vals,
    \(x, y) openxlsx::writeDataTable(wb, sheet = y, x = x,
                                     startRow = ifelse(labelled, 2, 1),
                                     tableStyle = tableStyle)
  )

  # Add labelled features ----
  if (labelled) {
    add_labelled_xlsx_features(supertbl, wb, sheet_vals, incl_supertbl, incl_meta)
  }

  # Export workbook object
  openxlsx::saveWorkbook(wb, file = file, overwrite = TRUE)
}

#' @title Add labelled features to write_supertibble_xlsx
#'
#' @description
#' Helper function to support `labelled` aesthetics to XLSX supertibble output
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#' @param wb An `openxlsx` workbook object
#' @param sheet_vals Helper argument passed from `write_supertibble_xlsx` to
#' determine and assign sheet values.
#' @param incl_supertbl Include a sheet capturing the supertibble output.
#' Default `TRUE`.
#' @param incl_meta Include a sheet capturing the combined output of the
#' supertibble `redcap_metadata`. Default `TRUE`.
#'
#' @importFrom purrr map pluck
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr select filter
#'
#' @keywords internal

add_labelled_xlsx_features <- function(supertbl,
                                       wb,
                                       sheet_vals,
                                       incl_supertbl = TRUE,
                                       incl_meta = TRUE) {
  # Define label header style ----
  label_header_style <- openxlsx::createStyle(fontColour = "#7F7F7F",
                                              textDecoration = "italic",
                                              wrapText = TRUE)

  # Generate variable labels off of labelled dictionary objects ----
  generate_dictionaries <- function(x) {
    labelled::generate_dictionary(x) %>%
      select("variable", "label") %>%
      pivot_wider(
        names_from = "variable",
        values_from = "label"
      )
  }

  # Add supertbl labels ----
  if (incl_supertbl) {
    supertbl_labels <- supertbl %>%
      labelled::lookfor() %>%
      select(.data$variable, .data$label) %>%
      pivot_wider(names_from = "variable", values_from = "label")

    openxlsx::writeData(wb = wb,
                        sheet = "supertibble",
                        x = supertbl_labels, colNames = FALSE)

    openxlsx::addStyle(wb,
                       sheet = "supertibble",
                       rows = 1,
                       cols = seq_along(supertbl_labels),
                       style = label_header_style)
  }

  # Add supertbl_meta labels ----
  if (incl_meta) {
    supertbl_meta_labels <- supertbl %>%
      select("redcap_metadata") %>%
      pluck(1, 1) %>%
      labelled::lookfor() %>%
      select(.data$variable, .data$label) %>%
      pivot_wider(names_from = "variable", values_from = "label")

    openxlsx::writeData(wb = wb,
                        sheet = "supertibble_metadata",
                        x = supertbl_meta_labels, colNames = FALSE)

    openxlsx::addStyle(wb,
                       sheet = "supertibble_metadata",
                       rows = 1,
                       cols = seq_along(supertbl_meta_labels),
                       style = label_header_style)
  }

  # Define redcap_data variable labels
  var_labels <- supertbl$redcap_data %>% map(\(x) generate_dictionaries(x))

  for (i in seq_along(supertbl$redcap_form_name)) {
    openxlsx::writeData(wb = wb,
                        sheet = sheet_vals[i],
                        x = var_labels[[i]], colNames = FALSE)

    # add style to labels
    openxlsx::addStyle(wb,
                       sheet = sheet_vals[i],
                       rows = 1,
                       cols = seq_along(var_labels[[i]]),
                       style = label_header_style)
  }
}
