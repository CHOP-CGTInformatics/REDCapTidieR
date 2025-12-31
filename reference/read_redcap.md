# Import a REDCap database into a tidy supertibble

Query the REDCap API to retrieve data and metadata about a project, and
transform the output into a "supertibble" that contains data and
metadata organized into tibbles, broken down by instrument.

## Usage

``` r
read_redcap(
  redcap_uri,
  token,
  raw_or_label = "label",
  forms = NULL,
  export_survey_fields = NULL,
  export_data_access_groups = NULL,
  suppress_redcapr_messages = TRUE,
  col_types = NULL,
  guess_max = Inf,
  allow_mixed_structure = getOption("redcaptidier.allow.mixed.structure", FALSE)
)
```

## Arguments

- redcap_uri:

  The URI/URL of the REDCap server (e.g.,
  "https://server.org/apps/redcap/api/"). Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- raw_or_label:

  A string (either 'raw', 'label', or 'haven') that specifies whether to
  export the raw coded values or the labels for the options of
  categorical fields. Default is 'label'. If 'haven' is supplied,
  categorical fields are converted to `haven_labelled` vectors.

- forms:

  A character vector of REDCap instrument names that specifies which
  instruments to import. Default is `NULL` which imports all instruments
  in the project.

- export_survey_fields:

  A logical that specifies whether to export survey identifier and
  timestamp fields. The default, `NULL`, tries to determine if survey
  fields exist and returns them if available.

- export_data_access_groups:

  A logical that specifies whether to export the data access group
  field. The default, `NULL`, tries to determine if a data access group
  field exists and returns it if available.

- suppress_redcapr_messages:

  A logical to control whether to suppress messages from REDCapR API
  calls. Default `TRUE`.

- col_types:

  A [`readr::cols()`](https://readr.tidyverse.org/reference/cols.html)
  object passed internally to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).
  Optional. See "Using `col_types`" for more information.

- guess_max:

  A positive [base::numeric](https://rdrr.io/r/base/numeric.html) value
  passed to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  that specifies the maximum number of records to use for guessing
  column types. Default `Inf`.

- allow_mixed_structure:

  A logical to allow for support of mixed repeating/non-repeating
  instruments. Setting to `TRUE` will treat the mixed instrument's
  non-repeating versions as repeating instruments with a single
  instance. Applies to longitudinal projects only. Default `FALSE`. Can
  be set globally with
  `options(redcaptidier.allow.mixed.structure = TRUE)`.

## Value

A `tibble` in which each row represents a REDCap instrument. It contains
the following columns:

- `redcap_form_name`, the name of the instrument

- `redcap_form_label`, the label for the instrument

- `redcap_data`, a tibble with the data for the instrument

- `redcap_metadata`, a tibble of data dictionary entries for each field
  in the instrument

- `redcap_events`, a tibble with information about the arms and
  longitudinal events represented in the instrument. Only if the project
  has longitudinal events enabled

- `structure`, the instrument structure, either "repeating" or
  "nonrepeating"

- `data_rows`, the number of rows in the instrument's data tibble

- `data_cols`, the number of columns in the instrument's data tibble

- `data_size`, the size in memory of the instrument's data tibble
  computed by
  [`lobstr::obj_size()`](https://lobstr.r-lib.org/reference/obj_size.html)

- `data_na_pct`, the percentage of cells in the instrument's data
  columns that are `NA` excluding identifier and form completion columns

## Details

### The block matrix

This function uses the
[REDCapR](https://ouhscbbmc.github.io/REDCapR/index.html) package to
query the REDCap API. The REDCap API returns a [block
matrix](https://en.wikipedia.org/wiki/Block_matrix) that mashes data
from all data collection instruments together. The `read_redcap()`
function deconstructs the block matrix and splices the data into
individual tibbles, where one tibble represents the data from one
instrument.

### Using `col_types`

REDCapR and REDCapTidieR use
[readr::read_csv](https://readr.tidyverse.org/reference/read_delim.html)
to to intelligently guess the data types of the block matrix. While
REDCapTidieR makes some minor assumptions and manipulations to the final
outputs, in some scenarios fringe issues may result in incorrectly
assumed data types.

To help with correcting these behaviors, `col_types` wraps
[readr::cols](https://readr.tidyverse.org/reference/cols.html) lets
users specify the expected data type. This is an advanced feature for
users with an understanding of the REDCap API and block matrix.

## Examples

``` r
if (FALSE) { # \dontrun{
redcap_uri <- Sys.getenv("REDCAP_URI")
token <- Sys.getenv("REDCAP_TOKEN")

read_redcap(
  redcap_uri,
  token,
  raw_or_label = "label"
)
} # }
```
