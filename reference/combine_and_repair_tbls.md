# Combine checkbox fields with respect to repaired outputs

This function seeks to preserve the original data columns and types from
the originally supplied data_tbl and add on the new columns from
data_tbl_mod.

If `names_repair` presents a repair strategy, the output columns will be
captured and updated here while dropping the original columns.

## Usage

``` r
combine_and_repair_tbls(data_tbl, data_tbl_mod, new_cols, names_repair)
```

## Arguments

- data_tbl:

  The original data table given to
  [`combine_checkboxes()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/combine_checkboxes.md)

- data_tbl_mod:

  A modified data table from `data_tbl`

- new_cols:

  The new columns created for checkbox combination

- names_repair:

  What happens if the output has invalid column names? The default,
  "check_unique" is to error if the columns are duplicated. Use
  "minimal" to allow duplicates in the output, or "unique" to
  de-duplicated by adding numeric suffixes. See
  [`vctrs::vec_as_names()`](https://vctrs.r-lib.org/reference/vec_as_names.html)
  for more options.

## Value

a tibble
