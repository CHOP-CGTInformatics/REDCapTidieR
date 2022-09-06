# This script solely used for loading and saving testing data for the test suite

# Load argument vars
classic_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_API")
classic_norepeat_token <- Sys.getenv("REDCAPTIDIER_CLASSIC_NOREPEAT_API")
longitudinal_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
longitudinal_norepeat_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOREPEAT_API")
longitudinal_noarms_token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_NOARMS_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

# Classic DB ----
db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                               token = classic_token,
                               verbose = FALSE)$data

db_metadata <- redcap_metadata_read(redcap_uri = redcap_uri,
                                    token = classic_token,
                                    verbose = FALSE)$data

# Apply checkbox appending functions to metadata
db_metadata <- update_field_names(db_metadata)

saveRDS(db_data, "inst/testdata/db_data_classic.RDS")
saveRDS(db_metadata, "inst/testdata/db_metadata_classic.RDS")

# Classic No Repeat DB ----
db_data <- redcap_read_oneshot(redcap_uri = redcap_uri,
                               token = classic_norepeat_token,
                               verbose = FALSE)$data

db_metadata <- redcap_metadata_read(redcap_uri = redcap_uri,
                                    token = classic_norepeat_token,
                                    verbose = FALSE)$data

# Apply checkbox appending functions to metadata
db_metadata <- update_field_names(db_metadata)

saveRDS(db_data, "inst/testdata/db_data_classic_norepeat.RDS")
saveRDS(db_metadata, "inst/testdata/db_metadata_classic_norepeat.RDS")

# Longitudinal DB ----
db_data_long <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                    token = longitudinal_token,
                                    verbose = FALSE)$data

db_metadata_long <- redcap_metadata_read(redcap_uri = redcap_uri,
                                         token = longitudinal_token,
                                         verbose = FALSE)$data

# Apply checkbox appending functions to metadata
db_metadata_long <- update_field_names(db_metadata_long)

saveRDS(db_data_long, "inst/testdata/db_data_long.RDS")
saveRDS(db_metadata_long, "inst/testdata/db_metadata_long.RDS")

# Longitudinal No Repeat DB ----
db_data_long <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                    token = longitudinal_norepeat_token,
                                    verbose = FALSE)$data

db_metadata_long <- redcap_metadata_read(redcap_uri = redcap_uri,
                                         token = longitudinal_norepeat_token,
                                         verbose = FALSE)$data

# Apply checkbox appending functions to metadata
db_metadata_long <- update_field_names(db_metadata_long)

saveRDS(db_data_long, "inst/testdata/db_data_long_norepeat.RDS")
saveRDS(db_metadata_long, "inst/testdata/db_metadata_long_norepeat.RDS")

# Longitudinal DB Linked Arms Output ----
# Necessary because a separate API call is needed for `redcap_event_instruments`

linked_arms_long <- link_arms(db_data_long = db_data_long,
                              db_metadata_long = db_metadata_long,
                              redcap_uri = redcap_uri,
                              token = longitudinal_token)

saveRDS(linked_arms_long, "inst/testdata/linked_arms_long.RDS")

# Longitudinal DB Linked Arms Output (No Repeating) ----
# Necessary because a separate API call is needed for `redcap_event_instruments`

linked_arms_long <- link_arms(db_data_long = db_data_long_norepeat,
                              db_metadata_long = db_metadata_long_norepeat,
                              redcap_uri = redcap_uri,
                              token = longitudinal_norepeat_token)

saveRDS(linked_arms_long, "inst/testdata/linked_arms_long_norepeat.RDS")

# Longitudinal DB No Arms ----
db_data_long_noarms <- redcap_read_oneshot(redcap_uri = redcap_uri,
                                           token = longitudinal_noarms_token,
                                           verbose = FALSE)$data

db_metadata_long_noarms <- redcap_metadata_read(redcap_uri = redcap_uri,
                                                token = longitudinal_noarms_token,
                                                verbose = FALSE)$data

# Apply checkbox appending functions to metadata
db_metadata_long_noarms <- update_field_names(db_metadata_long_noarms)

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


