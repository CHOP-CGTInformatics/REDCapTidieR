# Supplement a supertibble from a longitudinal database with information about the events associated with each instrument

Supplement a supertibble from a longitudinal database with information
about the events associated with each instrument

## Usage

``` r
add_event_mapping(supertbl, linked_arms, repeat_event_types)
```

## Arguments

- supertbl:

  a supertibble object to supplement with metadata

- linked_arms:

  the tibble with event mappings created by
  [`link_arms()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/link_arms.md)

- repeat_event_types:

  a dataframe output from
  [`get_repeat_event_types()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/get_repeat_event_types.md)
  which specifies NR, RS, and RT types for events

## Value

The original supertibble with an events `redcap_events` list column
containing arms and events associated with each instrument
