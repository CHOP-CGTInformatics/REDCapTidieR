# Description

This is a resubmission to address feedback from email correspondence with Victoria Wimmer.

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke or Richard Hanna for any questions, comments, or concerns.

## Feedback Addressed:

- `DESCRIPTION` misspellings have been edited using single quotes:
  - `REDCap` & `tibble`
- `\dontrun{}` have been removed from `@examples` tags where possible and replaced with simpler toy examples
  - `\dontrun{}` has been kept in the `@examples` for `read_redcap_tidy` due to requiring an API token. This follows similarly to the underlying `REDCapR::redcap_read_oneshot` example documentation

## R CMD check results:

- 0 ERRORs or WARNINGs on any builds
- A NOTE is generated in R-hub Windows (Server 2022, R-devel 64-bit), a similar issue appears to arise in the `REDCapR` package and appears to be related to the R-hub test environment.

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```
