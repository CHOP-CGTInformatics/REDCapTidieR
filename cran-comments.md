# Description

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke or Richard Hanna for any questions, comments, or concerns.

This submission includes new features, optimizations, and bug fixes. It also addresses feedback requesting the tarball size be reduced.

### New Features

* `read_redcap()` now supports REDCap projects with Data Access Groups
* Two new functions are introduced: `write_redcap_xlsx()` and `add_skimr_metadata()` with associated documentation
* Improved error message suite
* Bug fixes

## Test environments

1. Local macOS Ventura 13.2.1, R 4.2.0
2. R-hub
    1. [Ubuntu Linux 20.04.1 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapTidieR_0.4.0.tar.gz-1567c0031be04352b70fb485f44e2b93)
    2. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapTidieR_0.4.0.tar.gz-7e580ca7c42f47d79fc6b02b7777fbf6)
    3. [Windows Server](https://builder.r-hub.io/status/REDCapTidieR_0.4.0.tar.gz-6a7b69a606ac45da97d9f5d5f6d6c1ff)
3.  [win-builder](https://win-builder.r-project.org/d8dmbgX197E5/), development version.
4.  [GiHub Actions](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions), Ubuntu 20.04.02 LTS

## R CMD check results:

- 0 ERRORs or WARNINGs on any builds

- A NOTE is generated in R-hub Fedora Linux (R-devel, clang, gfortran) and R-hub Ubuntu Linux (20.04.1 LTS, R-release, GCC), but could not be reproduced locally. Based on [this discussion](https://groups.google.com/g/r-sig-mac/c/7u_ivEj4zhM?pli=1), it sounds like a problem with the testing environment, and not the package code.

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

- A NOTE is generated in R-hub Windows (Server 2022, R-devel 64-bit), and has been documented in an [`rhub` issue](https://github.com/r-hub/rhub/issues/560)

```
* checking for non-standard things in the check directory ... NOTE
Found the following files/directories:
  ''NULL''
```

## Downstream Dependencies:

No downstream packages are affected. No packages depend/import/suggest REDCapTidieR. Results: <https://github.com/CHOP-CGTInformatics/REDCapTidieR/blob/main/revdep/cran.md>
