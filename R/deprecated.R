#' Deprecated functions
#'
#' @description `r lifecycle::badge("deprecated")`
#'
#' Use [import_redcap()] instead of `read_redcap_tidy()`. Note that the
#' `suppress_messages` argument was renamed to `suppress_redcapr_messages`.
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

#' @description
#'
#' Use [bind_tibbles()] instead of `bind_tables()`. Note that the `.data`
#' argument was renamed to `supertbl` and the `structure` argument was removed.
#'
#' @export
#' @rdname deprecated
bind_tables <- function(.data,
                        environment = global_env(),
                        tbls = NULL,
                        structure = NULL) {
  deprecate_warn("0.2.0", "bind_tables()", "bind_tibbles()", always = TRUE)

  # Name variables
  my_tbls <- tbls
  my_structures <- structure
  env_data <- .data

  # Apply conditional loading for specific forms or structures
  if (!is.null(my_tbls)) {
    env_data <- env_data %>%
      filter(.data$redcap_form_name %in% my_tbls)
  }

  if (!is.null(my_structures)) {
    env_data <- env_data %>%
      filter(.data$structure %in% my_structures)
  }

  table_names <- env_data %>%
    pull(.data$redcap_form_name)

  # Map over table names and environment data to load into environment
  map2(.x = table_names,
       .y = env_data$redcap_data,
       .f = ~ env_poke(env = environment,
                       nm = .x,
                       value = .y)
  )
  return(invisible(NULL))
}

#' @description
#'
#' Use [extract_tibble()] instead of `extract_table()`. Note that the `.data`
#' argument was renamed to `supertbl`.
#'
#' @export
#' @rdname deprecated
extract_table <- function(.data,
                          tbl) {
  deprecate_warn("0.2.0", "extract_table()", "extract_tibble()", always = TRUE)

  extract_tibble(supertbl = .data, tbl = tbl)
}

#' @description
#'
#' Use [extract_tibbles()] instead of `extract_tables()`. Note that the `.data`
#' argument was renamed to `supertbl`.
#'
#' @export
#' @rdname deprecated
extract_tables <- function(.data,
                           tbls = everything()) {

  deprecate_warn("0.2.0", "extract_tables()", "extract_tibbles()", always = TRUE)

  extract_tibbles(supertbl = .data, tbls = tbls)
}
