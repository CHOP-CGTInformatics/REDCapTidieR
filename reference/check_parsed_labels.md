# Check that parsed labels are not duplicated

Check that parsed labels are not duplicated

## Usage

``` r
check_parsed_labels(
  parsed_labels_output,
  field_name,
  warn_stripped_text = FALSE,
  call = caller_env(n = 2)
)
```

## Arguments

- parsed_labels_output:

  a vector of parsed labels produced by
  [`parse_labels()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/parse_labels.md)

- field_name:

  the name of the field associated with the labels to use in the warning
  message

- warn_stripped_text:

  logical for whether to include a note about HTML tag stripping in the
  message

- call:

  the calling environment to use in the error message. The parent of
  calling environment by default because this check usually occurs 2
  frames below the relevant context for the user

## Value

a warning message alerting specifying the duplicate labels and REDCap
field affected
