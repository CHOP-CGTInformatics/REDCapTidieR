# Supplement a supertibble from a longitudinal database with information about the events associated with each instrument

Supplement a supertibble from a longitudinal database with information
about the events associated with each instrument

## Usage

``` r
add_event_mapping(supertbl, linked_arms)
```

## Arguments

- supertbl:

  a supertibble object to supplement with metadata

- linked_arms:

  the tibble with event mappings created by
  [`link_arms()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/link_arms.md)

## Value

The original supertibble with an events `redcap_events` list column
containing arms and events associated with each instrument
