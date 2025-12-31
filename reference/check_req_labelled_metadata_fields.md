# Check that all metadata tibbles within a supertibble contain `field_name` and `field_label` columns

Check that all metadata tibbles within a supertibble contain
`field_name` and `field_label` columns

## Usage

``` r
check_req_labelled_metadata_fields(supertbl, call = caller_env())
```

## Arguments

- supertbl:

  a supertibble containing a `redcap_metadata` column

- call:

  the calling environment to use in the error message

## Value

an error message alerting that instrument metadata is incomplete
