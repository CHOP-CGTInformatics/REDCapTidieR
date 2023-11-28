---
title: 'REDCapTidieR: Extracting complex REDCap databases into tidy tables'
tags:
  - R
  - REDCap
  - data management
authors:
  - name: Richard Hanna
    orcid: 0009-0005-6496-8154
    equal-contrib: false
    affiliation: "1"
  - name: Ezra Porter
    orcid: 0000-0002-4690-8343
    equal-contrib: false
    affiliation: "1"
  - name: Stephany Romero
    equal-contrib: false
    affiliation: "1"
  - name: Paul Wildenhain
    equal-contrib: false 
    affiliation: "6"
  - name: William Beasley
    orcid: 0000-0002-5613-5006
    equal-contrib: false
    affiliation: "7"
  - name: Stephan Kadauke
    orcid: 0000-0003-2996-8034
    equal-contrib: false
    affiliation: "2, 3, 4, 5"
affiliations:
 - name: Division of Oncology, Children's Hospital of Philadelphia, Philadelphia, Pennsylvania
   index: 1
 - name: Department of Biomedical and Health Informatics, Children's Hospital of Philadelphia, Philadelphia, Pennsylvania
   index: 2
 - name: Department of Pathology and Laboratory Medicine, Perelman School of Medicine at the University of Pennsylvania, Philadelphia, Pennsylvania
   index: 3
 - name: Division of Transfusion Medicine, Children's Hospital of Philadelphia, Pennsylvania
   index: 4
 - name: Division of Pathology Informatics, Children's Hospital of Philadelphia, Pennsylvania
   index: 5
 - name: Division of Pediatrics, Children's Hospital of Philadelphia, Philadelphia, Pennsylvania
   index: 6
 - name: Department of Pediatrics, The University of Oklahoma Health Sciences Center, College of Medicine, Oklahoma City, Oklahoma, USA
 - index: 7
date: XX November 2023
bibliography: paper.bib
---

# Summary

Capturing and storing electronic data is integral in the research world. [REDCap](https://www.project-redcap.org/) [@Harris2009; @Harris2019] offers a secure web application that lets users build databases and surveys with a robust front-end interface that can support data of any type, including data requiring compliance with standards for protected information.

Many REDCap users use the R programming language [@r_cit] to extract and analyze their data. The [`REDCapR`](https://cran.r-project.org/web/packages/REDCapR/index.html) [@redcapr_cit] and [`redcapAPI`](https://cran.r-project.org/web/packages/redcapAPI/index.html) [@redcapapi_cit] packages allow R users to extract data directly into their programming environment. While this works well for simple REDCap databases, it becomes cumbersome for complex databases, because the REDCap API outputs a "block matrix"--a single table with varied granularity levels, which conflicts with the "tidy data" framework [@Wickham2014] that advocates for standardized data organization.

To address this, we introduce `REDCapTidieR`, an open-source package that streamlines data extraction and restructures it into an intuitive format compatible with the tidy data principles. This facilitates seamless data analysis in R, especially for complex longitudinal studies.

While there are several tools available for REDCap data management, REDCapTidieR introduces a unique solution by transforming the challenging block matrix into a standardized tidy data structure that we term the "supertibble". This approach not only aligns with good data science practice but also caters to databases of any complexity. By providing a suite of utility functions to work with the supertibble, REDCapTidieR provides a complete framework for extracting REDCap data designed with user-friendliness at its core.

# Statement of Need

As of 2023, the REDCap Consortium boasts nearly 3 million users across over 150 countries. REDCap databases range from single-instrument projects to complex builds that use both repeating instruments and repeating events. These data structures are needed to capture multiple items related to a specific visit, such as concomitant medications, or events that cannot be planned ahead of time, such as adverse events.

REDCap databases that contain repeating events and instruments require significant manual pre-processing, a major pain point for researchers and analysts. This is because the REDCap API returns a single table (Figure 1) that includes data from instruments that record data at different levels of granularity.

While there are a few existing REDCap tools (Table 1), `REDCapTidieR` occupies a unique space by providing analysts with a framework returns a tidy data structure regardless of the size or complexity of the extracted database. Although some of these tools also offer functions for data processing, such as the [`tidyREDCap`](https://raymondbalise.github.io/tidyREDCap/) [@tidyredcap_cit] and [`REDCapDM`](https://ubidi.github.io/REDCapDM/index.html) [@redcapdm_cit] packages, only `REDCapTidieR` restructures the block matrix into an easy to use format.

`REDCapTidieR` is built with production readiness in mind. In addition to an extensive 98% coverage test suite, `REDCapTidieR` execution is evaluated against 15 test databases that cover many complex configuration scenarios. It also provides ample documentation through a `pkgdown` [site](https://chop-cgtinformatics.github.io/REDCapTidieR/index.html) [@redcaptidier_pkgdown_cit]. It is also built on top of `REDCapR`, which contains its own extensive test suite, and evaluated against an additional 26 test databases. `REDCapTidieR` meets the rigorous requirements of the [OpenSSF Best Practices Badge](https://www.bestpractices.dev/en/projects/6845) [@openssf_cit], which certifies open-source projects that adhere to criteria for delivering high-quality, robust, and secure software.

| Package     | Exports from REDCap | Imports into REDCap | Tidy Reformatting | Extensive Test Suite |
|-------------|:-------------------:|:-------------------:|:-----------------:|:--------------------:|
| redcapAPI   | x                   | x                   |                   | x                    |
| REDCapR     | x                   | x                   |                   | x                    |
| tidyREDCap  | x                   |                     |                   |                      |
| REDCapDM    | x                   |                     |                   |                      |
| REDCapTidieR| x                   |                     | x                 | x                    |

Table 1: Comparative breakdown of the landscape for REDCap tools in R.

# Design

The `REDCapTidieR::read_redcap()` function leverages `REDCapR` to make API calls to query the data and metadata of a REDCap project and returns the supertibble (Figure 1). The supertibble, named after the [`tibble` package](https://tibble.tidyverse.org/) [@tibble_cit], is an alternative presentation of the data in which multiple tables are linked together in a single object in a fashion consistent with tidy data principles.

![The REDCapTidieR Supertibble](images/Figure1.png)

Figure 1: The REDCapTidieR supertibble shown in the Data Viewer of the RStudio IDE. The "Superhero database" [@superheroes_cit] contains two instruments, one nonrepeating and one repeating. A. The REDCap API outputs a "Block Matrix". Note an abundance of `NA` values, which do not represent missing values but rather fields that do not apply due to the data structure. B. The `read_redcap()` function returns a "Supertibble". Note that each row represents one instrument, identified by the `redcap_form_name` column. The `redcap_data` column is a list column that links to tibbles containing the data from a specific instrument. The Data Viewer allows drilling down into individual tibbles by clicking on the table icon, allowing for rapid and intuitive data exploration without any preprocessing. Since each instrument has a consistent granularity, these tibbles can be tidy. Two data tibbles are shown, one from a nonrepeating and one from a repeating instrument. Note the differences in granularity between the instruments.

`REDCapTidieR` provides utility functions to work with the supertibble, all designed to work with the R pipe operator `|>`. The `extract_tibble()` function takes a supertibble object and returns a specific data tibble. The `make_labelled()` function leverages the `labelled` package [@labelled_cit] to apply variable labels to the supertibble. The `add_skimr_metadata()` function uses the `skimr` package [@skimr_cit] to add summary statistics. Using the `write_redcap_xlsx()` function, which leverages the `openxlsx2` [@openxlsx2_cit] package, users can easily export an the supertibble into a collaborator-friendly Excel document, in which each Excel sheet contains the data for an instrument.

`REDCapTidieR` cannot be used to write data to a REDCap project. We refer the reader to an excellent guide of how to accomplish this using `REDCapR` [@redcapr_write_cit].

# Installation

`REDCapTidieR` is available on [GitHub](https://github.com/CHOP-CGTInformatics/REDCapTidieR) and [CRAN](https://cran.r-project.org/web/packages/REDCapTidieR/index.html) and works on all major operating systems.

# Acknowledgements

We would like to thank Will Beasley, Paul Wildenhain, and Jan Marvin for their feedback and support in development.

This package was developed by the [Cell and Gene Therapy Informatics Team](https://www.chop.edu/centers-programs/cell-and-gene-therapy-informatics-team/our-team) of the [Children’s Hospital of Philadelphia](https://www.chop.edu).

# Conflict of interest

The authors declare no financial conflicts of interest.

# References
