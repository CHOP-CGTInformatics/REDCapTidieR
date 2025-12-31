# Check equal distinct values between two columns

Takes a dataframe and two columns and checks if `n_distinct` of the
second column is all unique based on grouping of the first column.

## Usage

``` r
check_equal_col_summaries(data, col1, col2, call = caller_env())
```

## Arguments

- data:

  a dataframe

- col1:

  a column to group by

- col2:

  a column to check for uniqueness
