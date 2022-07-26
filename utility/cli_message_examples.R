devtools::load_all()

options(rlang_backtrace_on_error_report = "none")

# read_redcap

classic_token <- "123456789ABCDEF123456789ABCDEF01"
redcap_uri <- "www.google.com"

## redcap_uri

read_redcap(123, classic_token)

read_redcap(letters[1:3], classic_token)

## token

read_redcap(redcap_uri, 123)

read_redcap(redcap_uri, letters[1:3])

## raw_or_label

read_redcap(redcap_uri, classic_token, raw_or_label = "bad option")

## forms

read_redcap(redcap_uri, classic_token, forms = 123)

## export_survey_fields

read_redcap(redcap_uri, classic_token, export_survey_fields = 123)

read_redcap(redcap_uri, classic_token, export_survey_fields = c(TRUE, TRUE))

## suppress_redcapr_messages

read_redcap(redcap_uri, classic_token, suppress_redcapr_messages = 123)

read_redcap(redcap_uri, classic_token, suppress_redcapr_messages = c(TRUE, TRUE))

# bind_tibbles

bind_tibbles(123)

supertbl <- tibble(redcap_data = list())
bind_tibbles(supertbl, environment = "abc")

bind_tibbles(supertbl, tbls = 123)

# extract_tibbles

extract_tibbles(letters[1:10])

# extract_tibble

extract_tibble(123, "my_tibble")

supertbl <- tibble(redcap_data = list()) %>%
  as_supertbl()
extract_tibble(supertbl, tbl = 123)

extract_tibble(supertbl, tbl = letters[1:3])

# make_labelled

make_labelled(123)

missing_col_supertbl <- tibble(redcap_data = list()) %>%
  as_supertbl()
make_labelled(missing_col_supertbl)

missing_list_col_supertbl <- tibble(redcap_data = list(), redcap_metadata = 123) %>%
  as_supertbl()
make_labelled(missing_list_col_supertbl)
