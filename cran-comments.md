# Description

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke, Richard Hanna, or Ezra Porter for any questions, comments, or concerns.

This submission makes modifications to the test suite to be compatible with the upcoming release of REDCapR 1.2.0. There are no user-facing changes to functionality.

## Test environments

1. Local macOS Ventura 13.4, R 4.2.1
2. R-hub
    1. [Ubuntu Linux 20.04.1 LTS, R-release, GCC](https://builder.r-hub.io/status/REDCapTidieR_0.4.0.9001.tar.gz-f853e048ec7949ed8b7de8b21bef7846)
    2. [Fedora Linux, R-devel, clang, gfortran](https://builder.r-hub.io/status/REDCapTidieR_0.4.0.9001.tar.gz-cb2489664ff740b6a2f751757feb6c55)
    3. [Windows Server](https://builder.r-hub.io/status/REDCapTidieR_0.4.0.9001.tar.gz-71108297d2fb4e5ea9a80e4eec49946d)
3.  [win-builder](https://win-builder.r-project.org/EFDoel1TQ0VI/), development version.
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
