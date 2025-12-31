# Extract longitudinal REDCap databases into tidy tibbles

Helper function internal to `read_redcap` responsible for extraction and
final processing of a tidy `tibble` to the user from a longitudinal
REDCap database.

## Usage

``` r
clean_redcap_long(
  db_data_long,
  db_metadata_long,
  linked_arms,
  allow_mixed_structure = FALSE
)
```

## Arguments

- db_data_long:

  The longitudinal REDCap database output defined by
  `REDCapR::redcap_read_oneshot()$data`

- db_metadata_long:

  The longitudinal REDCap metadata output defined by
  `REDCapR::redcap_metadata_read()$data`

- linked_arms:

  Output of `link_arms`, linking instruments to REDCap events/arms

- allow_mixed_structure:

  A logical to allow for support of mixed repeating/non-repeating
  instruments. Setting to `TRUE` will treat the mixed instrument's
  non-repeating versions as repeating instruments with a single
  instance. Applies to longitudinal projects only. Default `FALSE`.

## Value

Returns a `tibble` with list elements containing tidy dataframes. Users
can access dataframes under the `redcap_data` column with reference to
`form_name` and `structure` column details.
