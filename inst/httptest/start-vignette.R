# This code is sourced when httptest::start_vignette() is called. See
# https://enpiar.com/r/httptest/articles/vignettes.html#advanced-topics

# Look for credentials needed to create a vignette and, if found, delete
# the cache of mocks associated with the vignette so that fresh mocks
# will be created.

# Credential getter function from testthat/helper.R
get_fake_credentials <- function(credentials) {
  creds <- readr::read_csv(
    system.file("misc/fake_credentials.csv", package = "REDCapTidieR"),
    col_types = "cc"
  ) %>%
    dplyr::filter(name %in% credentials)

  res <- rep("", length(credentials))
  names(res) <- credentials
  res[creds$name] <- creds$value

  # Remove names if only one value requested to mimic Sys.getenv
  if (length(res) == 1) {
    res <- unname(res)
  }

  res
}

# Assumes cache has same name as vignette
path_to_cache <- knitr::current_input() %>%
  gsub(".Rmd", "", ., fixed = TRUE)

needed_credentials <- c(
  "REDCAP_URI",
  "SUPERHEROES_REDCAP_API",
  "REDCAPTIDIER_DEEP_DIVE_VIGNETTE_API",
  "REDCAPTIDIER_CLASSIC_API"
)

creds <- Sys.getenv(needed_credentials, "none")

creds_available <- all(creds != "none")
cache_exists <- dir.exists(path_to_cache)

# If creds are not available use fake creds
if (!creds_available) {
  # Error if cache doesn't exist and creds are missing
  if (!cache_exists) {
    missing_creds <- needed_credentials[creds == "none"]

    msg <- paste(
      "The cache at {paste0(path_to_cache, '/')} does not exist and the {missing_creds}",
      "credential{?s} {?is/are} not available to restore it."
    )

    cli::cli_abort(c("x" = msg), class = "REDCapTidieR_cond")
  }

  creds <- get_fake_credentials(needed_credentials)
} else {
  # If creds are available and cache exists invalidate it
  if (cache_exists) {
    unlink(path_to_cache, recursive = TRUE)
  }
}
