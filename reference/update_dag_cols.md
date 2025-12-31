# Implement REDCapR DAG Data into Supertibble

This helper function uses output from
[REDCapR::redcap_dag_read](https://ouhscbbmc.github.io/REDCapR/reference/redcap_dag_read.html)
and applies the necessary raw/label values to the
`redcap_data_access_group` column.

This is done because REDCapTidieR retrieves raw data by default, then
merges labels from the metadata. However, some columns like
`redcap_data_access_group` are not in the metadata and so there is
nothing by default to reference.

## Usage

``` r
update_dag_cols(data, dag_data, raw_or_label)
```

## Arguments

- data:

  the REDCap data

- dag_data:

  a DAG dataset exported from
  [REDCapR::redcap_dag_read](https://ouhscbbmc.github.io/REDCapR/reference/redcap_dag_read.html)

- raw_or_label:

  A string (either 'raw', 'label', or 'haven') that specifies whether to
  export the raw coded values or the labels for the options of
  categorical fields. Default is 'label'. If 'haven' is supplied,
  categorical fields are converted to `haven_labelled` vectors.
