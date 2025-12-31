# Supplement a supertibble with additional metadata fields

Supplement a supertibble with additional metadata fields

## Usage

``` r
add_metadata(
  supertbl,
  db_metadata,
  redcap_uri,
  token,
  suppress_redcapr_messages
)
```

## Arguments

- supertbl:

  a supertibble object to supplement with metadata

- db_metadata:

  a REDCap metadata tibble

- redcap_uri:

  The URI/URL of the REDCap server (e.g.,
  "https://server.org/apps/redcap/api/"). Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- suppress_redcapr_messages:

  A logical to control whether to suppress messages from REDCapR API
  calls. Default `TRUE`.

## Value

The original supertibble with additional fields:

- `instrument_label` containing labels for each instrument

- `redcap_metadata` containing metadata for the fields in each
  instrument as a list column

## Details

This function assumes that `db_metadata` has been processed to include a
row for each option of each multiselection field, i.e. with
[`update_field_names()`](https://chop-cgtinformatics.github.io/REDCapTidieR/reference/update_field_names.md)
