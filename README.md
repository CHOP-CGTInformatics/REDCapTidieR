
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
streamlines calls to the REDCap API. A common use for `REDCapR` is to
download records from a REDCap project and present it to the analyst as
a data frame. This works well for simple projects, however becomes ugly
when complex databases that include a longitudinal structure and/or
repeated instruments are involved.

The aim of `REDCapTidieR` is to make the life of analysts who deal with
these complex databases easier. It does so by building upon `REDCapR` to
make its output tidier. Instead of one large data frame, the analyst
gets to work with a set of tidy tibbles, one for each REDCap instrument.

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
data from a REDCap project and add a set of tidy tibbles in the global
environment:

``` r
read_redcap_tidy(redcap_uri, token) %>% 
  bind_tables()
```

## Details

### Structure of the tibble returned by `read_redcap_tidy`

The `read_redcap_tidy` function returns a tibble in which each row
represents a REDCap instrument. The first column (`redcap_form_name`)
contains the instrument name. The second column (`redcap_data`) is a
[**list
column**](https://www.rstudio.com/resources/webinars/how-to-work-with-list-columns/)
containing a tibble for each instrument.

``` r
superheroes_data <- read_redcap_tidy(redcap_uri, token)

superheroes_data
#> # A tibble: 2 × 3
#>   redcap_form_name   redcap_data          structure   
#>   <chr>              <list>               <chr>       
#> 1 super_hero_powers  <tibble [5,966 × 3]> repeating   
#> 2 heroes_information <tibble [734 × 11]>  nonrepeating
```

In the above example, you can see that there is data from two
instruments, `super_hero_powers` and `heroes_information`. From the
`structure` column, you can see that the `super_hero_powers` instrument
is *repeating* and the `heroes_information` instrument is
*nonrepeating*.

Let’s take a look at `heroes_information`:

``` r
heroes_information <- superheroes_data$redcap_data[[2]]

heroes_information
#> # A tibble: 734 × 11
#>    record_id name     gender eye_c…¹ race  hair_…² height weight publi…³ skin_…⁴
#>        <dbl> <chr>    <chr>  <chr>   <chr> <chr>    <dbl>  <dbl> <chr>   <chr>  
#>  1         0 A-Bomb   Male   yellow  Human No Hair    203    441 Marvel… -      
#>  2         1 Abe Sap… Male   blue    Icth… No Hair    191     65 Dark H… blue   
#>  3         2 Abin Sur Male   blue    Unga… No Hair    185     90 DC Com… red    
#>  4         3 Abomina… Male   green   Huma… No Hair    203    441 Marvel… -      
#>  5         4 Abraxas  Male   blue    Cosm… Black      -99    -99 Marvel… -      
#>  6         5 Absorbi… Male   blue    Human No Hair    193    122 Marvel… -      
#>  7         6 Adam Mo… Male   blue    -     Blond      -99    -99 NBC - … -      
#>  8         7 Adam St… Male   blue    Human Blond      185     88 DC Com… -      
#>  9         8 Agent 13 Female blue    -     Blond      173     61 Marvel… -      
#> 10         9 Agent B… Male   brown   Human Brown      178     81 Marvel… -      
#> # … with 724 more rows, 1 more variable: alignment <chr>, and abbreviated
#> #   variable names ¹​eye_color, ²​hair_color, ³​publisher, ⁴​skin_color
#> # ℹ Use `print(n = ...)` to see more rows, and `colnames()` to see all variable names
```

### Binding REDCapTidieR tibbles into an environment

Above, we manually extracted the `heroes_information` tibble from the
output of `read_redcap_tidy()`​. This approach can become tedious when
the REDCap project has lots of instruments, and there are many tibbles
to extract.

The `bind_tables()` function takes the output of `read_redcap_tidy()`​,
extracts the individual tibbles, and binds them to an
[environment](http://adv-r.had.co.nz/Environments.html). By default,
this is the global environment:

``` r
ls.str(envir = globalenv())
```

``` r
superheroes_data %>%
  bind_tables()
```

``` r
ls.str(envir = globalenv())
#> heroes_information : tibble [734 × 11] (S3: tbl_df/tbl/data.frame)
#> super_hero_powers : tibble [5,966 × 3] (S3: tbl_df/tbl/data.frame)
```

Note that there are now two additional tibbles in the environment.

## Getting help

If you encounter a bug, please file a minimal reproducible example on
[github](https://github.com/CHOP-CGTDataOps/REDCapTidieR/issues). For
questions and other discussion, please feel free to reach out to the
authors by email.
