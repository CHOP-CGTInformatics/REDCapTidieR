To add mocks for a new REDCap:

1. Generate an API token and store it in your `.Renviron` with a name like `REDCAPTIDIER_DESCRIPTIVE_NAME_API`
2. Associate this name with a *fake* value in `inst/misc/fake_credentials.csv`
3. Generate mocks by adding code to and running `tests/testthat/fixtures/create-httptest-mock.R`
  - Reference your token with `creds$REDCAPTIDIER_DESCRIPTIVE_NAME_API`
  - It's best to do this step in a clean R session
4. Use mocks by adding code to test files wrapped in `httptest::with_mock_api()`
  - Reference your token with `creds$REDCAPTIDIER_DESCRIPTIVE_NAME_API`, as in step 3
  - Make sure you've run the `httptest::.mockPaths(test_path("fixtures"))` line at the top of test files with mocks in your session

To add mocks from an existing REDCap:

1. Complete step 1 above. You'll need valid tokens in your `.Renviron` for all REDCaps used in `create-httptest-mock.R`
  - Add `REDCAPTIDIER_DELETED_API = AC1759E5D3E10EF64350B05F5A96DB5F` to your `.Renviron` since new tokens for this project cannot generated
  - Technically you may be able to get away with running lines selectively if you're careful
2. Complete steps 3-4 above

To refresh mocks for a vignette:

1. Delete the directory storing mocks for your vignette. This will be located at `vignettes/NAME_OF_VIGNETTE/`
2. Rebuild vignettes with `devtools::build_vignettes(clean = FALSE)`
