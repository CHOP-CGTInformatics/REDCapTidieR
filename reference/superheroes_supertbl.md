# Superheroes Data

A dataset of superheroes in a REDCapTidieR `supertbl` object

## Usage

``` r
superheroes_supertbl
```

## Format

### `heroes_information`

A `tibble` with 734 rows and 12 columns:

- record_id:

  REDCap record ID

- name:

  Hero name

- gender:

  Gender

- eye_color:

  Eye color

- race:

  Race

- hair_color:

  Hair color

- height:

  Height

- weight:

  Weight

- publisher:

  Publisher

- skin_color:

  Skin color

- alignment:

  Alignment

- form_status_complete:

  REDCap instrument completed?

### `super_hero_powers`

A `tibble` with 5,966 rows and 4 columns:

- record_id:

  REDCap record ID

- redcap_form_instance:

  REDCap repeat instance

- power:

  Super power

- form_status_complete:

  REDCap instrument completed?

## Source

<https://www.superherodb.com/>
