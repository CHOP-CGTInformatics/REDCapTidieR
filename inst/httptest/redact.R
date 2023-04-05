# Package wide function to redact credentials from mocks. Define fake tokens and
# uri here
# See https://enpiar.com/r/httptest/articles/redacting.html#setting-a-package-level-redactor
function(response) {
  real_creds <- REDCapTidieR:::get_credentials()
  fake_creds <- REDCapTidieR:::get_credentials(fake = TRUE)

  # Replace each token with a fake token
  purrr::reduce(
    names(fake_creds),
    .f = function(x, y) {
      real <- real_creds[[y]]
      fake <- fake_creds[[y]]
      # If real credential not found don't replace anything
      # Need this to ensure gsub_response doesn't fail in this case
      if (real == "") {
        return(x)
      }
      gsub_response(x, real, fake)
    },
    .init = response
  )
}
