redcap_uri <- Sys.getenv("REDCAP_URI")
token <- Sys.getenv("SUPERHEROES_REDCAP_API")

superheroes_supertbl <- read_redcap(redcap_uri, token)

usethis::use_data(superheroes_supertbl, overwrite = TRUE)
