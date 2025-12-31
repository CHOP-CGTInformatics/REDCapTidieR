# Determine fields included in `REDCapR::redcap_read_oneshot` output that should be dropped from results of `read_redcap`

Determine fields included in
[`REDCapR::redcap_read_oneshot`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.html)
output that should be dropped from results of `read_redcap`

## Usage

``` r
get_fields_to_drop(db_metadata, form)
```

## Arguments

- db_metadata:

  metadata tibble created by
  [`REDCapR::redcap_metadata_read`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_metadata_read.html)

- form:

  the name of the instrument containing identifiers

## Value

A character vector of extra field names that can be used to filter the
results of
[`REDCapR::redcap_read_oneshot`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.html)

## Details

This function applies rules to determine which fields are included in
the results of
[`REDCapR::redcap_read_oneshot`](https://ouhscbbmc.github.io/REDCapR/reference/redcap_read_oneshot.html)
because the user didn't request the instrument containing identifiers
