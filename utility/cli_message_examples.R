devtools::load_all()

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

read_redcap(letters[1:3], classic_token)

read_redcap("https://www.google.com", classic_token)

read_redcap("https://www.google.comm", classic_token)

## token

read_redcap(redcap_uri, 123)

read_redcap(redcap_uri, letters[1:3])

read_redcap(redcap_uri, "")

read_redcap(redcap_uri, "CC0CE44238EF65C5DA26A55DD749AF7") # 31 hex characters

read_redcap(redcap_uri, "CC0CE44238EF65C5DA26A55DD749AF7A") # will be rejected by server

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

# data access groups

read_redcap(redcap_uri, classic_token, export_data_access_groups = TRUE)

# surveys

read_redcap(redcap_uri, longitudinal_token, export_survey_fields = TRUE)

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

# add_skimr_metadata

mtcars %>% add_skimr_metadata()

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

write_redcap_xlsx(mtcars, file = "temp.xlsx")

read_redcap(redcap_uri, classic_token) %>%
  write_redcap_xlsx(file = "temp.xlsx", add_labelled_column_headers = TRUE)

withr::with_tempdir({
  dir <- getwd()
  filepath <- paste0(dir, "/temp.pdf")
  read_redcap(redcap_uri, longitudinal_token) %>%
    write_redcap_xlsx(file = filepath)
})
