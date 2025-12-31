# Add identification for repeat event types

To correctly assign repeat event types a few assumptions must be made:

- There are only 3 behaviors: nonrepeating, repeat_separately, and
  repeat_together

- If an event only shows `redcap_repeat_instance` and
  `redcap_repeat_instrument` as `NA`, it can be considered a nonrepeat
  event.

- If an event is always `NA` for `redcap_repeat_instrument` and filled
  for `redcap_repeat_instance` it can be assumed to be a repeat_together
  event

- repeat_separate and nonrepeating event types exhibit the same behavior
  along the primary keys of the data. nonrepeating event types can have
  data display with `redcap_repeat_instance`values both filled and as
  `NA`. If this is the case, it can be assumed the event is a repeating
  separate event.

## Usage

``` r
get_repeat_event_types(data)
```

## Arguments

- data:

  the REDCap data

## Value

A dataframe with unique event names mapped to their corresponding repeat
types
