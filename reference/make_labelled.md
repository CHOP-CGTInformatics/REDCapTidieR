# Apply variable labels to a REDCapTidieR supertibble

Take a supertibble and use the `labelled` package to apply variable
labels to the columns of the supertibble as well as to each tibble in
the `redcap_data`, `redcap_metadata`, and `redcap_events` columns of
that supertibble.

## Usage

``` r
make_labelled(supertbl, format_labels = NULL)
```

## Arguments

- supertbl:

  a supertibble generated using
  [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)

- format_labels:

  one or multiple optional label formatting functions. A label
  formatting function is a function that takes a character vector and
  returns a modified character vector of the same length. This function
  is applied to field labels before attaching them to variables. One of:

  - `NULL` to apply no additional formatting. Default.

  - A label formatting function.

  - A character with the name of a label formatting function.

  - A vector or list of label formatting functions or function names to
    be applied in order. Note that ordering may affect results.

## Value

A labelled supertibble.

## Details

The variable labels for the data tibbles are derived from the
`field_label` column of the metadata tibble.

## Examples

``` r
superheroes_supertbl
#> # A REDCapTidieR Supertibble with 2 instruments
#>   redcap_form_name   redcap_form_label  redcap_data redcap_metadata    structure
#>   <chr>              <chr>              <list>      <list>             <chr>    
#> 1 heroes_information Heroes Information <tibble>    <tibble [11 × 17]> nonrepea…
#> 2 super_hero_powers  Super Hero Powers  <tibble>    <tibble [2 × 17]>  repeating
#> # ℹ 4 more variables: data_rows <int>, data_cols <int>, data_size <lbstr_by>,
#> #   data_na_pct <formttbl>

make_labelled(superheroes_supertbl)
#> # A REDCapTidieR Supertibble with 2 instruments
#>   redcap_form_name   redcap_form_label  redcap_data redcap_metadata    structure
#>   <chr>              <chr>              <list>      <list>             <chr>    
#> 1 heroes_information Heroes Information <tibble>    <tibble [11 × 17]> nonrepea…
#> 2 super_hero_powers  Super Hero Powers  <tibble>    <tibble [2 × 17]>  repeating
#> # ℹ 4 more variables: data_rows <int>, data_cols <int>, data_size <lbstr_by>,
#> #   data_na_pct <formttbl>

make_labelled(superheroes_supertbl, format_labels = tolower)
#> # A REDCapTidieR Supertibble with 2 instruments
#>   redcap_form_name   redcap_form_label  redcap_data redcap_metadata    structure
#>   <chr>              <chr>              <list>      <list>             <chr>    
#> 1 heroes_information Heroes Information <tibble>    <tibble [11 × 17]> nonrepea…
#> 2 super_hero_powers  Super Hero Powers  <tibble>    <tibble [2 × 17]>  repeating
#> # ℹ 4 more variables: data_rows <int>, data_cols <int>, data_size <lbstr_by>,
#> #   data_na_pct <formttbl>

if (FALSE) { # \dontrun{
redcap_uri <- Sys.getenv("REDCAP_URI")
token <- Sys.getenv("REDCAP_TOKEN")

supertbl <- read_redcap(redcap_uri, token)
make_labelled(supertbl)
} # }
```
