# Package index

## Import Data

Import a REDCap Database into a tidy supertibble.

- [`read_redcap()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/read_redcap.md)
  : Import a REDCap database into a tidy supertibble

## Extract Data Tibbles

Extract individual data tibbles from a supertibble.

- [`bind_tibbles()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/bind_tibbles.md)
  : Extract data tibbles from a REDCapTidieR supertibble and bind them
  to an environment
- [`extract_tibble()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/extract_tibble.md)
  : Extract a single data tibble from a REDCapTidieR supertibble
- [`extract_tibbles()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/extract_tibbles.md)
  : Extract data tibbles from a REDCapTidieR supertibble into a list

## Apply Variable Labels

Apply variable labels to a supertibble using `labelled`.

- [`make_labelled()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/make_labelled.md)
  : Apply variable labels to a REDCapTidieR supertibble
- [`fmt_strip_whitespace()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/format-helpers.md)
  [`fmt_strip_trailing_colon()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/format-helpers.md)
  [`fmt_strip_trailing_punct()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/format-helpers.md)
  [`fmt_strip_html()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/format-helpers.md)
  [`fmt_strip_field_embedding()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/format-helpers.md)
  : Format REDCap variable labels

## Add Helpful Metadata Metrics

Add skimr metrics to metadata list elements of a supertibble.

- [`add_skimr_metadata()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/add_skimr_metadata.md)
  :

  Add [skimr::skim](https://docs.ropensci.org/skimr/reference/skim.html)
  metrics to a supertibble's metadata

## Export to Other Formats

Export a supertibble to other usable formats.

- [`write_redcap_xlsx()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/write_redcap_xlsx.md)
  : Write Supertibbles to XLSX

## Supertibble Post-Processing

Helpful functions for supertibble data analytics.

- [`combine_checkboxes()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/combine_checkboxes.md)
  : Combine Checkbox Fields into a Single Column

## Data

- [`superheroes_supertbl`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/superheroes_supertbl.md)
  : Superheroes Data

## S3 methods

- [`tbl_sum(`*`<redcap_supertbl>`*`)`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/tbl_sum.redcap_supertbl.md)
  : Provide a succinct summary of an object
- [`vec_ptype_abbr(`*`<redcap_supertbl>`*`)`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/vec_ptype_abbr.redcap_supertbl.md)
  : Vector type as a string
