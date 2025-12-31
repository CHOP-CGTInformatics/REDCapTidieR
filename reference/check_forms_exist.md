# Check that all requested instruments are in REDCap project metadata

Provide an error message when any instrument names are passed to
[`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)
that do not exist in the project metadata.

## Usage

``` r
check_forms_exist(db_metadata, forms, call = caller_env())
```

## Arguments

- db_metadata:

  The metadata file read by
  [`REDCapR::redcap_metadata_read()`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_read.html)

- forms:

  The character vector of instrument names passed to
  [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)

- call:

  the calling environment to use in the error message

## Value

An error message listing the requested instruments that don't exist
