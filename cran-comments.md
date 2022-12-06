# Description

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke or Richard Hanna for any questions, comments, or concerns.

This submission includes new features, optimizations, and patches for a few identified bugs.

### New Features

* Function name changes:
  * `read_redcap_tidy` is now `read_redcap`
  * `extract_table` is now `extract_tibble`
  * `extract_tables` is now `extract_tibbles`
  * `bind_table` is now `bind_tibbles`
    * All old functions are still supported and deliver a deprecation warning
* The `read_redcap` output now includes additional helpful metadata
* New `make_labelled()` function allowing for descriptive labelling application to variables via the [`labelled`](https://larmarange.github.io/labelled/) package
* New arguments available for `read_redcap` capabilities:
  * `forms`
  * `export_survey_fields`

## Test environments

1. Local Ubuntu, R 4.2.0
1. R-hub
    1. Ubuntu Linux 20.04 LTS, R-release, GCC
    1. Fedora Linux, R-devel, clang, gfortran
    1. Windows Server
1. [win-builder](https://win-builder.r-project.org/h66QMt5KzueV), development version.
1. [GiHub Actions](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions), Ubuntu 20.04 LTS


## R CMD check results:

- 0 ERRORs or WARNINGs on any builds
- A NOTE is generated in R-hub Fedora Linux (R-devel, clang, gfortran), but could not be reproduced locally. 

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
```

  - Based on [this discussion](https://groups.google.com/g/r-sig-mac/c/7u_ivEj4zhM?pli=1) we could not determine a way to resolve this internal to our code.

## Downstream Dependencies:

No downstream packages are affected. The package that depends/imports/suggests REDCapTidieR passes checks with `revdepcheck::revdep_check()`. Results: https://github.com/CHOP-CGTInformatics/REDCapTidieR/blob/main/revdep/cran.md
