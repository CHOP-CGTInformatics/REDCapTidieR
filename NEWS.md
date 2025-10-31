# REDCapTidieR (development version)

### Bug Fixes

* Fixed a bug where `write_redcap_xlsx()` could fail on REDCap forms with long form labels (discovered and fix suggested by @pbchase)
* Fixed a bug where `read_redcap()` failed with `raw_or_label = "haven"` when a form contains no data (discovered by @mrkskk).

# REDCapTidieR 1.2.4

- Added an option in `combine_checkboxes()` to concatenate checkbox values when multiple are selected. (#225)
- Fixed links to the skimr package. (#227)

# REDCapTidieR 1.2.3

- Fixed a bug causing `read_redcap()` to incorrectly report categorical variables with data values that don't match any options in the metadata.
- Fixed a bug causing `read_redcap()` to fail with an unhelpful error when attempting to export DAG information for a user with insufficient DAG export privileges.

# REDCapTidieR 1.2.2

- Fixed a bug where, when using `raw_or_label = "label"` and requesting DAGs, only raw values for DAGs would be retrieved
- Adds variable labels for `form_complete_pct`, `event_name`, and `repeat_type` when `make_labelled()` is called

# REDCapTidieR 1.2.1

- For longitudinal REDCap projects, the `redcap_events` column has been updated to give REDCap event factor levels and order for the `redcap_event` and `event_name` columns
- Fixed a bug where `read_redcap()` would fail for projects containing a stand-alone record ID instrument

# REDCapTidieR 1.2.0

- Added `combine_checkboxes()` analytics function
   - Use `combine_checkboxes()` to consolidate multiple checkbox fields in a REDCap data tibble under a single column
- Added new article vignette "Using Labelled Vectors with REDCapTidieR"
- Fixed a bug for mixed structure databases resulting in data loss when some fields had dual repeating-separately/repeating-together behavior
- Fixed a bug where partial keys taken from REDCap arms could be incorrectly specified
- Various improvements and additions with CRAN release of REDCapR 1.2.0:
   - `event_name` added as a column to the `redcap_event` column of longitudinal supertibbles
   - `guess_max` parameter in `read_redcap()` default updated to `Inf` 

# REDCapTidieR 1.1.1

Version 1.1.1 (Released 2024-04-18)
==========================================================

- `read_redcap(raw_or_label = "haven")` now correctly casts categorical data values to character when their type is not character or numeric.


# REDCapTidieR 1.1.0

Version 1.1.0 (Released 2024-03-28)
==========================================================

- `read_redcap()` now supports instruments that follow a mixed repeating/non-repeating structure with the `allow_mixed_structure` parameter
- Mixed structure instruments (those with both repeating and nonrepeating elements) can be supported by setting `allow_mixed_structure` to `TRUE` or `getOption("redcaptidier.allow.mixed.structure", FALSE)`.
   - When allowed, nonrepeating elements of mixed structure instruments will be treated as repeating elements with a single instance.
- Missing data codes from REDCap additional customization settings are now handled. Non-logical values are converted to `NA` in `yesno`, `truefalse`, and `checkbox` fields with a warning. 
   - Warnings for MDCs can be silenced with `options(redcaptidier.allow.mdc = TRUE)`.
- `raw_or_label` now accepts `"haven"` as an option, converting categorical fields to `haven_labelled` vectors instead of factors.
- A new metadata column, `form_complete_pct`, is now available when viewing the supertibble showing the percentage of a given instrument that has a form status marked as "Complete" (green)
- Fixed a bug causing supertibble labels to not print correctly

Version 1.0.0 (Released 2023-11-28)
==========================================================

This package has been considered stable for months now with no new issues reported, and so should be reflected in the major version number.

## Minor Updates

- Updated `openxlsx2` API calls to coincide with v1.0
- Internal cleaning and tidying of documentation
- `pkgdown` site updates
- Migration of some vignettes over to articles

Version 0.4.1 (Released 2023-08-15)
==========================================================

## Miscellaneous

* Updated test suite to be compatible with REDCapR 1.2.0

Version 0.4.0 (Released 2023-06-02)
==========================================================

## New Features

* Introduces new functions `add_skimr_metadata()` and `write_redcap_xlsx()` with supporting documentation
* `read_redcap()` now supports Data Access Groups (DAGs)
   * New argument available to `read_redcap()`: `export_data_access_groups`

## Bug Fixes

* Fixed a bug where REDCapR API error messages weren't being returned from REDCapTidieR

## Miscellaneous

* All deprecated functions have been officially retired and removed from the package

Version 0.3.0 (Released 2023-03-17)
==========================================================

## New Features

* `read_redcap()` now supports projects with repeating events which introduced a **breaking change** to data tibble column names
  * `redcap_repeat_instance` is now `redcap_form_instance`
  * `redcap_event_instance` has been added to denote repeating events

## Performance Improvements and Enhancements

* Improved error message suite:
  * Helpful error message provided for various conditions related to REDCap API calls
  * Helpful error messages added for checks across all exported functions
  * Unexpected error messages provided with direction to submitting bug reports
    * Improved error messages for label parsing
  * Added `select_choices_and_calculations` exported by the REDCap API to `redcap_metadata` tibble
* Improved process for adding/updating `httptest` mocks

## Bug Fixes

* Fixed a bug where the `suppress_redcapr_messages` argument for `read_redcap()` was not working appropriately
* Fixed a bug where `read_redcap()` would fail when `select_choices_and_calculations` was missing whitespace after commas (discovered by @camcaan)
* Fixed a bug where `read_redcap()` would fail for projects with a multiple choice field having duplicate values with the same label
  * Added a warning when REDCapTidieR detects this
* Fixed a bug where empty rows would appear in data tibbles in longitudinal REDCap exports for events containing a mix of empty and filled forms
* Fixed a bug where the `forms` specification in `read_redcap()` may lead to incorrect removal of data for databases with repeating events

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
