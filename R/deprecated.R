#' Deprecated functions
#'
#' @description `r lifecycle::badge("deprecated")`
#'
#' Use [import_redcap()] instead of `read_redcap_tidy()`.
#'
#' @export
#' @importFrom lifecycle deprecate_warn
#' @keywords internal
#' @name deprecated
read_redcap_tidy <- function(redcap_uri,
                             token,
                             raw_or_label = "label",
                             forms = NULL,
                             export_survey_fields = TRUE,
                             suppress_messages = TRUE) {
  deprecate_warn("0.2.0", "read_redcap_tidy()", "import_redcap()", always = TRUE)

  # suppress_messages is now suppress_redcapr_messages

  import_redcap(
    redcap_uri = redcap_uri,
    token = token,
    raw_or_label = raw_or_label,
    forms = forms,
    export_survey_fields = export_survey_fields,
    suppress_redcapr_messages = suppress_messages
  )
}

