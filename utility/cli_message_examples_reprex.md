``` r
devtools::load_all()
#> ℹ Loading REDCapTidieR

options(rlang_backtrace_on_error_report = "none")

# read_redcap

classic_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

## args missing

# read_redcap()

# read_redcap(redcap_uri)

# read_redcap(token = classic_token)

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

read_redcap("https://www.google.com", classic_token)
#> Error in `read_redcap()`:
#> ✖ The REDCapR export operation was not successful.
#> ! The URL returned the HTTP error code 405 (POST Method not allowed).
#> ℹ Are you sure the URI points to an active REDCap API endpoint?
#> ℹ URI: `https://www.google.com`

read_redcap("https://www.google.comm", classic_token)
#> Error in `read_redcap()`:
#> ✖ The REDCapR export operation was not successful.
#> ! Could not resolve the hostname.
#> ℹ Is there a typo in the URI?
#> ℹ URI: `https://www.google.comm`

## token

read_redcap(redcap_uri, 123)
#> Error in `read_redcap()`:
#> ✖ You've supplied `123` for `token` which is not a valid value
#> ! Must be of type 'character', not 'double'

read_redcap(redcap_uri, letters[1:3])
#> Error in `read_redcap()`:
#> ✖ You've supplied `a`, `b`, `c` for `token` which is not a valid value
#> ! Must have length 1, but has length 3

read_redcap(redcap_uri, "")
#> Error in `read_redcap()`:
#> ✖ The token is an empty string, not a valid 32-character hexademical
#>   value.
#> ℹ API token: ``

read_redcap(redcap_uri, "CC0CE44238EF65C5DA26A55DD749AF7") # 31 hex characters
#> Error in `read_redcap()`:
#> ✖ The token is not a valid 32-character hexademical value.
#> ℹ API token: `CC0CE44238EF65C5DA26A55DD749AF7`

read_redcap(redcap_uri, "CC0CE44238EF65C5DA26A55DD749AF7A") # will be rejected by server
#> Error in `read_redcap()`:
#> ✖ The REDCapR export operation was not successful.
#> ! The URL returned the HTTP error code 403 (Forbidden).
#> ℹ Are you sure this is the correct API token?
#> ℹ API token: `CC0CE44238EF65C5DA26A55DD749AF7A`

## deleted project

read_redcap(redcap_uri, "AC1759E5D3E10EF64350B05F5A96DB5F")
#> Error in `read_redcap()`:
#> ✖ The REDCapR export operation was not successful.
#> ! The REDCap project does not exist because it was deleted.
#> ℹ Are you sure this is the correct API token?
#> ℹ API token: `AC1759E5D3E10EF64350B05F5A96DB5F`

## unexpected REDCapR error

try_redcapr(list(success = FALSE, status_code = "", outcome_message = "This is an error message from REDCapR!"))
#> Called from: try_redcapr(list(success = FALSE, status_code = "", outcome_message = "This is an error message from REDCapR!"))
#> debug at /Users/porterej/code/cgt-dataops/REDCapTidieR/R/utils.R#676: if (inherits(calling_fn, "{")) {
#>     calling_fn <- calling_fn[[2]]
#> }
#> debug at /Users/porterej/code/cgt-dataops/REDCapTidieR/R/utils.R#680: condition$parent <- catch_cnd(abort(out$outcome_message, call = calling_fn))
#> debug at /Users/porterej/code/cgt-dataops/REDCapTidieR/R/utils.R#684: cli_abort(c(condition$message, condition$info), call = condition$call, 
#>     parent = condition$parent, class = condition$class, redcapr_status_code = out$status_code, 
#>     redcapr_outcome_message = out$outcome_message)
#> Error:
#> ✖ The REDCapR export operation was not successful.
#> ! An unexpected error occured.
#> ℹ This means that you probably discovered a bug!
#> ℹ Please consider submitting a bug report here:
#>   <https://github.com/CHOP-CGTInformatics/REDCapTidieR/issues>.
#> Caused by error in `list()`:
#> ! This is an error message from REDCapR!

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
#> ! Must be of type 'logical' (or 'NULL'), not 'double'

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
#> ✖ You've supplied `<rdcp_spr[,1]>` for `supertbl` which is not a valid
#>   value
#> ! Must contain `supertbl$redcap_metadata`
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

missing_list_col_supertbl <- tibble(redcap_data = list(), redcap_metadata = 123) %>%
  as_supertbl()
make_labelled(missing_list_col_supertbl)
#> Error in `make_labelled()`:
#> ✖ You've supplied `<rdcp_spr[,2]>` for `supertbl` which is not a valid
#>   value
#> ! `supertbl$redcap_metadata` must be of type 'list'
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`
```

<sup>Created on 2023-06-01 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
