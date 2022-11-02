#' @title
#' add labels!!!
#'
#' @param supertbl a supertibble containing REDCap data created by
#' \code{read_redcap_tidy()}
#'
#' @importFrom dplyr %>%
#' @importFrom stringr str_replace_all str_to_title
#' @importFrom purrr map
#'
#' @return
#' Supertibble with labels applied to:
#' - x
#' - y
#' - z
#'
#' @examples
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' supertbl <- read_redcap_tidy(redcap_uri, token)
#' make_labelled(supertbl)
#' }
#' @export
make_labelled <- function(supertbl) {

  # TODO: Input checking on supertibble
  check_labelled(supertbl)

  # TODO: Check labelled installation
  # TODO: Implement redcap_data labeling

  # Derive labels ----
  main_labs <- c(
    redcap_form_name = "Form Name",
    # TODO: consider doing  val_label(redcap_form_name, redcap_form_label)
    # and dropping redcap_form_label
    redcap_form_label = "Form Label",
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    redcap_events = "Events",
    structure = "Form Structure",
    data_rows = "# Rows",
    data_cols = "# Columns",
    data_size = "Memory Size",
    data_na_pct = "% NA"
  )

  # Apply formatting to existing metadata fields to derive labels

  # Extract unique set of colnames from metadata tibble rows of supertibble
  # Edge cases: user removed the metadata field; user changes the name of the metadata field
  metadata_cols <- map(supertbl$redcap_metadata, colnames) %>%
    unlist() %>%
    unique()

  metadata_labs <- metadata_cols %>%
    str_replace_all("_", " ") %>%
    str_to_title()

  names(metadata_labs) <- metadata_cols

  # Apply labels ----

  # Utility function for label setting
  # Set labels of tibble from named vector but don't fail if labels vector has
  # variables that aren't in the data
  safe_set_variable_labels <- function(data, labs) {
    labs_to_keep <- intersect(names(labs), colnames(data))
    labelled::set_variable_labels(data, !!!labs[labs_to_keep])
  }

  out <- supertbl

  # Label cols of each metadata table
  out$redcap_metadata <- map(
    out$redcap_metadata,
    .f = safe_set_variable_labels,
    labs = metadata_labs
  )

  # Label main cols
  # Do this last since map removes labels from columns we map over
  out <- safe_set_variable_labels(out, main_labs)

  out
}
