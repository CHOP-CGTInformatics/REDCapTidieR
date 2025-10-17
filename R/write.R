#' @title Write Supertibbles to XLSX
#'
#' @description
#' Transform a supertibble into an XLSX file, with each REDCap data tibble in a separate sheet.
#'
#' @param supertbl A supertibble generated using [read_redcap()].
#' @param file The name of the file to which the output will be written.
#' @param add_labelled_column_headers If `TRUE`, the first row of each sheet will contain variable labels,
#' with variable names in the second row. If `FALSE`, variable names will be in the first row.
#' The default value, `NULL`, tries to determine if `supertbl` contains variable labels and,
#' if present, includes them in the first row. The `labelled` package must be installed
#' if `add_labelled_column_headers` is `TRUE`.
#' @param use_labels_for_sheet_names If `FALSE`, sheet names will come from the REDCap instrument names.
#' If `TRUE`, sheet names will come from instrument labels. The default is `TRUE`.
#' @param include_toc_sheet If `TRUE`, the first sheet in the XLSX output will be a table of contents,
#' providing information about each data tibble in the workbook. The default is `TRUE`.
#' @param include_metadata_sheet If `TRUE`, the final sheet in the XLSX output will contain metadata
#' about each variable, combining the content of `supertbl$redcap_metadata`. The default is `TRUE`.
#' @param table_style Any Excel table style name or "none". For more details, see
#' the
#' ["formatting" vignette](https://ycphs.github.io/openxlsx/articles/Formatting.html#use-of-pre-defined-table-styles)
#' of the `openxlsx` package. The default is "tableStyleLight8".
#' @param column_width Sets the width of columns throughout the workbook.
#' The default is "auto", but you can specify a numeric value.
#' @param recode_logical If `TRUE`, fields with "yesno" field type are recoded to "yes"/"no" and fields
#' with a "checkbox" field type are recoded to "Checked"/"Unchecked". The default is `TRUE`.
#' @param na_replace The value used to replace `NA` values in `supertbl`. The default is "".
#' @param overwrite If `FALSE`, will not overwrite `file` when it exists. The default is `FALSE`.
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
#' # Add variable labels
#'
#' library(labelled)
#'
#' supertbl %>%
#'   make_labelled() %>%
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
                              na_replace = "",
                              overwrite = FALSE) {
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
  check_file_exists(file, overwrite)

  # Check installation of labelled and apply labelled operations
  add_labelled_column_headers <- check_labelled(supertbl, add_labelled_column_headers)

  # If no file extension supplied, append with .xlsx
  if (sub(".*\\.", "", file) == file) {
    file <- paste0(file, ".xlsx")
  }

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

  sheet_vals <- excel_trunc_unique(sheet_vals, width = 31)

  # Construct default supertibble sheet ----
  if (include_toc_sheet) {
    supertbl_toc <- add_supertbl_toc(
      wb,
      supertbl,
      include_metadata_sheet,
      add_labelled_column_headers,
      table_style,
      column_width,
      na_replace
    )
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
    supertbl$redcap_data <- supertbl_recode(supertbl, supertbl_meta, add_labelled_column_headers)
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
        mutate(
          across(where(is.difftime), as.character),
          across(where(is.period), as.character)
        )

      wb$add_data_table(
        sheet = y, x = x,
        start_row = ifelse(add_labelled_column_headers, 2, 1),
        table_style = table_style,
        na.strings = na_replace
      )
    }
  )

  # Construct default metadata sheet ----
  if (include_metadata_sheet) {
    add_metadata_sheet(
      supertbl,
      supertbl_meta,
      wb,
      add_labelled_column_headers,
      table_style,
      column_width,
      na_replace
    )
  }

  # Apply additional aesthetics ----
  # Apply standard colwidth
  map2(
    supertbl$redcap_data,
    sheet_vals,
    function(x, y) {
      wb$set_col_widths(
        sheet = y,
        cols = seq_len(ncol(x)),
        widths = column_width
      )
    }
  )

  if (add_labelled_column_headers) {
    add_labelled_xlsx_features(
      supertbl,
      supertbl_meta,
      wb,
      sheet_vals,
      include_toc_sheet,
      include_metadata_sheet,
      supertbl_toc
    )
  }

  # Export workbook object ----
  wb$set_bookview(window_height = 130000, window_width = 6000)
  wb$save(file = file, overwrite = overwrite)
}

#' @title Add labelled features to write_redcap_xlsx
#'
#' @description
#' Helper function to support `labelled` aesthetics to XLSX supertibble output
#'
#' @param supertbl a supertibble generated using [read_redcap()]
#' @param supertbl_meta supertibble metadata generated by [bind_supertbl_metadata()]
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
#' @keywords internal

add_labelled_xlsx_features <- function(supertbl,
                                       supertbl_meta,
                                       wb,
                                       sheet_vals,
                                       include_toc_sheet = TRUE,
                                       include_metadata_sheet = TRUE,
                                       supertbl_toc = NULL) {
  check_installed("labelled", reason = "to make use of labelled features in `write_redcap_xlsx`")
  # Generate variable labels off of labelled dictionary objects ----
  generate_dictionaries <- function(x) { # nolint: object_usage_linter
    labelled::generate_dictionary(x) %>%
      select("variable", "label") %>%
      mutate(label = if_else(is.na(.data$label), "", .data$label)) %>%
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

    wb$add_data(
      sheet = "Table of Contents",
      x = supertbl_labels, col_names = FALSE
    )
  }

  # Add supertbl_meta labels ----
  if (include_metadata_sheet) {
    # Define skimr labels ----
    skimr_labs <- make_skimr_labels()

    # Define standard metadata labs ----
    supertbl_meta_labs <- supertbl %>%
      select("redcap_metadata") %>%
      pluck(1, 1) %>%
      select(!any_of(names(skimr_labs))) %>%
      labelled::lookfor()

    supertbl_meta_labs <- c(supertbl_meta_labs$label)

    # Combine Labels ----
    metadata_labs <- c(skimr_labs, supertbl_meta_labs)

    # Apply labels ----

    supertbl_meta_labs <- safe_set_variable_labels(supertbl_meta, metadata_labs) %>%
      labelled::lookfor() %>%
      select("variable", "label") %>%
      pivot_wider(names_from = "variable", values_from = "label")

    wb$add_data(
      sheet = "REDCap Metadata",
      x = supertbl_meta_labs, col_names = FALSE
    )
  }

  # Define redcap_data variable labels
  var_labels <- map(.x = supertbl$redcap_data, ~ generate_dictionaries(.x))

  for (i in seq_along(supertbl$redcap_form_name)) {
    wb$add_data(
      sheet = sheet_vals[i],
      x = var_labels[[i]], col_names = FALSE
    )
  }

  for (i in seq_len(nrow(wb$tables))) {
    dims <- gsub("[0-9]+", "1", wb$tables$tab_ref[i])

    wb$add_cell_style(
      sheet = i,
      dims = dims,
      wrap_text = "1"
    )
    wb$add_font(
      sheet = i,
      dims = dims,
      color = openxlsx2::wb_color(hex = "7F7F7F"),
      italic = "1"
    )
  }
}

#' @title Add the supertbl table of contents sheet
#'
#' @description
#' Internal helper function. Adds appropriate elements to `wb` object. Returns
#' a dataframe.
#'
#' @param supertbl a supertibble generated using [read_redcap()]
#' @param wb An `openxlsx2` workbook object
#' @param include_metadata_sheet Include a sheet capturing the combined output of the
#' supertibble `redcap_metadata`.
#' @param add_labelled_column_headers Whether or not to include labelled outputs.
#' @param table_style Any excel table style name or "none" (see "formatting"
#' in [openxlsx2::wb_add_data_table()]). Default "tableStyleLight8".
#' @param column_width Width to set columns across the workbook. Default
#' "auto", otherwise a numeric value. Standard Excel is 8.43.
#' @param na_replace The value used to replace `NA` values in `supertbl`. The default is "".
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
                             na_replace) {
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
      across(any_of(c("data_na_pct", "form_complete_pct")), convert_percent),
      across(any_of("data_size"), ~ prettyunits::pretty_bytes(as.numeric(.)))
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
  wb$add_data_table(
    sheet = "Table of Contents",
    x = supertbl_toc,
    start_row = ifelse(add_labelled_column_headers, 2, 1),
    table_style = table_style,
    na.strings = na_replace
  )
  wb$set_col_widths(
    sheet = "Table of Contents",
    cols = seq_along(supertbl_toc),
    widths = column_width
  )

  # Return TOC object as dataframe
  supertbl_toc
}

#' @title Add the metadata sheet
#'
#' @description
#' Internal helper function. Adds appropriate elements to `wb` object. Returns
#' a dataframe.
#'
#' @param supertbl a supertibble generated using [read_redcap()]
#' @param supertbl_meta an `unnest`-ed metadata tibble from the supertibble
#' @param wb An `openxlsx2` workbook object
#' @param add_labelled_column_headers Whether or not to include labelled outputs.
#' @param table_style Any excel table style name or "none" (see "formatting"
#' in [openxlsx2::wb_add_data_table()]). Default "tableStyleLight8".
#' @param column_width Width to set columns across the workbook. Default
#' "auto", otherwise a numeric value. Standard Excel is 8.43.
#' @param na_replace The value used to replace `NA` values in `supertbl`. The default is "".
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
                               na_replace) {
  wb$add_worksheet(sheet = "REDCap Metadata")
  wb$add_data_table(
    sheet = "REDCap Metadata",
    x = supertbl_meta,
    start_row = ifelse(add_labelled_column_headers, 2, 1),
    table_style = table_style,
    na.strings = na_replace
  )
  wb$set_col_widths(
    sheet = "REDCap Metadata",
    cols = seq_along(supertbl_meta),
    widths = column_width
  )
}

#' @title Check if labelled
#'
#' @description
#' Checks if a supplied supertibble is labelled and throws an error if it is not
#' but `labelled` is set to `TRUE`
#'
#' @param supertbl a supertibble generated using [read_redcap()]
#' @param add_labelled_column_headers Whether or not to include labelled outputs
#' @param call the calling environment to use in the warning message
#'
#' @returns A boolean
#'
#' @keywords internal

check_labelled <- function(supertbl, add_labelled_column_headers, call = caller_env()) {
  # supertbl is considered labelled if cols have label attributes
  is_labelled <- is_labelled(supertbl)

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
      "x" = "{.arg add_labelled_column_headers} declared TRUE, but no variable labels detected.",
      "i" = "Did you run {.fun make_labelled} on the supertibble?"
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
#' @param supertbl A supertibble generated using [read_redcap()]
#' @param supertbl_meta an `unnest`-ed metadata tibble from the supertibble
#' @param add_labelled_column_headers Whether or not to include labelled outputs
#'
#' @keywords internal
supertbl_recode <- function(supertbl, supertbl_meta, add_labelled_column_headers) {
  # Recode yesno from TRUE/FALSE to "yes"/"no"

  yesno_fields <- supertbl_meta %>% # nolint: object_usage_linter
    filter(.data$field_type == "yesno") %>%
    pull(.data$field_name)

  checkbox_fields <- supertbl_meta %>% # nolint: object_usage_linter
    filter(.data$field_type == "checkbox") %>%
    pull(.data$field_name)

  # Recode logical vars, define and re-apply labels (similar to labelled.R)
  # as these are lost during attribute changes
  map(
    supertbl$redcap_data,
    function(x) {
      if (add_labelled_column_headers) {
        labs <- labelled::lookfor(x)$label
      }

      out <- x %>%
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

      # set labs
      if (add_labelled_column_headers) {
        safe_set_variable_labels(out, labs)
      } else {
        out
      }
    }
  )
}

#' @title Bind supertbl metadata
#'
#' @description
#' Simple helper function for binding supertbl metadata into one table. This
#' supports creating the metadata XLSX sheet as well as `supertbl_recode`.
#'
#' @param supertbl A supertibble generated using [read_redcap()]
#'
#' @keywords internal

bind_supertbl_metadata <- function(supertbl) {
  out <- supertbl %>%
    select("redcap_form_name", "redcap_form_label", "redcap_metadata") %>% # nolint: object_usage_linter
    unnest(cols = c("redcap_form_name", "redcap_form_label", "redcap_metadata"))

  # Detect Record ID field by looking for duplicated field_names
  # Since no other fields in REDCap are allowed to be duplicated, we should only
  # ever expect to receive the record ID field (whatever it's named)
  if (any(duplicated(out$field_name))) {
    record_id <- out %>% # nolint: object_usage_linter
      filter(duplicated(.data$field_name)) %>%
      pull(.data$field_name) %>%
      unique()
  } else {
    # Edge case when there is only one instrument
    record_id <- out$field_name[1]
  }


  out %>%
    mutate(
      # Remove duplicated rows left over by record ID
      redcap_form_name = case_when(
        field_name == record_id ~ NA,
        TRUE ~ redcap_form_name
      ),
      redcap_form_label = case_when(
        field_name == record_id ~ NA,
        TRUE ~ redcap_form_label
      ),
      # Convert period/difftime to character to address possible file corruption
      across(where(is.difftime), as.character),
      across(where(is.period), as.character)
    ) %>%
    unique()
}

#' @title
#' Make Excel-safe unique sheet names with truncation and numbering
#'
#' @description
#' Produces sheet names that:
#'
#' - respect Excel's 31-character limit
#' - are unique, even when the first 31 characters are identical
#'
#' The first occurrence of each name is truncated with an ellipsis via
#' [stringr::str_trunc()] (so it ends with `"..."` if needed). Any collisions
#' (including with pre-existing user-provided names) are resolved by appending
#' a numeric suffix like `".(2)"`, `".(3)"`, … while re-truncating the base so
#' the total length never exceeds `width`. If the base already ends with a dot,
#' the extra dot in the suffix is omitted to avoid `"..(n)"`.
#'
#' @param x A character vector of proposed sheet names.
#' @param width Integer scalar, maximum allowed length (default `31` for Excel).
#'
#' @return A character vector the same length as `x`, with unique names of length
#'   `<= width`.
#'
#' @keywords internal

excel_trunc_unique <- function(x, width = 31) {
  stopifnot(width > 4) # Minimum required width for adding on suffixes

  # Check if vals greater than `width` and alert user to changes
  too_long <- !is.na(x) & nchar(x, type = "chars") > width
  if (any(too_long)) {
    examples <- utils::head(unique(x[too_long]), 5) # nolint: object_usage_linter
    cli_warn(
      c(
        "!" = "{sum(too_long)} sheet name{?s} exceeded the {.val {width}} max character limit and will be truncated.",
        "i" = "Examples: {paste0('\"', examples, '\"', collapse = ', ')}."
      )
    )
  }

  # First pass truncation (keeps "..." for long ones)
  tr <- str_trunc(x, width = width) # nolint: object_usage_linter

  # Preserve location of names in case truncated names already exist
  freq <- table(x, useNA = "ifany")
  is_singleton <- (freq[x] == 1L) # per-element lookup
  in_bounds     <- !is.na(x) & nchar(x, "chars") <= width
  locked_idx    <- which(in_bounds & is_singleton) # positions to keep verbatim
  locked_names  <- unique(x[locked_idx])

  used <- locked_names # pre-seed used with reserved names # nolint: object_usage_linter
  counts <- new.env(parent = emptyenv()) # per truncated-key counters # nolint: object_usage_linter

  map_chr(seq_along(x), ~{
    i    <- .x
    orig <- x[i]
    key  <- tr[i]

    # If this position is locked, keep the user-provided name in-place
    if (i %in% locked_idx) {
      # also initialize a counter for its truncated key if helpful later
      if (!exists(key, envir = counts, inherits = FALSE)) assign(key, 1L, envir = counts)
      return(orig)
    }

    # If the truncated name isn't taken (and not blocked by locked names), use it
    if (!(key %in% used)) {
      used <<- c(used, key)
      if (!exists(key, envir = counts, inherits = FALSE)) assign(key, 1L, envir = counts)
      return(key)
    }

    # Otherwise, add .(n) while re-truncating from the ORIGINAL string
    n <- if (exists(key, envir = counts, inherits = FALSE)) get(key, envir = counts) + 1L else 2L

    repeat {
      suffix <- paste0(".(", n, ")")
      allow  <- width - nchar(suffix)

      base <- str_trim(str_trunc(orig, width = allow, ellipsis = ""), side = "right")
      suf  <- if (str_ends(base, "\\.")) paste0("(", n, ")") else suffix
      cand <- paste0(base, suf)

      if (!(cand %in% used)) {
        used <<- c(used, cand)
        assign(key, n, envir = counts)
        return(cand)
      }
      n <- n + 1L
    }
  })
}
