# Description

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke, Richard Hanna, or Ezra Porter for any questions, comments, or concerns.

This submission patches version 1.1.0 to fix a test failure introduced by an upcoming release of `labelled` 2.13.0. We have worked with the developer of `labelled` to ensure this patch resolves their reverse dependency check failures.

## New Features

There are no significant user-facing changes in this release.

`read_redcap(raw_or_label = "haven")` now correctly casts categorical data values to character when their type is not character or numeric. This is a constraint of labels from the `haven` package which `labelled` will be checking for explicitly in their new release.

## Test environments

1. Local macOS Ventura 13.6.5, R 4.2.4
2. R-hub
    1. [Ubuntu 22.04.4 LTS, R-next, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/8650642187/job/23719620675)
    2. [Ubuntu 22.04.4 LTS, R-release, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/8650642187/job/23719621223)
    3. [Ubuntu 22.04.4 LTS, R-devel, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/8650642187/job/23719620358)
    4. [Windows Server](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/8650642187/job/23719620965)
3.  [win-builder](https://win-builder.r-project.org/V4B5Ar22pIf5/), development version.
4.  [GiHub Actions](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions), Ubuntu 20.04.02 LTS

## R CMD check results:

- 0 ERRORs or WARNINGs on any builds

- A NOTE is generated in win-builder resulting from the package maintainer email address changing relative to the last CRAN release. This is an artifact of a different email address than the package maintainer's being used for the submission to win-builder.

```
* checking CRAN incoming feasibility ... [14s] NOTE
Maintainer: 'Richard Hanna <porterej@chop.edu>'

New maintainer:
  Richard Hanna <porterej@chop.edu>
Old maintainer(s):
  Richard Hanna <richardshanna91@gmail.com>
```

## Downstream Dependencies:

No downstream packages are affected. No packages depend/import/suggest REDCapTidieR. Results: <https://github.com/CHOP-CGTInformatics/REDCapTidieR/blob/main/revdep/cran.md>
