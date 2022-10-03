# Description

This submission features a bug patch and a few minor documentation changes.

Thank you for taking the time to review this submission and please reach out to either Stephan Kadauke or Richard Hanna for any questions, comments, or concerns.

## R CMD check results:

- 0 ERRORs or WARNINGs on any builds
- A NOTE is generated in R-hub Windows (Server 2022, R-devel 64-bit), a similar issue appears to arise in the `REDCapR` package and appears to be related to the R-hub test environment.

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

- A NOTE is generated in R-hub Fedora Linux (R-devel, clang, gfortran), but could not be reproduced locally. 

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
```

## Downstream Dependencies:

No downstream packages are affected. The package that depends/imports/suggests REDCapR passes checks with `revdepcheck::revdep_check()`. Results: https://github.com/CHOP-CGTDataOps/REDCapTidieR/blob/main/revdep/cran.md
