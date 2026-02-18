devtools::load_all()

options(rlang_backtrace_on_error_report = "none")

# warnings

# check_metadata_field_types

db_data <- tibble::tibble(
  record_id = c(1L, 2L),
  text_field = c(TRUE, NA),
  dropdown_field = c(TRUE, FALSE),
  checkbox___1 = Sys.Date(),
  file_field = c(100, 200),
  slider_field = c("50", NA)
)

db_metadata <- tibble::tibble(
  form_name = "form_a",
  field_name = c("record_id", "text_field", "dropdown_field", "checkbox", "file_field", "slider_field"),
  field_label = c("Record ID", "Text", "Dropdown", "Checkbox", "File", "Slider"),
  field_type = c("text", "text", "dropdown", "checkbox", "file", "slider"),
  select_choices_or_calculations = c(NA, NA, "1, A | 2, B", "1, Yes | 0, No", NA, NA)
)

check_metadata_field_types(db_data, db_metadata)

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

## unexpected REDCapR error

try_redcapr(list(success = FALSE, status_code = "", outcome_message = "This is an error message from REDCapR!"))

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

withr::with_tempdir({
  dir <- getwd()
  filepath <- paste0(dir, "/temp")
  read_redcap(redcap_uri, longitudinal_token) %>%
    write_redcap_xlsx(file = filepath)
})

# Printed supertibble

read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API")) %>%
  suppressWarnings()

# missing data codes

read_redcap(redcap_uri, Sys.getenv("REDCAPTIDIER_MDC_API"))

# No DAG export access

read_redcap(Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_DAG_ACCESS_API"))
