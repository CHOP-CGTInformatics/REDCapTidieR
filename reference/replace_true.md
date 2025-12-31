# Replace checkbox TRUEs with raw_or_label values

Simple utility function for replacing checkbox field values.

## Usage

``` r
replace_true(col, col_name, metadata, raw_or_label)
```

## Arguments

- col:

  A vector

- col_name:

  A string

- metadata:

  A metadata tibble from the original supertibble

- raw_or_label:

  Either 'raw' or 'label' to specify whether to use raw coded values or
  labels for the options. Default 'label'.

## Value

A character string
