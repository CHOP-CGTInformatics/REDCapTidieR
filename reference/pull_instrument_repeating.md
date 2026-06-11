# Retrieve repeating instrument settings from REDCap

Retrieve repeating instrument settings from REDCap

## Usage

``` r
pull_instrument_repeating(
  redcap_uri,
  token,
  suppress_redcapr_messages = TRUE,
  call = NULL
)
```

## Arguments

- redcap_uri:

  The URI/URL of the REDCap server (e.g.,
  "https://server.org/apps/redcap/api/"). Required.

- token:

  The user-specific string that serves as the password for a project.
  Required.

- suppress_redcapr_messages:

  A logical to control whether to suppress messages from REDCapR API
  calls. Default `TRUE`.

- call:

  The calling environment to use when handling REDCapR errors. Default
  `NULL`.

## Value

A tibble of repeating instrument settings with standardized column
names, including `unique_event_name` and `form` when available.
