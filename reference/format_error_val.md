# Format value for error message

Format value for error message

## Usage

``` r
format_error_val(x)
```

## Arguments

- x:

  value to format

## Value

If x is atomic, x with cli formatting to truncate to 5 values.
Otherwise, a string summarizing x produced by as_label
