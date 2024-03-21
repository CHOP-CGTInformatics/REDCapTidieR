# This is a helper test script to be run in conjunction with refresh.R
# for testing database connection and retrieval before CRAN submission

library(dplyr)
library(microbenchmark)

# Load REDCapR creds
ouhsc_creds <- readr::read_csv(file = "utility/redcapr.example.credentials", skip = 5) %>%
  select(redcap_uri, token, comment)

# Remove identified APIs that don't work
ouhsc_creds <- ouhsc_creds[-c(5,6,10,15,19),]
# Empty rows (dataframe with 0 rows, 0 columns)
# Single Column (dataframe with 0 rows, 0 columns)
# Missing/invalid token, "---" (REDCapR errors as well)
# Potentially problematic dictionary  (dataframe with 0 rows, 0 columns)
# super-wide #2--5,785 columns (dataframe with 0 rows, 0 columns)

# Load REDCapTidieR and CGTI creds
redcaptidier_creds <- tibble::tribble(
  ~redcap_uri, ~token, ~comment,
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_API"), "classic",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_CLASSIC_NOREPEAT_API"), "classic no repeat",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API"), "longitudinal",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOARMS_API"), "longitudinal no arms",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOREPEAT_API"), "longitudinal no repeat",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_DEEP_DIVE_VIGNETTE_API"), "deep dive vignette",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_REPEAT_FIRST_INSTRUMENT_API"), "repeat first instrument",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_REPEATING_EVENT_API"), "repeat event",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_RESTRICTED_ACCESS_API"), "restricted access",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LARGE_SPARSE_API"), "large sparse db",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_DAG_API"), "data access groups",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_LONGITUDINAL_DAG_API"), "longitudinal data access groups",
  Sys.getenv("REDCAP_URI"), Sys.getenv("REDCAPTIDIER_MIXED_STRUCTURE_API"), "mixed structure repeat no repeat",
  Sys.getenv("REDCAP_URI"), Sys.getenv("PRODIGY_REDCAP_API"), "prodigy db",
  Sys.getenv("REDCAP_URI"), Sys.getenv("CART_COMP_REDCAP_API"), "cart comprehensive db",
  Sys.getenv("REDCAP_URI"), Sys.getenv("BMT_OUTCOMES_REDCAP_API"), "bmt outcomes db"
)

# Combine Credentials
creds <- rbind(ouhsc_creds %>% mutate(source = "ouhsc"), redcaptidier_creds %>% mutate(source = "redcaptidier"))

microbenchmark_fx <- function(redcap_uri, token, name, times = 1){
  microbenchmark(
    name = read_redcap(redcap_uri = redcap_uri, token = token, allow_mixed_structure = TRUE),
    times = times,
    unit = "seconds"
  )
}

microbenchmark_results <- purrr::map2(creds$redcap_uri, creds$token, ~microbenchmark_fx(.x, .y, "name", 1))

out <- tibble::tibble()

for (i in seq_along(microbenchmark_results)) {
  out <- rbind(out, summary(microbenchmark_results[[i]]))
}

out %>%
  select(-expr) %>%
  mutate(across(tidyselect::everything(), ~round(., digits = 2))) %>%
  cbind(., "description" = creds$comment, "source" = creds$source) %>%
  readr::write_csv("utility/microbenchmark_results.csv")
