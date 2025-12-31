# Extract non-repeat tables from longitudinal REDCap databases

Sub-helper function to `clean_redcap_long` for single nonrepeat table
extraction.

## Usage

``` r
distill_nonrepeat_table_long(
  form_name,
  db_data_long,
  db_metadata_long,
  linked_arms
)
```

## Arguments

- form_name:

  The `form_name` described in the named column from the REDCap
  metadata.

- db_data_long:

  The REDCap database output defined by
  `REDCapR::redcap_read_oneshot()$data`

- db_metadata_long:

  The REDCap metadata output defined by
  `REDCapR::redcap_metadata_read()$data`

- linked_arms:

  Output of `link_arms`, linking instruments to REDCap events/arms

## Value

A `tibble` of all data related to a specified `form_name`
