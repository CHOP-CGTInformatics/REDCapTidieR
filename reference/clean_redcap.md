# Extract non-longitudinal REDCap databases into tidy tibbles

Helper function internal to `read_redcap` responsible for extraction and
final processing of a tidy `tibble` to the user from a non-longitudinal
REDCap database.

## Usage

``` r
clean_redcap(db_data, db_metadata, form_structure)
```

## Arguments

- db_data:

  The REDCap database output defined by
  `REDCapR::redcap_read_oneshot()$data`

- db_metadata:

  The REDCap metadata output defined by
  `REDCapR::redcap_metadata_read()$data`

- form_structure:

  A tibble with cols `redcap_form_name` and `structure` with the
  structure of each form

## Value

Returns a `tibble` with list elements containing tidy dataframes. Users
can access dataframes under the `redcap_data` column with reference to
`form_name` and `structure` column details.
