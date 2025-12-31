# Provide a succinct summary of an object

`tbl_sum()` gives a brief textual description of a table-like object,
which should include the dimensions and the data source in the first
element, and additional information in the other elements (such as
grouping for dplyr). The default implementation forwards to
[`obj_sum()`](https://pillar.r-lib.org/reference/type_sum.html).

## Usage

``` r
# S3 method for class 'redcap_supertbl'
tbl_sum(x)
```

## Arguments

- x:

  Object to summarise.

## Value

A named character vector, describing the dimensions in the first element
and the data source in the name of the first element.
