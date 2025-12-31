# Convert a new checkbox column's values

This function takes a single column of data and converts the values
based on the overall data tibble cross referenced with a nested section
of the metadata tibble.

`case_when` logic helps determine whether the value is a coalesced
singular value or a user-specified one via `multi_value_label` or
`values_fill`. If `multi_value_label` is `NULL`, multiple checkbox
selections are pasted together using `multi_value_sep` specification.

## Usage

``` r
convert_checkbox_vals(
  metadata,
  .new_value,
  data_tbl,
  raw_or_label,
  multi_value_label,
  values_fill,
  multi_value_sep
)
```

## Arguments

- metadata:

  A nested portion of the overall metadata tibble

- .new_value:

  The new column values made by
  [`combine_checkboxes()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/combine_checkboxes.md)

- data_tbl:

  The data tibble from the original supertibble

- raw_or_label:

  Either 'raw' or 'label' to specify whether to use raw coded values or
  labels for the options. Default 'label'.

- multi_value_label:

  A string specifying the value to be used when multiple checkbox fields
  are selected. Default "Multiple". If `NULL`, multiple selections will
  be pasted together using `multi_value_sep` specification.

- values_fill:

  Value to use when no checkboxes are selected. Default `NA`.

- multi_value_sep:

  A string specifying the separator to use to paste multiple selections
  together when `multi_value_label` is `NULL`. Default `", "`.

## Details

This function is used in conjunction with `pmap()`.
