# Description

This is a resubmission to address feedback from email correspondence with Victoria Wimmer.

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke or Richard Hanna for any questions, comments, or concerns.

## Feedback Addressed:

- `DESCRIPTION` quotations have been edited to undirected quotations:
  - `REDCap` & `tibble` to 'REDCap' & 'tibble'
- Also fixed the quotations on `tribble`s in `@examples` tags for `bind_tables` and `extract_table` and updated documentation

## R CMD check results:

- 0 ERRORs or WARNINGs on any builds
- A NOTE is generated in R-hub Windows (Server 2022, R-devel 64-bit), a similar issue appears to arise in the `REDCapR` package and appears to be related to the R-hub test environment.

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```
