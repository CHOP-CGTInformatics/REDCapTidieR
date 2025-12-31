# Check if labelled

Checks if a supplied supertibble is labelled and throws an error if it
is not but `labelled` is set to `TRUE`

## Usage

``` r
check_labelled(supertbl, add_labelled_column_headers, call = caller_env())
```

## Arguments

- supertbl:

  a supertibble generated using
  [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)

- add_labelled_column_headers:

  Whether or not to include labelled outputs

- call:

  the calling environment to use in the warning message

## Value

A boolean
