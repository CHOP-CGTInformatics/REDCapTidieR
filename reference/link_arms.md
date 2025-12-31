# Link longitudinal REDCap instruments with their events/arms

For REDCap databases containing arms and events, it is necessary to
determine how these are linked and what variables belong to them.

## Usage

``` r
link_arms(redcap_uri, token, suppress_redcapr_messages = TRUE)
```

## Arguments

- redcap_uri:

  The REDCap URI

- token:

  The REDCap API token

- suppress_redcapr_messages:

  A logical to control whether to suppress messages from REDCapR API
  calls. Default `TRUE`.

## Value

Returns a `tibble` of `redcap_event_name`s with list elements containing
a vector of associated instruments.
