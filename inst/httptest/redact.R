# Package wide function to redact credentials from mocks. Define fake tokens and
# uri here
# See https://enpiar.com/r/httptest/articles/redacting.html#setting-a-package-level-redactor
function(response) {
  real_creds <- REDCapTidieR:::get_credentials()
  fake_creds <- REDCapTidieR:::get_credentials(fake = TRUE)

  # Replace each token with a fake token
  purrr::reduce(
    names(fake_creds),
    .f = ~gsub_response(.x, real_creds[[.y]], fake_creds[[.y]]),
    .init = response
  )
}
