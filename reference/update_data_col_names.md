# Correctly label variables belonging to checkboxes with minus signs

Using `db_data` and `db_metadata`, temporarily create a conversion
column that reverts automatic REDCap behavior where database column
names have "-"s converted to "\_"s.

## Usage

``` r
update_data_col_names(db_data, db_metadata)
```

## Arguments

- db_data:

  The REDCap database output defined by
  `REDCapR::redcap_read_oneshot()$data`

- db_metadata:

  The REDCap metadata output defined by
  `REDCapR::redcap_metadata_read()$data`

## Value

Updated `db_data` column names for checkboxes where "-"s were replaced
by "\_"s.

## Details

This is an issue with checkbox fields since analysts should be able to
verify checkbox variable suffices with their label counterparts.
