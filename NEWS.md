Version 0.2.0 (Released 2022-12-07)
==========================================================

### New Features

* Function name changes:
  * `read_redcap_tidy()` is now `read_redcap()`
  * `extract_table()` is now `extract_tibble()`
  * `extract_tables()` is now `extract_tibbles()`
  * `bind_table()` is now `bind_tibbles()`
    * All old functions are still supported and throw a deprecation warning
* Instrument/form-level metadata included in supertibble output:
  * `redcap_form_label`: The instrument’s human-readable label
  * `redcap_metadata`: REDCap metadata associated with the instrument (derived from `REDCapR::redcap_metadata_read()`)
  * `redcap_events`: Events and arms associated with this instrument (for longitudinal projects only)
  * `data_rows`, `data_cols`: Row and column counts of `redcap_data`
  * `data_size`: Size of the `redcap_data` tibble in memory
  * `data_na_pct`: The percentage of missing data in the `redcap_data` tibble
* New `make_labelled()` function that attaches variable labels using the [labelled](https://larmarange.github.io/labelled/) package
* New arguments available `read_redcap()`:
  * `forms`: Allows reading specific instruments instead of the whole project
  * `export_survey_fields`: Allows for export of `redcap_survey_timestamp` and `redcap_survey_identifier` columns from survey-enabled REDCap instruments (`TRUE` by default)

### Performance Improvements and Enhancements

* Improved execution time by >2.5X by optimizing internal functions `check_repeat_and_nonrepeat()`, `distill_*_table_long()`, and `multi_choice_to_labels()`
* New informative warning and error messages, now rendered using the [cli](https://cli.r-lib.org/) package
* Tests and vignettes now use [httptest](https://enpiar.com/r/httptest/) to mock and cache REDCap API calls
* Implemented GitHub Actions link check 
* Replaced deprecated `.data` pronoun in tidyselect expressions

### Bug Fixes

* Fixed a bug in which similarly named variables could be duplicated under some circumstances
* Order of instruments in the supertibble is now the same as the order of instruments in REDCap
* Fixed an issue in which `extract_*()` functions under some circumstances returned `NULL` instead of the expected tibbles

Version 0.1.3 (Released 2022-10-03)
==========================================================

### Documentation Updates

* Fixed a bug where `clean_redcap()` may not correctly assign variables across instruments to their appropriate tables in cases of similar prefixes
* Minor changes applied to documentation, including`README` and `DESCRIPTION` files

Version 0.1.2 (Released 2022-09-20)
==========================================================

### Documentation Updates

* Addresses feedback received from CRAN
* `DESCRIPTION` file fixes for undirected quotation marks (e.g. `REDCap` to 'REDCap')
* Fix quotations in `@examples` tags for `bind_tables` and `extract_table`
* Update `pkgdown` site

Version 0.1.1 (Released 2022-09-19)
==========================================================

### Documentation Updates

* Addresses feedback received from CRAN
* `DESCRIPTION` file fixes for spell check notes
* `roxygen2` examples updated

Version 0.1 (Released 2022-09-15)
==========================================================

### New Features

* Introduces `read_redcap_tidy()`, `bind_tables()`, `extract_table()`, and `extract_tables()` with documentation

----------------------------------------

GitHub Commits and Releases

* For a detailed change log, please see https://github.com/CHOP-CGTInformatics/REDCapTidieR/commits/main.
* For a list of the major releases, please see https://github.com/CHOP-CGTInformatics/REDCapTidieR/releases.
