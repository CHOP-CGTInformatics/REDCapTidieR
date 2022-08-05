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

# Longitudinal DB Linked Arms Output ----
# Necessary because a separate API call is needed for `redcap_event_instruments`

linked_arms_long <- link_arms(db_data_long = db_data_long,
                              db_metadata_long = db_metadata_long,
                              redcap_uri = redcap_uri,
                              token = longitudinal_token)

saveRDS(linked_arms_long, "inst/testdata/linked_arms_long.RDS")

# Longitudinal DB No Arms ----
db_data_long_noarms <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                           token = longitudinal_noarms_token,
                                           verbose = FALSE)$data

db_metadata_long_noarms <- redcap_metadata_read(redcap_uri = redcap_uri,
                                                token = longitudinal_noarms_token,
                                                verbose = FALSE)$data

saveRDS(db_data_long_noarms, "inst/testdata/db_data_long_noarms.RDS")
saveRDS(db_metadata_long_noarms, "inst/testdata/db_metadata_long_noarms.RDS")

# Longitudinal DB Linked Arms Output (No Arms)----
# Necessary because a separate API call is needed for `redcap_event_instruments`

linked_arms_long_noarms <- link_arms(db_data_long = db_data_long_noarms,
                                     db_metadata_long = db_metadata_long_noarms,
                                     redcap_uri = redcap_uri,
                                     token = longitudinal_noarms_token)

saveRDS(linked_arms_long_noarms, "inst/testdata/linked_arms_long_noarms.RDS")

# REDCapTidieR Longitudinal Output ----
read_redcap_tidy(redcap_uri = redcap_uri,
                 token = longitudinal_token) %>%
  saveRDS("inst/testdata/redcaptidier_longitudinal_db.RDS")