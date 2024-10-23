# Description

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke, Richard Hanna, or Ezra Porter for any questions, comments, or concerns.

This submission for v1.2.0 adds new functionality, new documentation, and patches several minor bugs.

## New Features

The only new feature in this release is an analytics function that exists in a silo away from the rest of the core package.

## Test environments

1.  Local macOS Sonoma 14.6.1, R 4.4.0
2.  R-hub
    1.  [Ubuntu 22.04.5 LTS, R-next, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/11486785018/job/31969845126)
    2.  [Ubuntu 22.04.5 LTS, R-release, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/11486785018/job/31969845814)
    3.  [Ubuntu 22.04.4 LTS, R-devel, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/11486785018/job/31969845504)
    4.  [Microsoft Windows Server 2022, 10.0.20348](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/11486785018/job/31969846106)
3.  [win-builder](https://win-builder.r-project.org/OQCea7cbW815/), development version.
4.  [GiHub Actions](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions), Ubuntu 20.04.05 LTS

## R CMD check results:

-   0 ERRORs or WARNINGs on any builds

## Downstream Dependencies:

All packages that depend/import/suggest REDCapTidieR pass the [Reverse dependency checks](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/11486797194).
