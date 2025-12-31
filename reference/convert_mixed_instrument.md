# Convert Mixed Structure Instruments to Repeating Instruments

For longitudinal projects where users set `allow_mixed_structure` to
`TRUE`, this function will handle the process of setting the
nonrepeating parts of the instrument to repeating ones with a single
instance.

## Usage

``` r
convert_mixed_instrument(db_data_long, mixed_structure_ref)
```

## Arguments

- db_data_long:

  The longitudinal REDCap database output defined by
  `REDCapR::redcap_read_oneshot()$data`

- mixed_structure_ref:

  Reference dataframe containing mixed structure fields and forms.

## Value

Returns a `tibble` with list elements containing tidy dataframes. Users
can access dataframes under the `redcap_data` column with reference to
`form_name` and `structure` column details.
