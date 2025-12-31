# Add partial key helper variables to dataframes

Make helper variables `redcap_event` and `redcap_arm` available as
branches from `var` for later use.

## Usage

``` r
add_partial_keys(db_data, var = NULL)
```

## Arguments

- db_data:

  The REDCap database output defined by
  `REDCapR::redcap_read_oneshot()$data`

- var:

  The unquoted name of the field containing event and arm identifiers.
  Default `NULL`.

## Value

Two appended columns, `redcap_event` and `redcap_arm` to the end of
`read_redcap` output `tibble`s.
