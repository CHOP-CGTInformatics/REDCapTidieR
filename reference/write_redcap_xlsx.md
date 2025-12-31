# Write Supertibbles to XLSX

Transform a supertibble into an XLSX file, with each REDCap data tibble
in a separate sheet.

## Usage

``` r
write_redcap_xlsx(
  supertbl,
  file,
  add_labelled_column_headers = NULL,
  use_labels_for_sheet_names = TRUE,
  include_toc_sheet = TRUE,
  include_metadata_sheet = TRUE,
  table_style = "tableStyleLight8",
  column_width = "auto",
  recode_logical = TRUE,
  na_replace = "",
  overwrite = FALSE
)
```

## Arguments

- supertbl:

  A supertibble generated using
  [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md).

- file:

  The name of the file to which the output will be written.

- add_labelled_column_headers:

  If `TRUE`, the first row of each sheet will contain variable labels,
  with variable names in the second row. If `FALSE`, variable names will
  be in the first row. The default value, `NULL`, tries to determine if
  `supertbl` contains variable labels and, if present, includes them in
  the first row. The `labelled` package must be installed if
  `add_labelled_column_headers` is `TRUE`.

- use_labels_for_sheet_names:

  If `FALSE`, sheet names will come from the REDCap instrument names. If
  `TRUE`, sheet names will come from instrument labels. The default is
  `TRUE`.

- include_toc_sheet:

  If `TRUE`, the first sheet in the XLSX output will be a table of
  contents, providing information about each data tibble in the
  workbook. The default is `TRUE`.

- include_metadata_sheet:

  If `TRUE`, the final sheet in the XLSX output will contain metadata
  about each variable, combining the content of
  `supertbl$redcap_metadata`. The default is `TRUE`.

- table_style:

  Any Excel table style name or "none". For more details, see the
  ["formatting"
  vignette](https://ycphs.github.io/openxlsx/articles/Formatting.html#use-of-pre-defined-table-styles)
  of the `openxlsx` package. The default is "tableStyleLight8".

- column_width:

  Sets the width of columns throughout the workbook. The default is
  "auto", but you can specify a numeric value.

- recode_logical:

  If `TRUE`, fields with "yesno" field type are recoded to "yes"/"no"
  and fields with a "checkbox" field type are recoded to
  "Checked"/"Unchecked". The default is `TRUE`.

- na_replace:

  The value used to replace `NA` values in `supertbl`. The default is
  "".

- overwrite:

  If `FALSE`, will not overwrite `file` when it exists. The default is
  `FALSE`.

## Value

An `openxlsx2` workbook object, invisibly

## Examples

``` r
if (FALSE) { # \dontrun{
redcap_uri <- Sys.getenv("REDCAP_URI")
token <- Sys.getenv("REDCAP_TOKEN")

supertbl <- read_redcap(redcap_uri, token)

supertbl %>%
  write_redcap_xlsx(file = "supertibble.xlsx")

# Add variable labels

library(labelled)

supertbl %>%
  make_labelled() %>%
  write_redcap_xlsx(file = "supertibble.xlsx", add_labelled_column_headers = TRUE)
} # }
```
