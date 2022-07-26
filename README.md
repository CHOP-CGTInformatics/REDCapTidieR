
<!-- README.md is generated from README.Rmd. Please edit that file -->

# REDCapTidieR

<p align="center">

<img src="man/figures/REDCapTidieR.png" alt="drawing" width="150" align="right"/>

</p>
<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/CHOP-CGTDataOps/REDCapTidieR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/CHOP-CGTDataOps/REDCapTidieR/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

[REDCap](https://www.project-redcap.org/) is a powerful database
solution used by many research institutions:

> “REDCap is a secure web application for building and managing online
> surveys and databases. While REDCap can be used to collect virtually
> any type of data in any environment (including compliance with 21 CFR
> Part 11, FISMA, HIPAA, and GDPR), it is specifically geared to support
> online and offline data capture for research studies and operations.”

The [`REDCapR`](https://ouhscbbmc.github.io/REDCapR/) package
streamlines calls to the REDCap API. Its main use is to download records
from a REDCap project and present it to the analyst as a data frame.
This works well for simple projects, however becomes ugly when complex
databases that include longitudinal structure and/or repeated
instruments are involved.

The aim of `REDCapTidieR` is to make the life of analysts who deal with
these complex databases easier. It does so by building upon `REDCapR` to
make its output tidier. Instead of one large data frame, the analyst
gets to work with a set of tidy tibbles, one for each instrument.

## Installation

You can install the development version of `REDCapTidieR` like so:

``` r
devtools::install_github("CHOP-CGTDataOps/REDCapTidieR")
```

## Getting started

``` r
library(REDCapTidieR)
library(magrittr)
```

The two main functions of `REDCapTidieR` are `read_redcap_tidy()` and
`bind_tables()`. Here is how they can be used together to import all
data from a REDCap project and present them as tidy tibbles in the
global environment:

``` r
read_redcap_tidy(redcap_uri, token) %>% 
  bind_tables()
```

## Details

### Structure of the tibble returned by \`read_redcap_tidy\`

The `read_redcap_tidy` function returns a tibble in which each row
represents a REDCap instrument. The first column contains the instrument
name. The second column is a **list column** containing a tibble for
each instrument.

``` r
redcap_export <- read_redcap_tidy(redcap_uri, token)

redcap_export
#> # A tibble: 3 × 3
#>   redcap_form_name redcap_data      structure   
#>   <chr>            <list>           <chr>       
#> 1 repeated         <tibble [9 × 6]> repeating   
#> 2 nonrepeated      <tibble [8 × 5]> nonrepeating
#> 3 nonrepeated2     <tibble [3 × 5]> nonrepeating
```

REDCap databases support two main mechanisms to allow collecting the
same data multiple times: repeated instruments and longitudinal
projects.

The granularity of each table (i.e. what a single row represents)
depends on the structure of the database (classic, longitudinal with one
arm, longitudinal with multiple arms) as well as whether the instruments
are repeatable or not. Based on this, `REDCapTidieR` tibbles contain the
following columns to uniquely identify a specific row:

<table style="width:100%;">
<colgroup>
<col style="width: 17%" />
<col style="width: 25%" />
<col style="width: 28%" />
<col style="width: 28%" />
</colgroup>
<thead>
<tr class="header">
<th></th>
<th><strong>Classic</strong></th>
<th><strong>Longitudinal, one arm</strong></th>
<th><strong>Longitudinal, multi-arm</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><strong>Nonrepeated</strong></td>
<td><code>record_id</code></td>
<td><code>record_id</code> +<br />
<code>redcap_event</code></td>
<td><code>record_id</code> +<br />
<code>redcap_event</code> +<br />
<code>redcap_arm</code></td>
</tr>
<tr class="even">
<td><strong>Repeated</strong></td>
<td><code>record_id</code> +<br />
<code>redcap_repeat_instance</code></td>
<td><code>record_id</code> +<br />
<code>redcap_repeat_instance</code> +<br />
<code>redcap_event</code></td>
<td><code>record_id</code> +<br />
<code>redcap_repeat_instance</code> +<br />
<code>redcap_event</code> +<br />
<code>redcap_arm</code></td>
</tr>
</tbody>
</table>

For example, the `repeated` instrument in the example database we just
loaded is a repeated instrument from a multi-arm longitudinal project:

``` r
redcap_export$redcap_data[[1]]
#> # A tibble: 9 × 6
#>   record_id redcap_repeat_instance redcap_event redcap_arm repeat_1 repeat_2
#>       <dbl>                  <dbl> <chr>             <int> <chr>    <chr>   
#> 1         1                      1 event_1               1 1        2       
#> 2         1                      2 event_1               1 3        4       
#> 3         1                      3 event_1               1 5        6       
#> 4         1                      1 event_2               1 A        B       
#> 5         1                      2 event_2               1 C        D       
#> 6         3                      1 event_1               1 C        D       
#> 7         3                      1 event_2               1 E        F       
#> 8         3                      2 event_2               1 G        H       
#> 9         4                      1 event_3               2 R1       R2
```

### Binding REDCapTidieR tibbles into an environment

The `bind_tables()` function takes the output of `read_redcap_tidy`​,
extracts the individual tibbles and binds them to an environment. By
default, this is the global environment:

``` r
ls()
```

``` r
redcap_export %>%
  bind_tables()

ls()
#> [1] "redcap_export" "redcap_uri"    "token"
```

Note that there are now three additional tibbles in the global
environment.

## Getting help

If you encounter a bug, please file a minimal reproducible example on
[github](https://github.com/CHOP-CGTDataOps/REDCapTidieR/issues). For
questions and other discussion, please feel free to reach out to the
authors by email.
