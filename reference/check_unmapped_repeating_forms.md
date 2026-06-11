# Check for repeating forms not mapped to events

Check for repeating forms not mapped to events

## Usage

``` r
check_unmapped_repeating_forms(
  db_event_instruments,
  db_instrument_repeating,
  call = caller_env()
)
```

## Arguments

- db_event_instruments:

  a tibble of event-instrument mappings created by
  [`pull_event_instruments()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/pull_event_instruments.md).

- db_instrument_repeating:

  a tibble of repeating instrument settings created by
  [`pull_instrument_repeating()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/pull_instrument_repeating.md).

- call:

  The calling environment to use in the error message
