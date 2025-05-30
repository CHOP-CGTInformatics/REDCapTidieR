# Description

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke, Richard Hanna, or Ezra Porter for any questions, comments, or concerns.

This submission for v1.2.3 patches two minor bugs related to the clarity of error and warning messages.

## Test environments

1.  Local macOS Sequoia 15.2, R 4.4.0
2.  R-hub
    1.  [Ubuntu 24.04.2 LTS, R-next, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/15351802286/job/43201633589)
    2.  [Ubuntu 24.04.2 LTS, R-release, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/15351802286/job/43201633580)
    3.  [Ubuntu 24.04.2 LTS, R-devel, GCC](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/15351802286/job/43201633593)
    4.  [Microsoft Windows Server 2022, 10.0.20348](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/15351802286/job/43201633585)
3.  [win-builder](https://win-builder.r-project.org/sXA2nedLAHgM/00check.log), development version.
4.  [GiHub Actions](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions), Ubuntu 20.04.05 LTS

## R CMD check results:

-   0 ERRORs or WARNINGs on any builds
-   `win-builder` contained one expected NOTE related to the email address for the `win-builder` submission varying from the package maintainer

## Downstream Dependencies:

All packages that depend/import/suggest REDCapTidieR pass the [Reverse dependency checks](https://github.com/CHOP-CGTInformatics/REDCapTidieR/actions/runs/15351817999).
