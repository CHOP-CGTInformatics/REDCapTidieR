# Format REDCap variable labels

Use these functions with the `format_labels` argument of
[`make_labelled()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/make_labelled.md)
to define how variable labels should be formatted before being applied
to the data columns of `redcap_data`. These functions are helpful to
create pretty variable labels from REDCap field labels.

- `fmt_strip_whitespace()` removes extra white space inside and at the
  start and end of a string. It is a thin wrapper of
  [`stringr::str_trim()`](https://stringr.tidyverse.org/reference/str_trim.html)
  and
  [`stringr::str_squish()`](https://stringr.tidyverse.org/reference/str_trim.html).

- `fmt_strip_trailing_colon()` removes a colon character at the end of a
  string.

- `fmt_strip_trailing_punct()` removes punctuation at the end of a
  string.

- `fmt_strip_html()` removes html tags from a string.

- `fmt_strip_field_embedding()` removes text between curly braces
  [`{}`](https://rdrr.io/r/base/Paren.html) which REDCap uses for
  special "field embedding" logic. Note that
  [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)
  removes html tags and field embedding logic from field labels in the
  metadata by default.

## Usage

``` r
fmt_strip_whitespace(x)

fmt_strip_trailing_colon(x)

fmt_strip_trailing_punct(x)

fmt_strip_html(x)

fmt_strip_field_embedding(x)
```

## Arguments

- x:

  a character vector

## Value

a modified character vector

## Examples

``` r
fmt_strip_whitespace("Poorly Spaced   Label ")
#> [1] "Poorly Spaced Label"

fmt_strip_trailing_colon("Label:")
#> [1] "Label"

fmt_strip_trailing_punct("Label-")
#> [1] "Label"

fmt_strip_html("<b>Bold Label</b>")
#> [1] "Bold Label"

fmt_strip_field_embedding("Label{another_field}")
#> [1] "Label"

superheroes_supertbl
#> # A REDCapTidieR Supertibble with 2 instruments
#>   redcap_form_name   redcap_form_label  redcap_data redcap_metadata    structure
#>   <chr>              <chr>              <list>      <list>             <chr>    
#> 1 heroes_information Heroes Information <tibble>    <tibble [11 × 17]> nonrepea…
#> 2 super_hero_powers  Super Hero Powers  <tibble>    <tibble [2 × 17]>  repeating
#> # ℹ 4 more variables: data_rows <int>, data_cols <int>, data_size <lbstr_by>,
#> #   data_na_pct <formttbl>

make_labelled(superheroes_supertbl, format_labels = fmt_strip_trailing_colon)
#> # A REDCapTidieR Supertibble with 2 instruments
#>   redcap_form_name   redcap_form_label  redcap_data redcap_metadata    structure
#>   <chr>              <chr>              <list>      <list>             <chr>    
#> 1 heroes_information Heroes Information <tibble>    <tibble [11 × 17]> nonrepea…
#> 2 super_hero_powers  Super Hero Powers  <tibble>    <tibble [2 × 17]>  repeating
#> # ℹ 4 more variables: data_rows <int>, data_cols <int>, data_size <lbstr_by>,
#> #   data_na_pct <formttbl>
```
