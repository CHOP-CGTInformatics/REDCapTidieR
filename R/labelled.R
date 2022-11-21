#' @title
#' Apply \code{labelled} labels to the elements of a REDCap supertibble based on
#' project metadata
#'
#' @description
#' This function applies variable labels to the columns of:
#' \itemize{
#'   \item the supertibble itself
#'   \item each element of \code{redcap_data} based on the `field_label` column in
#'   \code{redcap_metadata}
#'   \item each element of \code{redcap_metadata}
#'   \item each element of \code{redcap_events}
#' }
#'
#' @param supertbl a supertibble generated using \code{read_redcap_tidy()}
#' @param format_labels One of:
#' \itemize{
#'   \item \code{NULL} to apply variable labels to elements of \code{redcap_data}
#'   as they appear in \code{redcap_metadata}. Default.
#'   \item A function that takes a character vector and returns a modified character vector
#'   of the same length. This function is applied to field labels before attaching them
#'   to variables.
#'   \item A character with the name of a function to be used to format labels
#'   \item A list of label formatting functions or function names to be applied
#'   in order. Note that ordering may affect results.
#' }
#'
#' @importFrom dplyr %>%
#' @importFrom purrr map map2
#' @importFrom rlang check_installed
#' @importFrom checkmate assert_data_frame
#'
#' @return
#' A labelled supertibble.
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
#' make_labelled(supertbl, format_labels = tolower)
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

  formatter <- resolve_formatter(format_labels)

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
    survey_timestamp = "REDCap Survey Timestamp",
    redcap_survey_identifier = "REDCap Survey Identifier",
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
#' Format REDCap variable labels for display
#'
#' @description
#' Use these functions with the \code{format_labels} argument of
#' \code{make_labelled()} to define how variable labels are formatted before
#' being applied to the data columns of \code{redcap_data}.
#'
#' \code{fmt_strip_whitespace()} removes extra whitespace inside and at the ends
#' of labels. It is a thin wrapper of \code{stringr::str_trim()} and
#' \code{stringr::str_squish()}. \code{fmt_strip_trailing_colon()} and
#' \code{fmt_strip_trailing_punct()} remove punctuation at the end of a label.
#' \code{fmt_strip_html()} removes html tags. \code{fmt_strip_field_embedding()}
#' removes text between curly braces (\code{\{\}}) which contains special
#' "field embedding" logic in REDCap. Note that \code{read_redcap_tidy()}
#' removes html tags and field embedding logic from field labels in the metadata
#' by default.
#'
#' @param x a vector of labels
#'
#' @return a vector of formatted labels
#'
#' @examples
#'
#' fmt_strip_whitespace("Poorly Spaced   Label ")
#'
#' fmt_strip_trailing_colon("Label:")
#'
#' fmt_strip_trailing_punct("Label-")
#'
#' fmt_strip_html("<b>Bold Label</b>")
#'
#' fmt_strip_field_embedding("Label{another_field}")
#'
#' supertbl <- tibble::tribble(
#'   ~ redcap_data, ~ redcap_metadata,
#'   tibble::tibble(x = letters[1:3]), tibble::tibble(field_name = "x", field_label = "X Label:")
#' )
#'
#' make_labelled(supertbl, format_labels = fmt_strip_trailing_colon)
#'
#' @name format-helpers
NULL

#' @rdname format-helpers
#' @importFrom stringr str_squish str_trim
#' @export
fmt_strip_whitespace <- function(x) {
  x %>%
    str_squish() %>%
    str_trim()
}

#' @rdname format-helpers
#' @importFrom stringr str_replace
#' @export
fmt_strip_trailing_colon <- function(x) {
  str_replace(x, ":$", "")
}

#' @rdname format-helpers
#' @importFrom stringr str_replace
#' @export
fmt_strip_trailing_punct <- function(x) {
  str_replace(x, "[:punct:]$", "")
}

#' @rdname format-helpers
#' @importFrom stringr str_replace_all
#' @export
fmt_strip_html <- function(x) {
  str_replace_all(x, "<.+?\\>", "")
}

#' @rdname format-helpers
#' @importFrom stringr str_replace_all
#' @export
fmt_strip_field_embedding <- function(x) {
  str_replace_all(x, "\\{.+?\\}", "")
}

#' @title
#' Convert user input into label formatting function
#'
#' @param format_labels argument passed to \code{make_labelled}
#' @param env the environment in which to look up functions if
#' \code{format_labels} contains character elements. The default,
#' \code{caller_env(n = 2)}, uses the environment from which the user called
#' \code{make_labelled()}
#'
#' @importFrom purrr map compose
#' @importFrom rlang !!! as_closure caller_env is_bare_formula
#' @importFrom cli cli_abort
#'
#' @return a function
#'
#' @keywords internal
#'
resolve_formatter <- function(format_labels, env = caller_env(n = 2)) {
  if (is.null(format_labels)) {
    # If NULL pass labels through unchanged
    return(identity)
  }
  if (is.function(format_labels)) {
    # If a single function then return it to apply to labels
    return(format_labels)
  }
  if (is_bare_formula(format_labels, lhs = FALSE)) {
    # If a one-sided formula convert to a function
    return(as_closure(format_labels))
  }
  if (is.list(format_labels) || is.character(format_labels)) {
    # If a list or character vector compose the functions into a function
    # that applies them in order

    # By default compose() converts character inputs to functions but we want
    # to convert them ourselves to ensure they're looked up in the right env
    fns <- map(format_labels, as_closure, env = env)
    return(compose(!!!fns, .dir = "forward"))
  }

  supported_classes <- c("NULL", "list", "function", "character")
  cli_abort(
    c("!" = "{.arg format_labels} must be of class {.cls {supported_classes}}",
      "x" = "{.arg format_labels} is {.cls {class(format_labels)}}"),
    class = c("unresolved_formatter", "REDCapTidieR_cond")
  )

}
