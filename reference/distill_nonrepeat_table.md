# Extract non-repeat tables from non-longitudinal REDCap databases

Sub-helper function to `clean_redcap` for single nonrepeat table
extraction.

## Usage

``` r
distill_nonrepeat_table(form_name, db_data, db_metadata)
```

## Arguments

- form_name:

  The `form_name` described in the named column from the REDCap
  metadata.

- db_data:

  The REDCap database output defined by
  `REDCapR::redcap_read_oneshot()$data`

- db_metadata:

  The REDCap metadata output defined by
  `REDCapR::redcap_metadata_read()$data`

## Value

A subset `tibble` of all data related to a specified `form_name`
