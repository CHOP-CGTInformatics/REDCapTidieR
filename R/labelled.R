#' @title
#' add labels!!!
#'
#' @param supertbl a supertibble containing REDCap data created by
#' \code{read_redcap_tidy()}
#' @param format_labels One of:
#' \itemize{
#'   \item \code{NULL} to apply field labels to elements of \code{redcap_data}
#'   as they appear in \code{redcap_metadata}
#'   \item The name of a \code{REDCapTidieR} \code{label_format_*} function.
#'   Currently only \code{"default"}
#'   \item A function that takes the labels in \code{redcap_metadata} as input
#'   and returns a vector of formatted labels of the same length as output
#' }
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
#' supertbl <- tibble::tribble(
#'   ~ redcap_data, ~ redcap_metadata,
#'   tibble::tibble(x = letters[1:3]), tibble::tibble(field_name = "x", field_label = "X Label"),
#'   tibble::tibble(y = letters[1:3]), tibble::tibble(field_name = "y", field_label = "Y Label")
#' )
#'
#' make_labelled(supertbl)
#'
#' \dontrun{
#' redcap_uri <- Sys.getenv("REDCAP_URI")
#' token <- Sys.getenv("REDCAP_TOKEN")
#'
#' supertbl <- read_redcap_tidy(redcap_uri, token)
#' make_labelled(supertbl)
#' }
#' @export
make_labelled <- function(supertbl, format_labels = NULL) {

  check_installed("labelled", reason = "to use `make_labelled()`")

  if (is.null(format_labels)) {
    formatter <- identity
  } else if (is.function(format_labels)) {
    formatter <- format_labels
  } else if (format_labels == "default") {
    formatter <- format_labels_default
  } else {
    # TODO: add informative error with cli
    stop()
  }

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
      # build labels from metadata + predefined labs
      labs <- c(.y$field_label, data_labs) %>%
        formatter()

      # Formatter may have wiped names so set them after
      names(labs) <- c(.y$field_name, names(data_labs))

      # set labs
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

#' @title
#' Format REDCap field labels for display
#'
#' @description
#' Use this function with the \code{format_labels} argument of
#' \code{make_labelled()} to define how field labels are formatted before being
#' applied to the elements of \code{redcap_data}. The default formatter does the
#' following in order:
#' \itemize{
#'   \item Removes text between curly braces (\code{\{\}}) which contains
#'   special "field embedding" logic in REDCap
#'   \item Removes html tags
#'   \item Removes extra whitespace
#'   \item Removes terminal colons
#' }
#'
#' @importFrom stringr str_replace str_replace_all str_squish str_trim
#' @importFrom dplyr %>%
#' @param x a vector of labels
#'
#' @return a vector of formatted labels
#'
#' @export
#'
#' @examples
#'
#' format_labels_default("<b>Bold Label:</b>")
#'
#' format_labels_default("Label {field_embedding_logic}")
#'
#' supertbl <- tibble::tribble(
#'   ~ redcap_data, ~ redcap_metadata,
#'   tibble::tibble(x = letters[1:3]), tibble::tibble(field_name = "x", field_label = "X Label:"),
#'   tibble::tibble(y = letters[1:3]), tibble::tibble(field_name = "y", field_label = "<b>Y Label</b>")
#' )
#'
#' make_labelled(supertbl, format_labels = format_labels_default)
#'
format_labels_default <- function(x) {
  x %>%
    str_replace_all("\\{.*?\\}", "") %>%
    str_replace_all("<.*?>", "") %>%
    str_squish() %>%
    str_trim() %>%
    str_replace(":$", "")
}
