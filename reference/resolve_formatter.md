# Convert user input into label formatting function

Convert user input into label formatting function

## Usage

``` r
resolve_formatter(format_labels, env = caller_env(n = 2), call = caller_env())
```

## Arguments

- format_labels:

  argument passed to `make_labelled`

- env:

  the environment in which to look up functions if `format_labels`
  contains character elements. The default, `caller_env(n = 2)`, uses
  the environment from which the user called
  [`make_labelled()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/make_labelled.md)

- call:

  the calling environment to use in the error message

## Value

a function
