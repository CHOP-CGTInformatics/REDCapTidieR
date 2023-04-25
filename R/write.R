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
#' vignette in \link[openxlsx2]{wb_add_data_table}). Default "TableStyleLight8".
#'
#' @importFrom purrr map map2
#' @importFrom stringr str_trunc str_replace_all str_squish
#' @importFrom tidyselect any_of
#' @importFrom dplyr select mutate across
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
                                    tableStyle = "TableStyleLight8" #nolint: object_name_linter
) {
  # Initialize Workbook object ----
  wb <- openxlsx2::wb_workbook()

  # Create Sheet Names ----
  # Assign sheet values based on use of labels
  # Enforce max length of 31 per Excel restrictions
  sheet_vals <- if (labelled_sheets) {
    # Remove special characters from labelled sheet names that cause
    # openxlsx2 worksheet failures
    supertbl$redcap_form_label %>%
      str_replace_all("[[:punct:]]", "") %>%
      str_squish()
  } else {
    supertbl$redcap_form_name
  }

  sheet_vals <- str_trunc(sheet_vals, width = 31)

  # Construct default supertibble and metadata sheets ----
  if (incl_supertbl) {
    supertbl_toc <- supertbl %>%
      # Remove list elements
      select(-any_of(c("redcap_data", "redcap_metadata", "redcap_events"))) %>%
      # Necessary to avoid "Number stored as text" Excel dialogue warnings
      mutate(across(any_of("data_na_pct"), as.character))

    # Re-establish lost label(s) by referencing original labels and indexing
    # Generalized for future proofing
    labelled::var_label(supertbl_toc) <- labelled::var_label(supertbl)[names(labelled::var_label(supertbl_toc))]

    wb$add_worksheet(sheet = "supertibble")
    wb$add_data_table(sheet = "supertibble",
                      x = supertbl_toc,
                      startRow = ifelse(labelled, 2, 1),
                      tableStyle = tableStyle)
  }

  if (incl_meta) {
    supertbl_meta <- supertbl %>%
      select("redcap_metadata") %>% #nolint: object_usage_linter
      tidyr::unnest(cols = "redcap_metadata") %>% # record ID gets duplicated.
      # Since no other fields are allowed to be duplicated in REDCap,
      # can use filtering here for removal of duplicated record ID fields
      filter(!duplicated(.data$field_name))

    wb$add_worksheet(sheet = "supertibble_metadata")
    wb$add_data_table(sheet = "supertibble_metadata",
                      x = supertbl_meta,
                      startRow = ifelse(labelled, 2, 1),
                      tableStyle = tableStyle)
  }

  # Write all redcap_form_name to sheets ----
  map(
    sheet_vals,
    \(x) wb$add_worksheet(sheet = x)
  )

  # Write all redcap_data to sheets ----
  # Account for special case when a dataframe may have zero rows
  # This causes an error on opening the Excel file.
  # Instead, apply a row of auto-determined NA types.
  for (i in seq_len(nrow(supertbl))) {
    if (nrow(supertbl$redcap_data[[i]]) == 0) {
      supertbl$redcap_data[[i]] <- supertbl$redcap_data[[i]][1, ]
    }
  }

  map2(
    supertbl$redcap_data,
    sheet_vals,
    \(x, y) wb$add_data_table(sheet = y, x = x,
                              startRow = ifelse(labelled, 2, 1),
                              tableStyle = tableStyle)
  )

  # Add labelled features ----
  if (labelled) {
    add_labelled_xlsx_features(supertbl, wb, sheet_vals, incl_supertbl, incl_meta, supertbl_toc)
  }

  # Export workbook object
  openxlsx2::wb_save(wb, path = file, overwrite = TRUE)
}

#' @title Add labelled features to write_supertibble_xlsx
#'
#' @description
#' Helper function to support `labelled` aesthetics to XLSX supertibble output
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#' @param wb An `openxlsx2` workbook object
#' @param sheet_vals Helper argument passed from `write_supertibble_xlsx` to
#' determine and assign sheet values.
#' @param incl_supertbl Include a sheet capturing the supertibble output.
#' Default `TRUE`.
#' @param incl_meta Include a sheet capturing the combined output of the
#' supertibble `redcap_metadata`. Default `TRUE`.
#' @param supertbl_toc The table of contents supertibble defined in the parent
#' function.
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
                                       incl_meta = TRUE,
                                       supertbl_toc) {

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
    supertbl_labels <- supertbl_toc %>%
      labelled::lookfor() %>%
      select(.data$variable, .data$label) %>%
      pivot_wider(names_from = "variable", values_from = "label")

    wb$add_data(sheet = "supertibble",
                x = supertbl_labels, colNames = FALSE)
  }

  # Add supertbl_meta labels ----
  if (incl_meta) {
    supertbl_meta_labels <- supertbl %>%
      select("redcap_metadata") %>%
      pluck(1, 1) %>%
      labelled::lookfor() %>%
      select(.data$variable, .data$label) %>%
      pivot_wider(names_from = "variable", values_from = "label")

    wb$add_data(sheet = "supertibble_metadata",
                x = supertbl_meta_labels, colNames = FALSE)
  }

  # Define redcap_data variable labels
  var_labels <- supertbl$redcap_data %>% map(\(x) generate_dictionaries(x))

  for (i in seq_along(supertbl$redcap_form_name)) {
    wb$add_data(
      sheet = sheet_vals[i],
      x = var_labels[[i]], colNames = FALSE)
  }

  for (i in seq_len(nrow(wb$tables))) {
    dims <- gsub("[0-9]+", "1", wb$tables$tab_ref[i])

    wb$add_cell_style(sheet = i,
                      dims = dims,
                      wrapText = "1")
    wb$add_font(sheet = i,
                dims = dims,
                color = openxlsx2::wb_color(hex = "7F7F7F"),
                italic = "1")
  }
}
