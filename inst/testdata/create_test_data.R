# This script solely used for loading and saving testing data for the test suite

# Load argument vars
classic_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_API")
longitudinal_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
longitudinal_noarms_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOARMS_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

# Classic DB ----
db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                               token = classic_token,
                               verbose = FALSE)$data

db_metadata <- redcap_metadata_read(redcap_uri = redcap_uri,
                                    token = classic_token,
                                    verbose = FALSE)$data

saveRDS(db_data, "inst/testdata/db_data_classic.RDS")
saveRDS(db_metadata, "inst/testdata/db_metadata_classic.RDS")

# Longitudinal DB ----
db_data_long <- redcap_read_oneshot(redcap_uri = redcap_uri,
                               token = longitudinal_token,
                               verbose = FALSE)$data

db_metadata_long <- redcap_metadata_read(redcap_uri = redcap_uri,
                                    token = longitudinal_token,
                                    verbose = FALSE)$data

saveRDS(db_data_long, "inst/testdata/db_data_long.RDS")
saveRDS(db_metadata_long, "inst/testdata/db_metadata_long.RDS")

# REDCapTidieR Longitudinal Output ----
read_redcap_tidy(redcap_uri = redcap_uri,
                 token = longitudinal_token) %>%
  saveRDS("inst/testdata/redcaptidier_longitudinal_db.RDS")
