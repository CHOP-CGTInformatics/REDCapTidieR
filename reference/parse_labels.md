# Parse labels from REDCap metadata into usable formats

Takes a string separated by `,`s and/or `|`s (i.e. comma/tab separated
values) containing key value pairs (`raw` and `label`) and returns a
tidy `tibble`.

## Usage

``` r
parse_labels(string, return_vector = FALSE, return_stripped_text_flag = FALSE)
```

## Arguments

- string:

  A `db_metadata$select_choices_or_calculations` field pre-filtered for
  checkbox `field_type`

- return_vector:

  logical for whether to return result as a vector

- return_stripped_text_flag:

  logical for whether to return a flag indicating whether or not text
  was stripped from labels

## Value

A tidy `tibble` from a matrix giving raw and label outputs to be used in
later functions if `return_vector = FALSE`, the default. Otherwise a
vector result in a c(raw = label) format to use with dplyr::recode

## Details

The associated `string` comes from metadata outputs.
