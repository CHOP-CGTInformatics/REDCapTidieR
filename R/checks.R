#' @title
#' Check for possible API user privilege issues

#' @description
#' Check for potential user access privilege issues and provide an appropriate
#' warning message. This can occur when metadata forms/field names do not appear
#' in a database export.
#'
#' @return
#' A helpful error message alerting the user to check their API privileges.
#'
#' @importFrom rlang .data caller_env
#' @importFrom dplyr filter select group_by summarise
#' @importFrom tidyr pivot_wider
#' @importFrom cli cli_warn
#'
#' @param db_data The REDCap database output generated by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata The REDCap metadata output generated by \code{REDCapR::redcap_metadata_read()$data}
#' @param call the calling environment to use in the warning message
#'
#' @keywords internal

check_user_rights <- function(db_data,
                              db_metadata,
                              call = caller_env()) {
  missing_db_metadata <- db_metadata %>% # nolint: object_usage_linter
    filter(!.data$field_name_updated %in% names(db_data)) %>%
    select("field_name_updated", "form_name") %>%
    group_by(.data$form_name) %>%
    summarise(fields = list(.data$field_name_updated))

  cli_warn(
    c("Instrument name{?s} {missing_db_metadata$form_name} detected in metadata,
        but not found in the database export.",
      "i" = "This can happen when the user privileges are not set to allow
        exporting certain instruments via the API. The following variable{?s}
        are affected: {unlist(missing_db_metadata$fields)}"
    ),
    class = c("redcap_user_rights", "REDCapTidieR_cond"),
    call = call
  )
}

#' @title
#' Check for instruments that have both repeating and non-repeating structure
#'
#' @description
#' Check for potential instruments that are given both repeating and
#' nonrepeating structure. \code{REDCapTidieR} does not support database
#' structures built this way.
#'
#' @return
#' A helpful error message alerting the user to existence of an instrument
#' that was designated both as repeating and non-repeating.
#'
#' @param db_data The REDCap database output generated by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param call the calling environment to use in the error message
#'
#' @importFrom dplyr %>% select mutate case_when
#' @importFrom purrr map2
#' @importFrom tidyselect any_of
#' @importFrom cli cli_abort
#' @importFrom rlang caller_env
#'
#' @keywords internal


check_repeat_and_nonrepeat <- function(db_data, call = caller_env()) {
  # This check function looks for potential repeat/nonrepeat behavior using the
  # steps below:
  # 1) Define standard columns that don't need checking and remove those from
  #    analysis (i.e. "safe columns").
  # 2) Create a dummy column for each remaining column and use case_when to
  #    to assign whether the column demonstrates repeating, nonrepeating, or
  #    indeterminate behavior per row. Indeterminate would be the case for
  #    data not yet filled out.
  # 3) Use a mapping function to determine if any dummy columns contain both
  #    "repeating" AND "nonrepeating" declarations, if so error out.

  # Step (1)
  safe_cols <- c(
    names(db_data)[1], "redcap_event_name",
    "redcap_repeat_instrument", "redcap_repeat_instance"
  )

  # Step (2)
  check_data <- db_data %>%
    mutate(
      across(
        .cols = -any_of(safe_cols),
        .names = "{.col}_repeatingcheck",
        .fns = ~ case_when(
          !is.na(.x) & !is.na(redcap_repeat_instrument) ~ "repeating",
          !is.na(.x) & is.na(redcap_repeat_instrument) ~ "nonrepeating",
          TRUE ~ NA_character_
        )
      )
    )


  # Step (3)
  repeat_nonrepeat_error <- function(check_data, names) { # nolint: object_name_linter

    rep <- gsub(pattern = "_repeatingcheck", replacement = "", x = names) # nolint: object_name_linter

    if ("repeating" %in% check_data &&
      "nonrepeating" %in% check_data) {
      cli_abort(c("x" = "Instrument detected that has both repeating and
      nonrepeating instances defined in the project: {rep}"),
        class = c("repeat_nonrepeat_instrument", "REDCapTidieR_cond"),
        call = call
      )
    }
  }

  purrr::map2(
    .x = check_data %>% select(ends_with("_repeatingcheck")),
    .y = check_data %>% select(ends_with("_repeatingcheck")) %>% names(),
    .f = ~ repeat_nonrepeat_error(.x, .y)
  )
}

#' @title
#' Check that a supplied REDCap database is populated

#' @description
#' Check for potential outputs where metadata is present, but \code{nrow} and
#' \code{ncol} equal `0`. This causes \code{multi_choice_to_labels} to fail, but
#' a helpful error message should be provided.
#'
#' @return
#' A helpful error message alerting the user to check their API privileges.
#'
#' @param db_data The REDCap database output generated by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param call the calling environment to use in the error message
#'
#' @importFrom cli cli_abort
#' @importFrom rlang caller_env
#'
#' @keywords internal

check_redcap_populated <- function(db_data, call = caller_env()) {
  if (ncol(db_data) == 0) {
    cli_abort(
      "The REDCap API did not return any data. This can happen when there are no
      data entered or when the access isn't configured to allow data export
      through the API.",
      class = c("redcap_unpopulated", "REDCapTidieR_cond"),
      call = call
    )
  }
}


#' @title
#' Check that all requested instruments are in REDCap project metadata
#'
#' @description
#' Provide an error message when any instrument names are passed to
#' \code{read_redcap()} that do not exist in the project metadata.
#'
#' @return
#' An error message listing the requested instruments that don't exist
#'
#' @importFrom cli cli_abort
#' @importFrom rlang caller_env
#'
#' @param db_metadata The metadata file read by
#' \code{REDCapR::redcap_metadata_read()}
#' @param forms The character vector of instrument names passed to
#' \code{read_redcap()}
#' @param call the calling environment to use in the error message
#'
#' @keywords internal
check_forms_exist <- function(db_metadata, forms, call = caller_env()) {
  missing_forms <- setdiff(forms, unique(db_metadata$form_name))

  if (length(missing_forms) > 0) {
    cli_abort(
      c("x" = "Instrument{?s} {missing_forms} {?does/do} not exist in REDCap
        project"),
      class = c("form_does_not_exist", "REDCapTidieR_cond"),
      call = call
    )
  }
}

#' @title
#' Check that all metadata tibbles within a supertibble contain
#' \code{field_name} and \code{field_label} columns
#'
#' @importFrom purrr map map_int
#' @importFrom dplyr %>% filter
#' @importFrom cli cli_abort
#' @importFrom rlang caller_arg
#'
#' @param supertbl a supertibble containing a \code{redcap_metadata} column
#' @param call the calling environment to use in the error message
#'
#' @return
#' an error message alerting that instrument metadata is incomplete
#'
#' @keywords internal
check_req_labelled_metadata_fields <- function(supertbl, call = caller_env()) {
  req_fields <- c("field_name", "field_label") # nolint: object_usage_linter

  # map over each metadata tibble and return list element with missing fields
  missing_fields <- supertbl$redcap_metadata %>%
    map(~ setdiff(req_fields, colnames(.)))

  # If any missing fields were found error
  if (length(unlist(missing_fields)) > 0) {
    # Build error message bullets of the form:
    # x: {form} is missing {missing fields}
    msg_data <- tibble(missing_fields = missing_fields)

    # Instrument names to use in message. Use redcap_form_name if available
    # but don't assume it's in the data
    if ("redcap_form_name" %in% colnames(supertbl)) {
      msg_data$form <- supertbl$redcap_form_name
    } else {
      msg_data$form <- paste0(
        "supertbl$redcap_metadata[[", seq_along(missing_fields), "]]"
      )
    }

    # Drop rows without missing fields
    msg_data <- msg_data %>%
      filter(map_int(.data$missing_fields, length) > 0)

    # Create vector of messages and apply 'x' label
    msg <- paste0(
      "{.code {msg_data$form[[", seq_len(nrow(msg_data)), "]]}} ",
      "is missing {.code {msg_data$missing_fields[[", seq_len(nrow(msg_data)), "]]}}"
    )

    names(msg) <- rep("x", length(msg))

    # Prepend note about required fields
    msg <- c(
      "!" = "All elements of {.arg supertbl$redcap_metadata} must contain {.code {req_fields}}",
      msg
    )

    cli_abort(
      msg,
      class = c("missing_req_labelled_metadata_fields", "REDCapTidieR_cond"),
      call = call
    )
  }
}


#' @title
#' Check an argument with checkmate
#'
#' @importFrom cli cli_abort
#' @importFrom rlang caller_arg
#'
#' @param x An object to check
#' @param arg The name of the argument to include in an error message. Captured
#' by `rlang::caller_arg()` by default
#' @param call the calling environment to use in the error message
#' @param req_cols required fields for `check_arg_is_supertbl()`
#' @param ... additional arguments passed on to checkmate
#'
#' @return
#' `TRUE` if `x` passes the checkmate check. An error otherwise with the name of
#' the checkmate function as a `class`
#'
#' @name checkmate
#' @keywords internal
NULL

# Function factory to wrap checkmate functions
#' @importFrom rlang caller_arg caller_env
#' @importFrom cli cli_abort
#' @noRd
wrap_checkmate <- function(f) {
  error_class <- caller_arg(f)

  function(x, ..., arg = caller_arg(x), call = caller_env()) {
    out <- f(x, ...)

    if (isTRUE(out)) {
      return(TRUE)
    }

    cli_abort(
      message = c(
        "x" = "You've supplied {.code {format_error_val(x)}} for {.arg {arg}} which is not a valid value",
        "!" = "{out}"
      ),
      class = c(error_class, "REDCapTidieR_cond"),
      call = call
    )
  }
}

#' @rdname checkmate
#' @importFrom cli cli_abort
#' @importFrom rlang caller_env caller_arg is_bare_list
#' @importFrom purrr map_lgl
check_arg_is_supertbl <- function(x,
                                  req_cols = c("redcap_data", "redcap_metadata"),
                                  arg = caller_arg(x),
                                  call = caller_env()) {

  # shared data for all messages
  msg_x <- "You've supplied {.code {format_error_val(x)}} for {.arg {arg}} which is not a valid value"
  msg_info <- "{.arg {arg}} must be a {.pkg REDCapTidieR} supertibble, generated using {.code read_redcap()}"
  msg_class <- c("check_supertbl", "REDCapTidieR_cond")

  if (!inherits(x, "redcap_supertbl")) {
    cli_abort(
      message = c(
        "x" = msg_x,
        "!" = "Must be of class {.cls redcap_supertbl}",
        "i" = msg_info
      ),
      class = msg_class,
      call = call
    )
  }

  missing_cols <- setdiff(req_cols, colnames(x))

  # If any are missing give an error message
  if (length(missing_cols) > 0) {
    cli_abort(
      message = c(
        "x" = msg_x,
        "!" = "Must contain {.code {paste0(arg, '$', missing_cols)}}",
        "i" = msg_info
      ),
      class = c("missing_req_cols", msg_class),
      call = call,
      missing_cols = missing_cols
    )
  }

  non_list_cols <- map_lgl(x[req_cols], ~!is_bare_list(.))
  non_list_cols <- req_cols[non_list_cols]

  if (length(non_list_cols) > 0) {
    cli_abort(
      message = c(
        "x" = msg_x,
        "!" = "{.code {paste0(arg, '$', non_list_cols)}} must be of type 'list'",
        "i" = msg_info
      ),
      class = c("missing_req_list_cols", msg_class),
      call = call,
      non_list_cols = non_list_cols
    )
  }

  return(TRUE)
}

#' @rdname checkmate
#' @importFrom checkmate check_environment
check_arg_is_env <- wrap_checkmate(check_environment)

#' @rdname checkmate
#' @importFrom checkmate check_character
check_arg_is_character <- wrap_checkmate(check_character)

#' @rdname checkmate
#' @importFrom checkmate check_logical
check_arg_is_logical <- wrap_checkmate(check_logical)

#' @rdname checkmate
#' @importFrom checkmate check_choice
check_arg_choices <- wrap_checkmate(check_choice)

#' @rdname checkmate
#' @importFrom REDCapR sanitize_token
check_arg_is_valid_token <- function(x,
                                     arg = caller_arg(x),
                                     call = caller_env()) {
  check_arg_is_character(x, len = 1, any.missing = FALSE,
                         arg = arg, call = call)

  sanitize_token(x)

  return(TRUE)
}

#' @title
#' Format value for error message
#'
#' @param x value to format
#'
#' @return
#' If x is atomic, x with cli formatting to truncate to 5 values. Otherwise,
#' a string summarizing x produced by as_label
#'
#' @importFrom rlang as_label is_atomic
#' @importFrom cli cli_vec
#'
#' @keywords internal
format_error_val <- function(x) {
  if (is_atomic(x)) {
    out <- cli_vec(x, style = list("vec-trunc" = 5, "vec-last" = ", "))
  } else {
    out <- as_label(x)
  }
  out
}
