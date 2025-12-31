# Add the metadata sheet

Internal helper function. Adds appropriate elements to `wb` object.
Returns a dataframe.

## Usage

``` r
add_metadata_sheet(
  supertbl,
  supertbl_meta,
  wb,
  add_labelled_column_headers,
  table_style,
  column_width,
  na_replace
)
```

## Arguments

- supertbl:

  a supertibble generated using
  [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)

- supertbl_meta:

  an `unnest`-ed metadata tibble from the supertibble

- wb:

  An `openxlsx2` workbook object

- add_labelled_column_headers:

  Whether or not to include labelled outputs.

- table_style:

  Any excel table style name or "none" (see "formatting" in
  [`openxlsx2::wb_add_data_table()`](https://janmarvin.github.io/openxlsx2/reference/wb_add_data_table.html)).
  Default "tableStyleLight8".

- column_width:

  Width to set columns across the workbook. Default "auto", otherwise a
  numeric value. Standard Excel is 8.43.

- na_replace:

  The value used to replace `NA` values in `supertbl`. The default is
  "".

## Value

A dataframe
