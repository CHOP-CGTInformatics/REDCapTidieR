#' @title Write Supertibbles to XLSX
#'
#' @description
#' Write supertibble outputs to XLSX file outputs, where each REDCap data tibble
#' exists in a separate sheet.
#'
#' @param supertbl A supertibble generated using `read_redcap()`
#' @param file A file name to write to
#' @param add_labelled_column_headers If `TRUE`, row 1 of each sheet will contain variable labels. Row 2 will contain
#' variable names. If `FALSE`, row 1 will contain variable names. The default, `NULL`, attempts to determine
#' if `supertbl` has variable labels and, if detected, includes them in row 1. `labelled` must be installed if
#' `add_labelled_column_headers` is `TRUE`.
#' @param use_labels_for_sheet_names If `TRUE`, sheets in the xlsx output will be named with the values in
#' `supertbl$redcap_form_label`. If `FALSE`, sheets will be named with values from `supertbl$redcap_form_name`.
#' Default `TRUE`.
#' @param include_toc_sheet If `TRUE`, the first sheet in the xlsx output will be a table of contents
#' with information about each data tibble included in the workbook. Default `TRUE`.
#' @param include_metadata_sheet If `TRUE`, the last sheet in the xlsx output will contain metadata about each
#' variable, combining the content of `supertbl$redcap_metadata`. Default `TRUE`.
#' @param table_style Any excel table style name or "none" (see "formatting"
#' vignette in \link[openxlsx2]{wb_add_data_table}). Default "tableStyleLight8".
#' @param column_width Width to set columns across the workbook. Default
#' "auto", otherwise a numeric value. Standard Excel is 8.43.
#' @param recode_logical If `TRUE`, fields with "yesno" field type are recoded to "yes"/"no" and fields
#' with a "checkbox" field type are recoded to "Checked"/"Unchecked". Default `TRUE`.
#' @param na_strings Value used for replacing NA values in `supertbl`. Default is "".
#' @param overwrite If `FALSE`, will not overwrite `file` when it exists. Default `TRUE`.
#'
#' @importFrom purrr map map2
#' @importFrom stringr str_trunc str_replace_all str_squish
#' @importFrom dplyr select pull
#' @importFrom rlang check_installed
#' @importFrom lubridate is.period is.difftime
#' @importFrom tidyselect where
#'
#' @return
#' An `openxlsx2` workbook object, invisibly
#'
#' @examples
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' supertbl <- read_redcap(redcap_uri, token)
#'
#' supertbl %>%
#'   write_redcap_xlsx(file = "supertibble.xlsx")
#'
#' supertbl %>%
#'   write_redcap_xlsx(file = "supertibble.xlsx", add_labelled_column_headers = TRUE)
#' }
#'
#' @export

write_redcap_xlsx <- function(supertbl,
                              file,
                              add_labelled_column_headers = NULL,
                              use_labels_for_sheet_names = TRUE,
                              include_toc_sheet = TRUE,
                              include_metadata_sheet = TRUE,
                              table_style = "tableStyleLight8",
                              column_width = "auto",
                              recode_logical = TRUE,
                              na_strings = "",
                              overwrite = TRUE
) {
  # Enforce checks ----
  check_arg_is_supertbl(supertbl)
  check_arg_is_character(file, any.missing = FALSE)
  check_arg_is_valid_extension(file, valid_extensions = c("xlsx"))
  check_arg_is_logical(add_labelled_column_headers, null.ok = TRUE)
  check_arg_is_logical(use_labels_for_sheet_names, any.missing = FALSE)
  check_arg_is_logical(include_toc_sheet, any.missing = FALSE)
  check_arg_is_logical(include_metadata_sheet, any.missing = FALSE)
  check_arg_is_logical(recode_logical, any.missing = FALSE)
  check_arg_is_logical(overwrite, any.missing = FALSE)

  add_labelled_column_headers <- check_labelled(supertbl, add_labelled_column_headers)

  # Initialize Workbook object ----
  check_installed("openxlsx2", reason = "to write Excel files.")
  wb <- openxlsx2::wb_workbook()

  # Create Sheet Names ----
  # Assign sheet values based on use of labels
  # Enforce max length of 31 per Excel restrictions
  sheet_vals <- if (use_labels_for_sheet_names) {
    # Remove special characters from labelled sheet names that cause
    # openxlsx2 worksheet failures
    supertbl$redcap_form_label %>%
      str_replace_all("[[:punct:]]", "") %>%
      str_squish()
  } else {
    supertbl$redcap_form_name
  }

  sheet_vals <- str_trunc(sheet_vals, width = 31)

  # Construct default supertibble sheet ----
  if (include_toc_sheet) {
    supertbl_toc <- add_supertbl_toc(wb,
                                     supertbl,
                                     include_metadata_sheet,
                                     add_labelled_column_headers,
                                     table_style,
                                     column_width,
                                     na_strings)
  }

  # Write all redcap_form_name to sheets ----
  map(
    sheet_vals,
    function(x) wb$add_worksheet(sheet = x)
  )

  # Write all redcap_data to sheets ----
  # Define supertibble metadata
  supertbl_meta <- bind_supertbl_metadata(supertbl)

  # Apply recodes based on metadata
  if (recode_logical) {
    supertbl$redcap_data <- supertbl_recode(supertbl, supertbl_meta)
  }

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
    function(x, y) {

      # Convert period/difftime to character to address possible file corruption
      x <- x %>%
        mutate(across(where(is.difftime), as.character),
               across(where(is.period), as.character))

      wb$add_data_table(sheet = y, x = x,
                        startRow = ifelse(add_labelled_column_headers, 2, 1),
                        tableStyle = table_style,
                        na.strings = na_strings)
    }
  )

  # Construct default metadata sheet ----
  if (include_metadata_sheet) {
    add_metadata_sheet(supertbl,
                       supertbl_meta,
                       wb,
                       add_labelled_column_headers,
                       table_style,
                       column_width,
                       na_strings)
  }

  # Apply additional aesthetics ----
  # Apply standard colwidth
  map2(
    supertbl$redcap_data,
    sheet_vals,
    function(x, y) {
      wb$set_col_widths(sheet = y,
                        cols = seq_len(ncol(x)),
                        widths = column_width)
    }
  )

  # Add labelled features ----
  if (add_labelled_column_headers) {
    add_labelled_xlsx_features(
      supertbl,
      wb,
      sheet_vals,
      include_toc_sheet,
      include_metadata_sheet,
      supertbl_toc
    )
  }

  # Export workbook object ----
  wb$set_bookview(windowHeight = 130000, windowWidth = 6000)
  wb$save(path = file, overwrite = overwrite)
}

#' @title Add labelled features to write_redcap_xlsx
#'
#' @description
#' Helper function to support `labelled` aesthetics to XLSX supertibble output
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#' @param wb An `openxlsx2` workbook object
#' @param sheet_vals Helper argument passed from `write_redcap_xlsx` to
#' determine and assign sheet values.
#' @param include_toc_sheet Include a sheet capturing the supertibble output.
#' Default `TRUE`.
#' @param include_metadata_sheet Include a sheet capturing the combined output of the
#' supertibble `redcap_metadata`. Default `TRUE`.
#' @param supertbl_toc The table of contents supertibble defined in the parent
#' function. Default `NULL`.
#'
#' @importFrom purrr map pluck
#' @importFrom tidyr pivot_wider
#' @importFrom dplyr select filter
#' @importFrom rlang check_installed
#'
#' @keywords internal

add_labelled_xlsx_features <- function(supertbl,
                                       wb,
                                       sheet_vals,
                                       include_toc_sheet = TRUE,
                                       include_metadata_sheet = TRUE,
                                       supertbl_toc = NULL) {

  check_installed("labelled", reason = "to make use of labelled features in `write_redcap_xlsx`")
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
  if (include_toc_sheet) {
    supertbl_labels <- supertbl_toc %>%
      labelled::lookfor() %>%
      select("variable", "label") %>%
      pivot_wider(names_from = "variable", values_from = "label")

    wb$add_data(sheet = "Table of Contents",
                x = supertbl_labels, colNames = FALSE)
  }

  # Add supertbl_meta labels ----
  if (include_metadata_sheet) {
    supertbl_meta_labels <- supertbl %>%
      select("redcap_metadata") %>%
      pluck(1, 1) %>%
      labelled::lookfor() %>%
      select("variable", "label") %>%
      pivot_wider(names_from = "variable", values_from = "label")

    wb$add_data(sheet = "REDCap Metadata",
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

#' @title Add the supertbl table of contents sheet
#'
#' @description
#' Internal helper function. Adds appropriate elements to wb object. Returns
#' a dataframe.
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#' @param wb An `openxlsx2` workbook object
#' @param include_metadata_sheet Include a sheet capturing the combined output of the
#' supertibble `redcap_metadata`.
#' @param add_labelled_column_headers Whether or not to include labelled outputs.
#' @param table_style Any excel table style name or "none" (see "formatting"
#' vignette in \link[openxlsx2]{wb_add_data_table}). Default "tableStyleLight8".
#' @param column_width Width to set columns across the workbook. Default
#' "auto", otherwise a numeric value. Standard Excel is 8.43.
#' @param na_strings Value used for replacing NA values from x. Default
#' `na_strings()` uses the special ⁠#N/A⁠ value within the workbook.
#'
#' @importFrom dplyr select mutate row_number across
#' @importFrom tidyselect any_of
#'
#' @returns A dataframe
#'
#' @keywords internal

add_supertbl_toc <- function(wb,
                             supertbl,
                             include_metadata_sheet,
                             add_labelled_column_headers,
                             table_style,
                             column_width,
                             na_strings) {

  # To avoid XLSX indicators of "Number stored as text", change class type
  convert_percent <- function(x) {
    class(x) <- c("numeric", "percentage")
    x
  }

  supertbl_toc <- supertbl %>%
    # Remove list elements
    select(-any_of(c("redcap_data", "redcap_metadata", "redcap_events"))) %>%
    # Necessary to avoid "Number stored as text" Excel dialogue warnings
    mutate(
      across(any_of("data_na_pct"), convert_percent),
      across(any_of("data_size"), ~prettyunits::pretty_bytes(as.numeric(.)))
    )

  # Conditionally Add metadata default to TOC
  if (include_metadata_sheet) {
    supertbl_toc[nrow(supertbl_toc) + 1, 1] <- "REDCap Metadata"
  }

  # Re-assign label
  if (add_labelled_column_headers) {
    # Re-establish lost label(s) by referencing original labels and indexing
    # Generalized for future proofing, must take place before assignment of new
    # columns and labels
    labelled::var_label(supertbl_toc) <- labelled::var_label(supertbl)[names(labelled::var_label(supertbl_toc))]
  }

  # Add custom Sheet # column and label
  supertbl_toc <- supertbl_toc %>%
    mutate(`Sheet #` = row_number())

  # Assign label for sheet #
  if (add_labelled_column_headers) {
    labelled::var_label(supertbl_toc)$`Sheet #` <- "Sheet #"
  }

  # Create wb objects
  wb$add_worksheet(sheet = "Table of Contents")
  wb$add_data_table(sheet = "Table of Contents",
                    x = supertbl_toc,
                    startRow = ifelse(add_labelled_column_headers, 2, 1),
                    tableStyle = table_style,
                    na.strings = na_strings)
  wb$set_col_widths(sheet = "Table of Contents",
                    cols = seq_along(supertbl_toc),
                    widths = column_width)

  # Return TOC object as dataframe
  supertbl_toc
}

#' @title Add the metadata sheet
#'
#' @description
#' Internal helper function. Adds appropriate elements to wb object. Returns
#' a dataframe.
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#' @param superbl_meta an `unnest`-ed metadata tibble from the supertibble
#' @param wb An `openxlsx2` workbook object
#' @param add_labelled_column_headers Whether or not to include labelled outputs.
#' @param table_style Any excel table style name or "none" (see "formatting"
#' vignette in \link[openxlsx2]{wb_add_data_table}). Default "tableStyleLight8".
#' @param column_width Width to set columns across the workbook. Default
#' "auto", otherwise a numeric value. Standard Excel is 8.43.
#' @param na_strings Value used for replacing NA values from x. Default
#' `na_strings()` uses the special ⁠#N/A⁠ value within the workbook.
#'
#' @importFrom dplyr select filter
#' @importFrom tidyr unnest
#'
#' @returns A dataframe
#'
#' @keywords internal

add_metadata_sheet <- function(supertbl,
                               supertbl_meta,
                               wb,
                               add_labelled_column_headers,
                               table_style,
                               column_width,
                               na_strings) {

  wb$add_worksheet(sheet = "REDCap Metadata")
  wb$add_data_table(sheet = "REDCap Metadata",
                    x = supertbl_meta,
                    startRow = ifelse(add_labelled_column_headers, 2, 1),
                    tableStyle = table_style,
                    na.strings = na_strings)
  wb$set_col_widths(sheet = "REDCap Metadata",
                    cols = seq_along(supertbl_meta),
                    widths = column_width)
}

#' @title Check if labelled
#'
#' @description
#' Checks if a supplied supertibble is labelled and throws an error if it is not
#' but `labelled` is set to `TRUE`
#'
#' @param supertbl a supertibble generated using `read_redcap()`
#' @param add_labelled_column_headers Whether or not to include labelled outputs
#' @param call the calling environment to use in the warning message
#'
#' @importFrom cli cli_abort
#' @importFrom rlang caller_env is_installed
#' @importFrom purrr some
#'
#' @returns A boolean
#'
#' @keywords internal

check_labelled <- function(supertbl, add_labelled_column_headers, call = caller_env()) {
  # supertbl is considered labelled if cols have label attributes
  is_labelled <- some(supertbl, function(x) !is.null(attr(x, "label")))

  # If user declared labelled is FALSE return FALSE
  if (!is.null(add_labelled_column_headers) && !add_labelled_column_headers) {
    return(FALSE)
  }

  # If user not declared and no labels detected, return FALSE
  if (is.null(add_labelled_column_headers) && !is_labelled) {
    return(FALSE)
  }

  # If labels are detected & labelled is installed, return TRUE
  if (is_labelled && is_installed("labelled")) {
    return(TRUE)
  }

  # If labels detected and labelled is not installed, return warning message and FALSE
  if (is_labelled && !is_installed("labelled")) {
    cli_warn(
      message = c(
        "!" = "Labels detected, but {.pkg labelled} not installed. Labels not applied.",
        "i" = "Consider installing {.pkg labelled} and re-running."
      ),
      class = c("labelled_not_installed", "REDCapTidieR_cond"),
      call = call
    )
    return(FALSE)
  }

  # Otherwise error, meaning labels asked for on a non-labelled input
  cli_abort(
    message = c(
      "x" = "{.arg labelled} declared TRUE, but no variable labels detected.",
      "i" = "Did you run {.fun make_labelled()} on the supertibble?"
    ),
    class = c("missing_labelled_labels", "REDCapTidieR_cond"),
    call = call
  )
}


#' @title Recode fields using supertbl metadata
#'
#' @description
#' This utility function helps to map metadata field types in order to apply
#' changes in supertbl tables.
#'
#' @param supertbl A supertibble generated using `read_redcap()`
#' @param superbl_meta an `unnest`-ed metadata tibble from the supertibble
#'
#' @importFrom dplyr mutate across case_when filter pull
#' @importFrom purrr map
#' @importFrom tidyselect any_of
#'
#' @keywords internal
supertbl_recode <- function(supertbl, supertbl_meta) {
  # Recode yesno from TRUE/FALSE to "yes"/"no"

  yesno_fields <- supertbl_meta %>%
    filter(.data$field_type == "yesno") %>%
    pull(.data$field_name)

  checkbox_fields <- supertbl_meta %>%
    filter(.data$field_type == "checkbox") %>%
    pull(.data$field_name)

  map(
    supertbl$redcap_data,
    function(x) {
      x %>%
        mutate(
          across(any_of(yesno_fields), ~ case_when(
            . == "TRUE" ~ "yes",
            . == "FALSE" ~ "no",
            TRUE ~ NA_character_
          )),
          across(any_of(checkbox_fields), ~ case_when(
            . == "TRUE" ~ "Checked",
            . == "FALSE" ~ "Unchecked",
            TRUE ~ NA_character_
          ))
        )
    }
  )
}

#' @title Bind supertbl metadata
#'
#' @description
#' Simple helper function for binding supertbl metadata into one table. This
#' supports creating the metadata XLSX sheet as well as `supertbl_recode`.
#'
#' @param supertbl A supertibble generated using `read_redcap()`
#'
#' @importFrom dplyr filter select
#' @importFrom tidyr unnest
#'
#' @keywords internal

bind_supertbl_metadata <- function(supertbl) {
  supertbl %>%
    select("redcap_metadata") %>% #nolint: object_usage_linter
    unnest(cols = "redcap_metadata") %>% # record ID gets duplicated.
    # Since no other fields are allowed to be duplicated in REDCap,
    # can use filtering here for removal of duplicated record ID fields
    filter(!duplicated(.data$field_name))
}
