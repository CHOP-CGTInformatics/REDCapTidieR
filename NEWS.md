# Release History

* [CRAN Archive of Older Versions](https://cran.r-project.org/src/contrib/Archive/REDCapTidieR/)
* [Current and Previous GitHub Issues](https://github.com/CHOP-CGTInformatics/REDCapTidieR/issues)
* [Current `REDCapTidieR` Documentation](https://chop-cgtinformatics.github.io/REDCapTidieR/)

# Upcoming Changes in v0.2.0

### New Features

* Instrument/form-level metadata included in supertibble output:
  * `redcap_form_label`: The instrument’s human-readable label
  * `redcap_metadata`: REDCap metadata associated with the instrument (derived from `REDCapR::redcap_metadata_read`)
  * `redcap_events`: Events and arms associated with this instrument (for longitudinal projects only)
  * `data_rows`, `data_cols`: Row and column counts of `redcap_data`
  * `data_size`: Size of the redcap_data tibble in memory
  * `data_na_pct`: The percentage of missing data in the corresponding redcap_data
* New `make_labelled()` function allowing for descriptive labelling application to variables via the [`labelled`](https://larmarange.github.io/labelled/) package
* New arguments available for `read_redcap_tidy` capabilities:
  * `forms`: Allows for `forms` specification during API calls instead of defaulting to full database downloads
  * `export_survey_fields`: Allows for export of `[instrument_name]_timestamp` and `redcap_survey_identifier` fields related to survey-enabled REDCap databases (`TRUE` by default)

### Performance Improvements and Enhancements

* Improved execution time by >2.5X by optimizing internal functions `check_repeat_and_nonrepeat`, `distill_*_table_long`, and `multi_choice_to_labels`
* All warnings and error messages are now produced using `cli`
* Tests and vignettes now use `httptest` to mock and cache REDCap API calls
* Replaced deprecated `.data` pronoun in `tidyselect` expressions

### Bug Fixes

* Fixed a bug in which similarly named variables could be duplicated under some circumstances
* Order of instruments in the supertibble is now the same as the order of instruments in REDCap
* Fixed an issue in which `extract_*` functions under some circumstances returned `NULL` instead of the expected tibbles

# REDCapTidieR 0.1.3

Version 0.1.3 (Released 2022-10-03)
==========================================================

### Documentation Updates

* Fixed a bug where `clean_redcap` may not correctly assign variables across instruments to their appropriate tables in cases of similar prefixes
* Minor changes applied to documentation, including`README` and `DESCRIPTION` files

# REDCapTidieR 0.1.2

Version 0.1.2 (Released 2022-09-20)
==========================================================

### Documentation Updates

* Addresses feedback received from CRAN
* `DESCRIPTION` file fixes for undirected quotation marks (e.g. `REDCap` to 'REDCap')
* Fix quotations in `@examples` tags for `bind_tables` and `extract_table`
* Update `pkgdown` site

# REDCapTidieR 0.1.1

Version 0.1.1 (Released 2022-09-19)
==========================================================

### Documentation Updates

* Addresses feedback received from CRAN
* `DESCRIPTION` file fixes for spell check notes
* `roxygen2` examples updated

# REDCapTidieR 0.1.0

Version 0.1 (Released 2022-09-15)
==========================================================

### New Features

* Introduces `read_redcap_tidy()`, `bind_tables()`, `extract_table()`, and `extract_tables()` with documentation

----------------------------------------

GitHub Commits and Releases

* For a detailed change log, please see https://github.com/CHOP-CGTInformatics/REDCapTidieR/commits/main.
* For a list of the major releases, please see https://github.com/CHOP-CGTInformatics/REDCapTidieR/releases.
