# Determine if an object is labelled

An internal utility function used to inform other processes of whether
or not a given object has been labelled (i.e. with
[`make_labelled()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/make_labelled.md)).

## Usage

``` r
is_labelled(obj)
```

## Arguments

- obj:

  An object to be tested for "label" attributes

## Value

A boolean

## Details

An object is considered labelled if it has "label" attributes.
