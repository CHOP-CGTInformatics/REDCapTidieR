# Check if file already exists

Provide an error message when a file is declared for writing that
already exists.

## Usage

``` r
check_file_exists(file, overwrite, call = caller_env())
```

## Arguments

- file:

  The file that is being checked

- overwrite:

  Whether the file was declared to be overwritten

- call:

  The calling environment to use in the error message

## Value

An error message saying the requested file already exists

## Details

In the case of
[`write_redcap_xlsx()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/write_redcap_xlsx.md),
this should only error when a file already exists and is not declared
for `overwite`.
