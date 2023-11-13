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

For many researchers who use REDCap, the R language [@r_citation] is a powerful tool for extracting and analyzing their data. To take advantage of REDCap's REST API, the [`REDCapR`](https://cran.r-project.org/web/packages/REDCapR/index.html) [@redcapr_cit] and [`redcapAPI`](https://cran.r-project.org/web/packages/redcapAPI/index.html) [@redcapapi_cit] packages allow R users to extract data directly into their programming environment. The default extraction structure for a given REDCap database is referred to as the "block matrix," and is a singular, unwieldy, and "untidy" data table. The concept of "[tidy data](https://www.jstatsoft.org/article/view/v059i10)" [@Wickham2014] describes a framework for standard mapping and structuring of data where each variable forms a column, each observation forms a row, and each type of observational unit forms a table. Fundamentally, the block matrix breaks these tidy principles by obscuring the primary keys that identify individual records, leaving analysts with the arduous task of reformatting the matrix for usability.

To address these challenges, we developed `REDCapTidieR` as an open source R package that transforms the standard REDCap output into a format that adheres to tidy data principles. `REDCapTidieR` has the potential to save organizations and research staff immeasurable amounts of time, allowing them to quickly query their data without the need for intricate data parsing processes.

# Statement of Need

As of 2023, the REDCap Consortium boasts nearly 3 million users across over 150 countries. REDCap databases exhibit significant variation in complexity, ranging from simple tables with easily identifiable records to more challenging scenarios where pinpointing a unique identifier is harder. This complexity often arises in databases that make use of "repeating instruments" and "repeating events." For an in-depth exploration of this concept, refer to the [`REDCapTidieR` documentation](https://chop-cgtinformatics.github.io/REDCapTidieR/articles/diving_deeper.html#longitudinal-redcap-projects). Fundamentally, repeating events and instruments support longitudinal studies, where subjects may have distinct timelines with varying levels of record granularity. This is where the flattening of the database into the block matrix becomes a pain point for analysts.

While there are a few existing REDCap tools for R documented by [`REDCap-tools`](https://redcap-tools.github.io/projects/), `REDCapTidieR` occupies a unique space by providing analysts with an opinionated framework that quickly prepares them for data analysis. Although some of the aforementioned tools also offer functions for data processing, such as the [`tidyREDCap`](https://raymondbalise.github.io/tidyREDCap/) and [`REDCapDM`](https://ubidi.github.io/REDCapDM/index.html) packages, `REDCapTidieR` is unique in how it restructures the block matrix into a format that is easily interpretable within the user's programmatic environment. Of the tools available, `REDCapTidieR` is the only one that fundamentally restructures the block matrix in its entirety.

REDCapTidieR was developed with deployment in production environments as a key consideration. To ensure the utmost confidence in the handling of user data, we've implemented an extensive test suite that exhibits 98% code coverage, as of the package's version 1.0 release. Ample documentation is accessible through a collection of package vignettes and articles, offering detailed insights into the opinionated framework, design structure, and a comprehensive glossary of terms associated with the REDCapTidieR package. These considerations have earned the package an [OpenSSF Best Practices certification](https://www.bestpractices.dev/en/projects/6845) [@openssf_cit], which certifies open source projects that meet stringent criteria for delivering high-quality and secure software.

| Package     | Data Export Support | Data Import Support | Data Manipulation | Data Tidying | Production Capability |
|-------------|---------------------|---------------------|-------------------|--------------| --------------------- |
| redcapAPI   | x                   | x                   |                   |              |                       |
| REDCapR     | x                   | x                   |                   |              | x                     |
| tidyREDCap  | x                   |                     | x                 |              |                       |
| REDCapDM    | x                   |                     | x                 |              |                       |
| REDCapTidieR| x                   |                     | x                 | x            | x                     |

Table 1: Comparative breakdown of the landscape for REDCap tools in R.

# Design

Transformation of the block matrix into a friendlier structure is carried out by `REDCapTidieR` through a series of complex operations that result in the "supertibble." The supertibble, named after the [`tibble` package](https://tibble.tidyverse.org/), is presented as a table where each row corresponds to a REDCap instrument and each column corresponds to either that instrument's post-processed data (a "data tibble"), metadata, or useful information about that instrument itself.

Unlike the block matrix, which combines all columns for record identification into one table, `REDCapTidieR` separates instruments so that only the variables necessary for identification of a record within the instrument are included in each data tibble. Below we provide a sample model that compares the standard output from a REDCap database with non-repeating and repeating instruments to one post-processed through `REDCapTidieR`.

![Conceptual Model](/paper/images/REDCapTidieR%20JOSS.png)
Figure 1: Comparative model showing REDCap API export formats between the default behavior and `REDCapTidieR`.

In this example, the supertibble displays three REDCap database instruments, with one repeating and two non-repeating. Below, one of each of these instrument types is expanded to show how `REDCapTidieR` separates these instruments into their own tabular list elements structured with only the identifiers necessary to pinpoint a specific record. This format makes tables easily joinable by analysts for whatever operations they may need later in their work.

Additionally, REDCapTidieR comes equipped with features that address common requirements of analysts. Seamless integration with the `labelled` [@labelled_cit] package facilitates effortless application of variable labels to both data and metadata. An extension utilizing the `skimr` [@skimr_cit] package provides comprehensive metric summaries of metadata for exported REDCap databases. Lastly, through an extension leveraging the `openxlsx2` [@openxlsx2_cit] package, users can easily export REDCapTidieR data tibbles to individual XLSX sheets.

# Installation

`REDCapTidieR` is available on [GitHub](https://github.com/CHOP-CGTInformatics/REDCapTidieR) and [CRAN](https://cran.r-project.org/web/packages/REDCapTidieR/index.html) and has been tested for functionality on all major operating systems.

# Acknowledgements

`REDCapTidieR` is made possible in large part thanks to the `REDCapR` and `tidyverse` [@tidyverse_cit] packages.

The authors would also like to give special thanks to Will Beasley, Paul Wildenhain, and Jan Marvin for their feedback and support in development.

# Conflict of interest

This package was developed by the [Children’s Hospital of
Philadelphia](https://www.chop.edu) Cell and Gene Therapy Informatics
Team to support the needs of the [Cellular Therapy and Transplant
Section](https://www.chop.edu/centers-programs/cellular-therapy-and-transplant-section).
The development was funded using the following sources:

- *Stephan Kadauke Start-up funds.* Stephan Kadauke, PI, CHOP, 2018-2024

- *CHOP-based GMP cell manufacturing (MFG) for CAR T clinical trials*.
  Stephan Grupp, PI; Stephan Kadauke, co-PI, CHOP, 2021-2023
