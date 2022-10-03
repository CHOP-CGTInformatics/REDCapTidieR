## ---- include = FALSE---------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

library(dplyr)
library(REDCapTidieR)

token <- Sys.getenv("REDCAPTIDIER_LONGITUDINAL_API")
redcap_uri <- Sys.getenv("REDCAP_URI")

