# Description

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke or Richard Hanna for any questions, comments, or concerns.

This submission includes new features, optimizations, and bug fixes.

### New Features

* `read_redcap()` now supports projects with repeating events which introduced a **breaking change** to data tibble column names
  * `redcap_repeat_instance` is now `redcap_form_instance`
  * `redcap_event_instance` has been added to denote repeating events
* Improved error message suite
* Bug fixes

## Test environments

1. Local macOS Catalina 10.15.7, R 4.2.0
2. R-hub
    1. [Ubuntu Linux 20.04.1 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapTidieR_0.2.0.9007.tar.gz-255c83ab7c984ea1ac3a15d94df5a18d)
    2. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapTidieR_0.2.0.9007.tar.gz-f0bdca096aaf486a9dc2bbec144939cf)
    3. [Windows Server](https://builder.r-hub.io/status/REDCapTidieR_0.2.0.9007.tar.gz-5a2dbb2e642d4af59fb4271c4dc657e8)
3.  [win-builder](https://win-builder.r-project.org/fekdXtl4cd7K/), development version.
4.  [GiHub Actions](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions), Ubuntu 20.04 LTS

## R CMD check results:

- 0 ERRORs or WARNINGs on any builds

- A NOTE is generated in R-hub Fedora Linux (R-devel, clang, gfortran), but could not be reproduced locally. Based on [this discussion](https://groups.google.com/g/r-sig-mac/c/7u_ivEj4zhM?pli=1), it sounds like a problem with the testing environment, and not the package code.

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
```

- A NOTE is generated in R-hub Windows (Server 2022, R-devel 64-bit), a similar issue appears to arise in the `REDCapR` package and appears to be related to the R-hub test environment.

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

## Downstream Dependencies:

No downstream packages are affected. No packages depend/import/suggest REDCapTidieR. Results: <https://github.com/CHOP-CGTInformatics/REDCapTidieR/blob/main/revdep/cran.md>
