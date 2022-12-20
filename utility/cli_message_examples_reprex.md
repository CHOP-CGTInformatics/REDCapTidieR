``` r
devtools::load_all()
#> ℹ Loading REDCapTidieR

options(rlang_backtrace_on_error_report = "none")

# read_redcap

classic_token <- "123456789ABCDEF123456789ABCDEF01"
redcap_uri <- "www.google.com"

## redcap_uri

read_redcap(123, classic_token)
#> Error in `read_redcap()`:
#> ✖ You've supplied `123` for `redcap_uri` which is not a valid value
#> ! Must be of type 'character', not 'double'

read_redcap(letters[1:3], classic_token)
#> Error in `read_redcap()`:
#> ✖ You've supplied `a`, `b`, `c` for `redcap_uri` which is not a valid
#>   value
#> ! Must have length 1, but has length 3

## token

read_redcap(redcap_uri, 123)
#> Error in `read_redcap()`:
#> ✖ You've supplied `123` for `token` which is not a valid value
#> ! Must be of type 'character', not 'double'

read_redcap(redcap_uri, letters[1:3])
#> Error in `read_redcap()`:
#> ✖ You've supplied `a`, `b`, `c` for `token` which is not a valid value
#> ! Must have length 1, but has length 3

## raw_or_label

read_redcap(redcap_uri, classic_token, raw_or_label = "bad option")
#> Error in `read_redcap()`:
#> ✖ You've supplied `bad option` for `raw_or_label` which is not a valid
#>   value
#> ! Must be element of set {'label','raw'}, but is 'bad option'

## forms

read_redcap(redcap_uri, classic_token, forms = 123)
#> Error in `read_redcap()`:
#> ✖ You've supplied `123` for `forms` which is not a valid value
#> ! Must be of type 'character' (or 'NULL'), not 'double'

## export_survey_fields

read_redcap(redcap_uri, classic_token, export_survey_fields = 123)
#> Error in `read_redcap()`:
#> ✖ You've supplied `123` for `export_survey_fields` which is not a valid
#>   value
#> ! Must be of type 'logical', not 'double'

read_redcap(redcap_uri, classic_token, export_survey_fields = c(TRUE, TRUE))
#> Error in `read_redcap()`:
#> ✖ You've supplied `TRUE`, `TRUE` for `export_survey_fields` which is not
#>   a valid value
#> ! Must have length 1, but has length 2

## suppress_redcapr_messages

read_redcap(redcap_uri, classic_token, suppress_redcapr_messages = 123)
#> Error in `read_redcap()`:
#> ✖ You've supplied `123` for `suppress_redcapr_messages` which is not a
#>   valid value
#> ! Must be of type 'logical', not 'double'

read_redcap(redcap_uri, classic_token, suppress_redcapr_messages = c(TRUE, TRUE))
#> Error in `read_redcap()`:
#> ✖ You've supplied `TRUE`, `TRUE` for `suppress_redcapr_messages` which
#>   is not a valid value
#> ! Must have length 1, but has length 2

# bind_tibbles

bind_tibbles(123)
#> Error in `bind_tibbles()`:
#> ✖ You've supplied `123` for `supertbl` which is not a valid value
#> ! Must be of class <redcap_supertbl>
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

supertbl <- tibble(redcap_data = list())
bind_tibbles(supertbl, environment = "abc")
#> Error in `bind_tibbles()`:
#> ✖ You've supplied `<tibble[,1]>` for `supertbl` which is not a valid
#>   value
#> ! Must be of class <redcap_supertbl>
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

bind_tibbles(supertbl, tbls = 123)
#> Error in `bind_tibbles()`:
#> ✖ You've supplied `<tibble[,1]>` for `supertbl` which is not a valid
#>   value
#> ! Must be of class <redcap_supertbl>
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

# extract_tibbles

extract_tibbles(letters[1:10])
#> Error in `extract_tibbles()`:
#> ✖ You've supplied `a`, `b`, `c`, …, `i`, `j` for `supertbl` which is not
#>   a valid value
#> ! Must be of class <redcap_supertbl>
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

# extract_tibble

extract_tibble(123, "my_tibble")
#> Error in `extract_tibble()`:
#> ✖ You've supplied `123` for `supertbl` which is not a valid value
#> ! Must be of class <redcap_supertbl>
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

supertbl <- tibble(redcap_data = list()) %>%
  as_supertbl()
extract_tibble(supertbl, tbl = 123)
#> Error in `extract_tibble()`:
#> ✖ You've supplied `123` for `tbl` which is not a valid value
#> ! Must be of type 'character', not 'double'

extract_tibble(supertbl, tbl = letters[1:3])
#> Error in `extract_tibble()`:
#> ✖ You've supplied `a`, `b`, `c` for `tbl` which is not a valid value
#> ! Must have length 1, but has length 3

# make_labelled

make_labelled(123)
#> Error in `make_labelled()`:
#> ✖ You've supplied `123` for `supertbl` which is not a valid value
#> ! Must be of class <redcap_supertbl>
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

missing_col_supertbl <- tibble(redcap_data = list()) %>%
  as_supertbl()
make_labelled(missing_col_supertbl)
#> Error in `make_labelled()`:
#> ✖ You've supplied `<redcap_supertbl[,1]>` for `supertbl` which is not a
#>   valid value
#> ! Must contain `supertbl$redcap_metadata`
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

missing_list_col_supertbl <- tibble(redcap_data = list(), redcap_metadata = 123) %>%
  as_supertbl()
make_labelled(missing_list_col_supertbl)
#> Error in `make_labelled()`:
#> ✖ You've supplied `<redcap_supertbl[,2]>` for `supertbl` which is not a
#>   valid value
#> ! `supertbl$redcap_metadata` must be of type 'list'
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`
```

<sup>Created on 2022-12-20 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
