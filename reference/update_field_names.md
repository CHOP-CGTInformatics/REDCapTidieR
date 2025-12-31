# Update metadata field names for checkbox handling

Takes a `db_metadata` object and:

- replaces checkbox field rows with a set of rows, one for each checkbox
  option

- appends a `field_name_updated` field to the end for checkbox variable
  handling

- updates `field_label` for any new checkbox rows to include the
  specific option in "field_label: option label" format

- strips html and field embedding logic from `field_label`

## Usage

``` r
update_field_names(db_metadata)
```

## Arguments

- db_metadata:

  The REDCap metadata output defined by
  `REDCapR::redcap_metadata_read()$data`

## Value

Column `db_metadata` with `field_name_updated` appended and
`field_label` updated for new rows corresponding to checkbox options

## Details

Assumes `db_metadata`:

- has non-zero number of rows

- contains `field_name` and `field_label` columns
