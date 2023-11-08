---
title: 'REDCapTidieR: Extracting complex REDCap databases into tidy tables'
tags:
  - R
  - REDCap
  - data management
authors:
  - name: Richard Hanna
    orcid: 0009-0005-6496-8154
    equal-contrib: true
    affiliation: "1"
  - name: Ezra Porter
    orcid: 0000-0002-4690-8343
    equal-contrib: true
    affiliation: "1"
  - name: Stephany Romero
    equal-contrib: true
    affiliation: "1"
  - name: Paul Wildenhain
    equal-contrib: true 
    affiliation: "6"
  - name: Wiliam Beasley
    orcid: 0000-0002-5613-5006
    equal-contrib: true
    affiliation: "7"
  - name: Stephan Kadauke
    orcid: 0000-0003-2996-8034
    equal-contrib: true
    affiliation: "1, 2, 3, 4, 5"
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

Capturing and storing electronic data is integral in the research world, yet often becomes a burden to the researchers themselves. [REDCap](https://www.project-redcap.org/) [@Harris2009; @Harris2019] alleviates this problem by offering a secure web application that lets users build databases and surveys with a robust front-end interface that can support data of any type, including data requiring compliance with standards for protected information.

For many researchers who use REDCap, the R language [@r_citation] is a powerful tool for extracting and analyzing their data. To take advantage of REDCap's REST API, the [`REDCapR`](https://cran.r-project.org/web/packages/REDCapR/index.html) and [`redcapAPI`](https://cran.r-project.org/web/packages/redcapAPI/index.html) packages allow R users to extract data directly into their programming environment. The default extraction structure for a given REDCap database is referred to as the "Block Matrix," and is a singular, unwieldy, and "untidy" data table. The concept of "[tidy data](https://www.jstatsoft.org/article/view/v059i10)" [@Wickham2014] describes a framework for standard mapping and structuring of data where each variable forms a column, each observation forms a row, and each type of observational unit forms a table. Fundamentally, the Block Matrix breaks these tidy principles by obscuring the primary keys that identify individual records, leaving and analysts with the arduous task of reformatting the matrix for usability.

To address these challenges, we developed `REDCapTidieR` as an open source R package that transforms the standard REDCap output into a format that adheres to tidy data principles. `REDCapTidieR` has the potential to save organizations and research staff immeasurable amounts of time, allowing them to quickly query their data without the need for intricate data parsing processes.

# Statement of Need

As of 2023, the REDCap Consortium boasts nearly 3 million users across over 150 countries. REDCap databases exhibit significant variation in complexity, ranging from simple tables with easily identifiable records to more challenging scenarios where pinpointing a unique identifier is harder. This complexity often arises from the introduction of "repeating instruments" and "repeating events." For an in-depth exploration of this concept, refer to the [`REDCapTidieR` documentation](https://chop-cgtinformatics.github.io/REDCapTidieR/articles/diving_deeper.html#longitudinal-redcap-projects). Fundamentally, repeating events and instruments support studies like clinical trials, where subjects may have distinct timelines with varying levels of record granularity. This is where the flattening of the database into the Block Matrix becomes a pain point for analysts.

While there are a few existing REDCap tools for R documented by [`REDCap-tools`](https://redcap-tools.github.io/projects/), `REDCapTidieR` occupies a unique space by providing analysts with an opinionated framework that quickly prepares them for data analysis. Although some of the aforementioned tools also offer functions for data processing, such as the [`tidyREDCap`](https://raymondbalise.github.io/tidyREDCap/) and [`REDCapDM`](https://ubidi.github.io/REDCapDM/index.html) packages, `REDCapTidieR` is unique in how it restructures the Block Matrix into a format that is easily interpretable within the user's programmatic environment. Of the tools available, `REDCapTidieR` is the only one that fundamentally restructures the Block Matrix in its entirety.

| Package     | Data Export Support | Data Import Support | Data Manipulation | Data Tidying |
|-------------|--------------------|--------------------|------------------|--------------|
| redcapAPI   | x                  | x                  |                  |              |
| REDCapR     | x                  | x                  |                  |              |
| tidyREDCap  | x                  |                    | x                |              |
| REDCapDM    | x                  |                    | x                |              |
| REDCapTidieR| x                  |                    | x                | x            |

# Design

Transformation of the Block Matrix into a friendlier structure is carried out by `REDCapTidieR` through a series of complex operations that result in the "supertibble." The supertibble, named after the [`tibble` package](https://tibble.tidyverse.org/), is presented as a table where each row corresponds to a REDCap instrument and each column corresponds to either that instrument's post-processed data, metadata, or useful information about that instrument itself. Below, we offer a conceptual model of how `REDCapTidieR` transforms the Block Matrix into the supertibble:

> Image to be provided

# Installation

`REDCapTidieR` is available on [GitHub](https://github.com/CHOP-CGTInformatics/REDCapTidieR) and [CRAN](https://cran.r-project.org/web/packages/REDCapTidieR/index.html) and has been tested for functionality on all major operating systems.

# Acknowledgements

# Conflict of interest

This package was developed by the [Children’s Hospital of
Philadelphia](https://www.chop.edu) Cell and Gene Therapy Informatics
Team to support the needs of the [Cellular Therapy and Transplant
Section](https://www.chop.edu/centers-programs/cellular-therapy-and-transplant-section).
The development was funded using the following sources:

- *Stephan Kadauke Start-up funds.* Stephan Kadauke, PI, CHOP, 2018-2024

- *CHOP-based GMP cell manufacturing (MFG) for CAR T clinical trials*.
  Stephan Grupp, PI; Stephan Kadauke, co-PI, CHOP, 2021-2023