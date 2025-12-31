# Add [skimr::skim](https://docs.ropensci.org/skimr/reference/skim.html) metrics to a supertibble's metadata

Add default
[skimr::skim](https://docs.ropensci.org/skimr/reference/skim.html)
metrics to the `redcap_data` list elements of a supertibble output from
`read_readcap`.

## Usage

``` r
add_skimr_metadata(supertbl)
```

## Arguments

- supertbl:

  a supertibble generated using
  [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)

## Value

A supertibble with
[skimr::skim](https://docs.ropensci.org/skimr/reference/skim.html)
metadata metrics

## Details

For more information on the default metrics provided, check the
[skimr::get_default_skimmer_names](https://docs.ropensci.org/skimr/reference/get_default_skimmers.html)
documentation.

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

add_skimr_metadata(superheroes_supertbl)
#> # A REDCapTidieR Supertibble with 2 instruments
#>   redcap_form_name   redcap_form_label  redcap_data redcap_metadata    structure
#>   <chr>              <chr>              <list>      <list>             <chr>    
#> 1 heroes_information Heroes Information <tibble>    <tibble [11 × 33]> nonrepea…
#> 2 super_hero_powers  Super Hero Powers  <tibble>    <tibble [2 × 33]>  repeating
#> # ℹ 4 more variables: data_rows <int>, data_cols <int>, data_size <lbstr_by>,
#> #   data_na_pct <formttbl>

if (FALSE) { # \dontrun{
redcap_uri <- Sys.getenv("REDCAP_URI")
token <- Sys.getenv("REDCAP_TOKEN")

supertbl <- read_redcap(redcap_uri, token)
add_skimr_metadata(supertbl)
} # }
```
