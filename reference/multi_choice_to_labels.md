# Update multiple choice fields with label data

Update REDCap variables with multi-choice types to standard form labels
taken from REDCap metadata.

## Usage

``` r
multi_choice_to_labels(
  db_data,
  db_metadata,
  raw_or_label = "label",
  call = caller_env()
)
```

## Arguments

- db_data:

  A REDCap database object

- db_metadata:

  A REDCap metadata object

- raw_or_label:

  A string (either 'raw', 'label', or 'haven') that specifies whether to
  export the raw coded values or the labels for the options of
  categorical fields. Default is 'label'. If 'haven' is supplied,
  categorical fields are converted to `haven_labelled` vectors.

- call:

  call for conditions

## Details

Coerce variables of `field_type` "truefalse", "yesno", and "checkbox" to
logical. Introduce `form_status_complete` column and append to end of
`tibble` outputs. Ensure `field_type`s "dropdown" and "radio" are
converted appropriately since label appendings are important and unique
to these.
