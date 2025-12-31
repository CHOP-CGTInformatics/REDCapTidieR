# Remove rows with empty data

Remove rows that are empty in all associated data columns (those derived
from fields in REDCap). This occurs when a form is filled out in an
event, but other forms are not. Regardless of a form's status, all forms
in an event are included in the output so long as any form in the event
contains data.

This only applies to longitudinal REDCap databases containing events.

## Usage

``` r
remove_empty_rows(data, my_record_id)
```

## Arguments

- data:

  A REDCap dataframe from a longitudinal database, pre-processed within
  a `distill_*` function.

- my_record_id:

  The record ID defined in the project.

## Value

A dataframe.
