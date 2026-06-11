# Determine form-level structure for a longitudinal REDCap project

Determine form-level structure for a longitudinal REDCap project

## Usage

``` r
structure_from_events_and_repeating(
  forms,
  db_instrument_repeating,
  db_event_instruments
)
```

## Arguments

- forms:

  a character vector of form names.

- db_instrument_repeating:

  a tibble of repeating instrument settings created by
  [`pull_instrument_repeating()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/pull_instrument_repeating.md).

- db_event_instruments:

  a tibble of event-instrument mappings created by
  [`pull_event_instruments()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/pull_event_instruments.md).

## Value

Tibble with `redcap_form_name` and `structure`

## Details

`structure` is one of 'repeating', 'nonrepeating', or 'mixed' based on
form-event-level structure. In cases where a form in `forms` is not
`db_event_instruments` it will be reported as 'nonrepeating'.
