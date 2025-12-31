# Apply haven value labels to a vector

Apply haven value labels to a vector

## Usage

``` r
apply_labs_haven(x, labels, ptype, ...)
```

## Arguments

- x:

  a vector to label

- labels:

  a named vector of labels in the format `c(value = label)`

- ptype:

  vector to serve as prototype for label values

- ...:

  unused, needed to ignore extra arguments that may be passed

## Value

`haven_labelled` vector

## Details

Assumes a check_installed() has been run for `labelled`. Since `haven`
preserves the underlying data values we need to make sure the data type
of the value options in the metadata matches the data type of the values
in the actual data. This function accepts a prototype, usually a column
from db_data, and uses `force_cast()` to do a best-effort casting of the
value options in the metadata to the same data type as `ptype`. The
fallback is to convert `x` and the value labels to character.
