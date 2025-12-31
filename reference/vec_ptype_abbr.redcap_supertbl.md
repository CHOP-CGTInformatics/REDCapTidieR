# Vector type as a string

`vec_ptype_full()` displays the full type of the vector.
`vec_ptype_abbr()` provides an abbreviated summary suitable for use in a
column heading.

## Usage

``` r
# S3 method for class 'redcap_supertbl'
vec_ptype_abbr(x, ..., prefix_named, suffix_shape)
```

## Arguments

- x:

  A vector.

- ...:

  These dots are for future extensions and must be empty.

- prefix_named:

  If `TRUE`, add a prefix for named vectors.

- suffix_shape:

  If `TRUE` (the default), append the shape of the vector.

## Value

A string.
