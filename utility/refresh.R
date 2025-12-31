rm(list = ls(all.names = TRUE))
deviceType <- ifelse(R.version$os=="linux-gnu", "X11", "windows")
options(device = deviceType) #https://support.rstudio.org/help/discussions/problems/80-error-in-function-only-one-rstudio-graphics-device-is-permitted

spelling::spell_check_package()
# spelling::update_wordlist()
urlchecker::url_check(); urlchecker::url_update()

styler::style_pkg()

devtools::document()
lintr::lint_package()
devtools::check_man() #Should return NULL

# Run as not CRAN to build full vignettes
# devtools::check() sets NOT_CRAN = "true" by default but must set it manually
# as needed for other devtools functions
withr::with_envvar(
  new = c("NOT_CRAN" = "true"),
  devtools::build_vignettes()
)

checks_to_exclude <- c(
  "covr",
  "cyclocomp",
  "lintr_line_length_linter",
  "pipe_consistency_linter"
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
# Run as not CRAN to build full vignettes
withr::with_envvar(
  new = c("NOT_CRAN" = "true"),
  pkgdown::build_site()
)

devtools::run_examples(); #dev.off() #This overwrites the NAMESPACE file too
# pkgload::load_all()
test_results_checked <- devtools::test()

# Test Sample REDCap Databases - This takes a while
source("utility/test_creds.R")

# Generate cli examples
reprex::reprex(input="utility/cli_message_examples.R", html_preview = FALSE)
unlink("utility/cli_message_examples_reprex.R")

# devtools::check(force_suggests = FALSE)
devtools::check(cran=TRUE)
# check as CRAN
devtools::check(cran=TRUE, env_vars = c(NOT_CRAN = ""))
devtools::check( # Equivalent of R-hub
  manual    = TRUE,
  remote    = TRUE,
  incoming  = TRUE
)
# Approx matches to https://cran.r-project.org/web/checks/check_flavors.html
rhub::rhub_check(
  platforms = c("linux", "windows", "ubuntu-next", "ubuntu-release"),
  gh_url = "https://github.com/CHOP-CGTInformatics/REDCapTidieR"
) # These will be available in GitHub Actions
devtools::check_win_devel(email = "hannar1@chop.edu") # CRAN submission policies encourage the development version
# Note: Must be off of VPN
# To run reverse dependency check, manually trigger the "Revere dependency check" workflow in GitHub Actions
# Careful, the last question ultimately uploads it to CRAN, where you can't delete/reverse your decision.
# Run as not CRAN to build full vignettes
# withr::with_envvar(
#   new = c("NOT_CRAN" = "true"),
#   devtools::release(check=FALSE)
# )
