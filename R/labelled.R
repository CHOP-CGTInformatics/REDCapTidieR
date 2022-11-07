#' @title
#' add labels!!!
#'
#' @param supertbl a supertibble containing REDCap data created by
#' \code{read_redcap_tidy()}
#'
#' @importFrom dplyr %>%
#' @importFrom purrr map map2
#' @importFrom rlang check_installed
#' @importFrom checkmate assert_data_frame
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

  check_installed("labelled", reason = "to use `make_labelled()`")

  assert_data_frame(supertbl)
  check_req_labelled_fields(supertbl)
  check_req_labelled_metadata_fields(supertbl)

  # Derive labels ----
  main_labs <- c(
    redcap_form_name = "REDCap Instrument Name",
    redcap_form_label = "REDCap Instrument Description",
    redcap_data = "Data",
    redcap_metadata = "Metadata",
    redcap_events = "Events and Arms Associated with this Instrument",
    structure = "Repeating or Nonrepeating?",
    data_rows = "# of Rows in Data",
    data_cols = "# of Columns in Data",
    data_size = "Data size in Memory",
    data_na_pct = "% of Data Missing"
  )

  metadata_labs <- c(
    field_name = "Variable / Field Name",
    field_label = "Field Label",
    field_type = "Field Type",
    section_header = "Section Header",
    field_note = "Field Note",
    text_validation_type_or_show_slider_number = "Text Validation Type OR Show Slider Number",
    text_validation_min = "Text Validation Min",
    text_validation_max = "Text Validation Max",
    identifier = "Identifier?",
    branching_logic = "Branching Logic (Show field only if...)",
    required_field = "Required Field?",
    custom_alignment = "Custom Alignment",
    question_number = "Question Number (surveys only)",
    matrix_group_name = "Matrix Group Name",
    matrix_ranking = "Matrix Ranking?",
    field_annotation = "Field Annotation"
  )

  ## Set some predefined labels for data fields that aren't in the metadata
  data_labs <- c(
    redcap_repeat_instance = "REDCap Repeat Instance",
    redcap_event = "REDCap Event",
    redcap_arm = "REDCap Arm",
    form_status_complete = "REDCap Form Status"
  )

  event_labs <- c(
    redcap_event = "Event Name",
    redcap_arm = "Arm Name",
    arm_name = "Arm Description"
  )

  # Apply labels ----

  # Utility function for label setting
  # Set labels of tibble from named vector but don't fail if labels vector has
  # variables that aren't in the data
  safe_set_variable_labels <- function(data, labs) {
    labs_to_keep <- intersect(names(labs), colnames(data))
    labelled::set_variable_labels(data, !!!labs[labs_to_keep])
  }

  out <- supertbl

  # Label cols of each metadata tibble
  out$redcap_metadata <- map(
    out$redcap_metadata,
    .f = safe_set_variable_labels,
    labs = metadata_labs
  )

  # Label cols of each data tibble

  out$redcap_data <- map2(
    out$redcap_data,
    out$redcap_metadata,
    .f = ~ {
      # build labels from metadata
      labs <- .y$field_label
      names(labs) <- .y$field_name

      # add pre-defined labels
      labs <- c(labs, data_labs)

      # set them
      safe_set_variable_labels(.x, labs)
    }
  )

  # Label cols of each event tibble if present
  if ("redcap_events" %in% colnames(supertbl)) {
    out$redcap_events <- map(
      out$redcap_events,
      .f = safe_set_variable_labels,
      labs = event_labs
    )
  }

  # Label main cols
  # Do this last since map removes labels from columns we map over
  out <- safe_set_variable_labels(out, main_labs)

  out
}
