# Recode fields using supertbl metadata

This utility function helps to map metadata field types in order to
apply changes in supertbl tables.

## Usage

``` r
supertbl_recode(supertbl, supertbl_meta, add_labelled_column_headers)
```

## Arguments

- supertbl:

  A supertibble generated using
  [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)

- supertbl_meta:

  an `unnest`-ed metadata tibble from the supertibble

- add_labelled_column_headers:

  Whether or not to include labelled outputs
