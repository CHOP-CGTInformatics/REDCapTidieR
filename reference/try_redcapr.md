# Make a `REDCapR` API call with custom error handling

Make a `REDCapR` API call with custom error handling

## Usage

``` r
try_redcapr(expr, call = caller_env())
```

## Arguments

- expr:

  an expression making a `REDCapR` API call

- call:

  the calling environment to use in the warning message

## Value

If successful, the `data` element of the `REDCapR` result. Otherwise an
error
