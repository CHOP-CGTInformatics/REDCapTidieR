# Extract repeat tables from longitudinal REDCap databases

Sub-helper function to `clean_redcap_long` for single repeat table
extraction.

## Usage

``` r
distill_repeat_table_long(
  form_name,
  db_data_long,
  db_metadata_long,
  linked_arms,
  has_mixed_structure_forms = FALSE,
  mixed_structure_ref = NULL
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

- has_mixed_structure_forms:

  Whether the instrument under evaluation has a mixed structure. Default
  `FALSE`.

- mixed_structure_ref:

  A mixed structure reference dataframe supplied by
  [`get_mixed_structure_fields()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/get_mixed_structure_fields.md).

## Value

A `tibble` of all data related to a specified `form_name`
