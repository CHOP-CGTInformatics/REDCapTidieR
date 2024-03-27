``` r
devtools::load_all()
#> ℹ Loading REDCapTidieR

options(rlang_backtrace_on_error_report = "none")

# read_redcap

classic_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_API")
longitudinal_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
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

## unexpected REDCapR error

try_redcapr(list(success = FALSE, status_code = "", outcome_message = "This is an error message from REDCapR!"))
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
#> ! Must be element of set {'label','raw','haven'}, but is 'bad option'

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
#> ✖ You've supplied `TRUE` and `TRUE` for `export_survey_fields` which is
#>   not a valid value
#> ! Must have length 1, but has length 2

## suppress_redcapr_messages

read_redcap(redcap_uri, classic_token, suppress_redcapr_messages = 123)
#> Error in `read_redcap()`:
#> ✖ You've supplied `123` for `suppress_redcapr_messages` which is not a
#>   valid value
#> ! Must be of type 'logical', not 'double'

read_redcap(redcap_uri, classic_token, suppress_redcapr_messages = c(TRUE, TRUE))
#> Error in `read_redcap()`:
#> ✖ You've supplied `TRUE` and `TRUE` for `suppress_redcapr_messages`
#>   which is not a valid value
#> ! Must have length 1, but has length 2

# data access groups

read_redcap(redcap_uri, classic_token, export_data_access_groups = TRUE)
#> Error in `read_redcap()`:
#> ✖ Data access groups requested, but none found.
#> ℹ Are you sure the project has data access groups (DAGs) enabled?

# surveys

read_redcap(redcap_uri, longitudinal_token, export_survey_fields = TRUE)
#> Error in `read_redcap()`:
#> ✖ Project survey fields requested, but none found.
#> ℹ Are you sure the project has at least one instrument configured as a survey?

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
#> ✖ You've supplied `<suprtbl[,1]>` for `supertbl` which is not a valid
#>   value
#> ! Must contain `supertbl$redcap_metadata`
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

missing_list_col_supertbl <- tibble(redcap_data = list(), redcap_metadata = 123) %>%
  as_supertbl()
make_labelled(missing_list_col_supertbl)
#> Error in `make_labelled()`:
#> ✖ You've supplied `<suprtbl[,2]>` for `supertbl` which is not a valid
#>   value
#> ! `supertbl$redcap_metadata` must be of type 'list'
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

# add_skimr_metadata

mtcars %>% add_skimr_metadata()
#> Error in `add_skimr_metadata()`:
#> ✖ You've supplied `<df[,11]>` for `supertbl` which is not a valid value
#> ! Must be of class <redcap_supertbl>
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

# write_redcap_xlsx

withr::with_tempdir({
  dir <- getwd()
  filepath <- paste0(dir, "/temp.csv")
  REDCapTidieR:::check_file_exists(file = filepath, overwrite = FALSE)
})

withr::with_tempdir({
  dir <- getwd()
  tempfile <- write.csv(x = mtcars, file = "temp.csv")
  filepath <- paste0(dir, "/temp.csv")
  REDCapTidieR:::check_file_exists(file = filepath, overwrite = FALSE)
})
#> Error:
#> ✖ File
#>   ''/private/var/folders/qc/mmjjyjq50530z9r_7mfqcqfhxkkk67/T/RtmpQi1Xne/file52d750f31b3f/temp.csv''
#>   already exists.
#> ℹ Overwriting files is disabled by default. Set `overwrite = TRUE` to overwrite
#>   existing file.

write_redcap_xlsx(mtcars, file = "temp.xlsx")
#> Error in `write_redcap_xlsx()`:
#> ✖ You've supplied `<df[,11]>` for `supertbl` which is not a valid value
#> ! Must be of class <redcap_supertbl>
#> ℹ `supertbl` must be a REDCapTidieR supertibble, generated using
#>   `read_redcap()`

read_redcap(redcap_uri, classic_token) %>%
  write_redcap_xlsx(file = "temp.xlsx", add_labelled_column_headers = TRUE)
#> Warning in read_redcap(redcap_uri, classic_token): ! Multiple values are mapped to the label `A` in field `radio_duplicate_label`
#> ℹ Consider making the labels for `radio_duplicate_label` unique in your REDCap
#>   project
#> Warning: ! The field radio_dtxt_error in data_field_types is a radio field type, however
#>   it does not have any categories.
#> Warning: Empty string detected for a given multiple choice label.
#> Error in `write_redcap_xlsx()`:
#> ✖ `add_labelled_column_headers` declared TRUE, but no variable labels
#>   detected.
#> ℹ Did you run `make_labelled()` on the supertibble?

withr::with_tempdir({
  dir <- getwd()
  filepath <- paste0(dir, "/temp.pdf")
  read_redcap(redcap_uri, longitudinal_token) %>%
    write_redcap_xlsx(file = filepath)
})
#> Warning in write_redcap_xlsx(., file = filepath): ! Invalid file extension provided for `file`: pdf
#> ℹ The file extension should be '.xlsx'

withr::with_tempdir({
  dir <- getwd()
  filepath <- paste0(dir, "/temp")
  read_redcap(redcap_uri, longitudinal_token) %>%
    write_redcap_xlsx(file = filepath)
})
#> Warning in write_redcap_xlsx(., file = filepath): ! No extension provided for `file`:
#>   '/private/var/folders/qc/mmjjyjq50530z9r_7mfqcqfhxkkk67/T/RtmpQi1Xne/file52d72e91eb7b/temp'
#> ℹ The extension '.xlsx' will be appended to the file name.

# Printed supertibble

read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API")) %>%
  suppressWarnings()
#> # A REDCapTidieR Supertibble with 9 instruments
#>   redcap_form_name       redcap_form_label redcap_data redcap_metadata structure
#>   <chr>                  <chr>             <list>      <list>          <chr>    
#> 1 nonrepeated            Nonrepeated       <tibble>    <tibble>        nonrepea…
#> 2 nonrepeated2           Nonrepeated2      <tibble>    <tibble>        nonrepea…
#> 3 repeated               Repeated          <tibble>    <tibble>        repeating
#> 4 data_field_types       Data Field Types  <tibble>    <tibble>        nonrepea…
#> 5 text_input_validation… Text Input Valid… <tibble>    <tibble>        nonrepea…
#> 6 api_no_access          API No Access     <tibble>    <tibble>        nonrepea…
#> 7 api_no_access_2        API No Access 2   <tibble>    <tibble>        nonrepea…
#> 8 survey                 Survey            <tibble>    <tibble>        nonrepea…
#> 9 repeat_survey          Repeat Survey     <tibble>    <tibble>        repeating
#> # ℹ 5 more variables: data_rows <int>, data_cols <int>, data_size <lbstr_by>,
#> #   data_na_pct <formttbl>, form_complete_pct <formttbl>

# missing data codes

read_redcap(redcap_uri, Sys.getenv("REDCAPTIDIER_MDC_API"))
#> Warning in read_redcap(redcap_uri, Sys.getenv("REDCAPTIDIER_MDC_API")): ! `yesno` and `yesno2` are logical but contain non-logical values: UNK
#> ℹ These were converted to `NA` resulting in possible data loss
#> ℹ Does your REDCap project utilize missing data codes?
#> ℹ Silence this warning with `options(redcaptidier.allow.mdc = TRUE)` or set
#>   `raw_or_label = 'raw'` to access missing data codes
#> Warning in read_redcap(redcap_uri, Sys.getenv("REDCAPTIDIER_MDC_API")): ! `dropdown` contains values with no labels: UNK
#> ℹ These were converted to `NA` resulting in possible data loss
#> ℹ Does your REDCap project utilize missing data codes?
#> ℹ Silence this warning with `options(redcaptidier.allow.mdc = TRUE)` or set
#>   `raw_or_label = 'raw'` to access missing data codes
#> # A REDCapTidieR Supertibble with 1 instruments
#>   redcap_form_name redcap_form_label redcap_data      redcap_metadata structure 
#>   <chr>            <chr>             <list>           <list>          <chr>     
#> 1 form_1           Form 1            <tibble [3 × 9]> <tibble>        nonrepeat…
#> # ℹ 5 more variables: data_rows <int>, data_cols <int>, data_size <lbstr_by>,
#> #   data_na_pct <formttbl>, form_complete_pct <formttbl>
```

<sup>Created on 2024-03-27 with [reprex v2.1.0](https://reprex.tidyverse.org)</sup>
