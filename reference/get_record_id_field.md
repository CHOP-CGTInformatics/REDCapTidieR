# Utility function to extract the name of the project identifier field for a tibble of REDCap data

Utility function to extract the name of the project identifier field for
a tibble of REDCap data

## Usage

``` r
get_record_id_field(data)
```

## Arguments

- data:

  a tibble of REDCap data

## Value

The name of the identifier field in the data

## Details

The current implementation assumes that the first field in the data is
the project identifier
