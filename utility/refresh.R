rm(list = ls(all.names = TRUE))
deviceType <- ifelse(R.version$os=="linux-gnu", "X11", "windows")
options(device = deviceType) #https://support.rstudio.org/help/discussions/problems/80-error-in-function-only-one-rstudio-graphics-device-is-permitted

spelling::spell_check_package()
# spelling::update_wordlist()
lintr::lint_package()
urlchecker::url_check(); urlchecker::url_update()

styler::style_pkg()

devtools::document()
devtools::check_man() #Should return NULL
# Dont use clean_vignettes, does not work with Mock APIs from httptest
# Therefore set clean = F
withr::with_envvar(
  new = c("NOT_CRAN" = "true"),
  devtools::build_vignettes()
)

checks_to_exclude <- c(
  "covr",
  "cyclocomp",
  "lintr_line_length_linter"
)
gp <-
  goodpractice::all_checks() |>
  purrr::discard(~(. %in% checks_to_exclude)) |>
  {
    \(checks)
    goodpractice::gp(checks = checks)
  }()
goodpractice::results(gp)
gp

devtools::document()
pkgdown::clean_site()
withr::with_envvar(
  new = c("NOT_CRAN" = "true"),
  pkgdown::build_site()
)


devtools::run_examples(); #dev.off() #This overwrites the NAMESPACE file too
# pkgload::load_all()
test_results_checked <- devtools::test()

# Test Sample REDCap Databases - This takes a while
source("utility/test_creds.R")

# devtools::check(force_suggests = FALSE)
devtools::check(cran=TRUE)
# check as CRAN
devtools::check(cran=TRUE, env_vars = c(NOT_CRAN = ""))
devtools::check( # Equivalent of R-hub
  manual    = TRUE,
  remote    = TRUE,
  incoming  = TRUE
)
# devtools::check_rhub(email="richardshanna91@gmail.com")
# devtools::check_win_devel(email = "richardshanna91@gmail.com") # CRAN submission policies encourage the development version
# Note: Must be off of VPN
revdepcheck::revdep_check(num_workers = 4)
# devtools::release(check=FALSE) #Careful, the last question ultimately uploads it to CRAN, where you can't delete/reverse your decision.
