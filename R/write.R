#' @title Write Supertibbles to XLSX
#'
#' @description
#' Write supertibble outputs to XLSX file outputs, where each REDCap data tibble
#' exists in a separate sheet.
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#' @param labelled Whether or not to include labelled outputs, default `FALSE`.
#' Requires use of `make_labelled()`.
#' @param file A character string naming an xlsx file
#' @param tableStyle Any excel table style name or "none" (see "formatting"
#' vignette in \link[openxlsx]{writeDataTable}). Default "TableStyleLight10".
#'
#' @importFrom purrr map map2
#' @importFrom tidyr pivot_wider
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

write_supertibble_xlsx <- function(supertbl, labelled = FALSE, file, tableStyle = "TableStyleLight10"){

  # Initialize Workbook object
  wb <- openxlsx::createWorkbook()

  # Write all redcap_form_name to sheets
  purrr:::map(supertbl$redcap_form_name, \(x) openxlsx::addWorksheet(wb, sheetName = x))
  # Write all redcap_data to sheets
  purrr:::map2(supertbl$redcap_data,
               supertbl$redcap_form_name,
               \(x,y) openxlsx::writeDataTable(wb, sheet = y, x = x,
                                               startRow = ifelse(labelled, 2, 1),
                                               tableStyle = tableStyle))

  # Add labelled features
  if (labelled){
    # heading 1: Excel's "Explanatory Text" format
    label_header_style <- openxlsx::createStyle(fontColour = "#7F7F7F",
                                                textDecoration = "italic",
                                                wrapText = TRUE )

    # Generate variable labels off of labelled dictionary objects
    generate_dictionaries <- function(x) {
      labelled::generate_dictionary(x) %>% dplyr::select("variable", "label") %>%
        tidyr::pivot_wider(
          names_from = "variable",
          values_from = "label"
        )
    }

    var_labels <- data %>% purrr::map(\(x) generate_dictionaries(x))

    for (i in seq_along(supertbl$redcap_form_name)) {
      openxlsx::writeData(wb = wb,
                          sheet = supertbl$redcap_form_name[i],
                          x = var_labels[[i]], colNames = FALSE)

      # add style to labels
      openxlsx::addStyle(wb,
                         sheet = supertbl$redcap_form_name[i],
                         rows = 1,
                         cols = 1:length(var_labels[[i]]),
                         style = label_header_style)
    }

  }

  # Export workbook object
  openxlsx::saveWorkbook(wb, file = file, overwrite = TRUE)
}
