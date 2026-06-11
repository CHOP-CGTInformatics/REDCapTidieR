# Determine instrument structure for a classic REDCap project

Determine instrument structure for a classic REDCap project

## Usage

``` r
structure_from_repeating(forms, db_instrument_repeating)
```

## Arguments

- forms:

  a character vector of form names.

- db_instrument_repeating:

  a tibble of repeating instrument settings created by
  [`pull_instrument_repeating()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/pull_instrument_repeating.md).

## Value

Tibble with `redcap_form_name` and `structure`
