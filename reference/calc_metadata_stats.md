# Utility function to calculate summary for each tibble in a supertibble

Utility function to calculate summary for each tibble in a supertibble

## Usage

``` r
calc_metadata_stats(data)
```

## Arguments

- data:

  a tibble of redcap data stored in the `redcap_data` column of a
  supertibble

## Value

A list containing:

- `data_rows`, the number of rows in the data

- `data_cols`, the number of columns in the data

- `data_size`, the size of the data in bytes

- `data_na_pct`, the percentage of cells that are NA excluding
  identifiers and form completion fields
