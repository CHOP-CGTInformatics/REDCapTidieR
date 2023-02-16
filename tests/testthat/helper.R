# This function returns a list of named credentials either with `Sys.getenv()` if `fake = FALSE`
# or from `inst/misc/fake_credentials.csv` if `fake = TRUE`
#
# By default all credentials stored in `fake_credentials.csv` are returned

get_credentials <- function(credentials = NULL, fake = FALSE) {
  creds <- readr::read_csv(
    system.file("misc/fake_credentials.csv", package = "REDCapTidieR"),
    col_types = "cc"
  )

  if (!is.null(credentials)) {
    if (!all(credentials %in% creds$name)) {
      missing_creds <- setdiff(credentials, creds$name)
      cli::cli_abort(c(
        "x" = "{.code {missing_creds}} {?is/are} missing from {.path inst/misc/fake_credentials.csv}"
      ))
    }

    creds <- creds[creds$name == credentials, ]
  }

  res <- rep("", nrow(creds))

  if (fake) {
    res <- creds$value
  } else {
    res <- unname(Sys.getenv(creds$name))
  }

  res <- as.list(res)
  names(res) <- creds$name
  res
}

# httptest setup ----

creds <- get_credentials(fake = TRUE)
