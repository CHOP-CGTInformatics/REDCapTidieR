# Add event-form level repeating structure to event mappings

Add event-form level repeating structure to event mappings

## Usage

``` r
add_form_event_structure(data, db_instrument_repeating)
```

## Arguments

- data:

  a tibble containing event-instrument mappings.

- db_instrument_repeating:

  a tibble of repeating instrument settings created by
  [`pull_instrument_repeating()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/pull_instrument_repeating.md).

## Value

The original event-instrument mapping tibble supplemented with
`custom_form_label` and `repeat_structure` columns.

## Details

This function merges repeating instrument information from REDCap with
event-instrument mappings. Repeating together vs. separate is inferred
from whether `form` is populated.
