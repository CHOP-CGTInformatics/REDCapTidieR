# Check an argument with checkmate

Check an argument with checkmate

## Usage

``` r
check_arg_is_supertbl(
  x,
  req_cols = c("redcap_data", "redcap_metadata"),
  arg = caller_arg(x),
  call = caller_env()
)

check_arg_is_env(x, ..., arg = caller_arg(x), call = caller_env())

check_arg_is_character(x, ..., arg = caller_arg(x), call = caller_env())

check_arg_is_logical(x, ..., arg = caller_arg(x), call = caller_env())

check_arg_choices(x, ..., arg = caller_arg(x), call = caller_env())

check_arg_is_valid_token(x, arg = caller_arg(x), call = caller_env())

check_arg_is_valid_extension(
  x,
  valid_extensions,
  arg = caller_arg(x),
  call = caller_env()
)
```

## Arguments

- x:

  An object to check

- req_cols:

  required fields for `check_arg_is_supertbl()`

- arg:

  The name of the argument to include in an error message. Captured by
  [`rlang::caller_arg()`](https://rlang.r-lib.org/reference/caller_arg.html)
  by default

- call:

  the calling environment to use in the error message

- ...:

  additional arguments passed on to checkmate

## Value

`TRUE` if `x` passes the checkmate check. An error otherwise with the
name of the checkmate function as a `class`
