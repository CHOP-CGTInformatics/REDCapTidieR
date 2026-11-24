#' @title Extract REDCap databases into tidy tibbles
#'
#' @description
#' Extract one data tibble per instrument from a classic or longitudinal export.
#'
#' @param db_data The REDCap database output defined by
#'   `REDCapR::redcap_read_oneshot()$data`.
#' @param db_metadata The REDCap metadata output defined by
#'   `REDCapR::redcap_metadata_read()$data`, with updated field names.
#' @param form_structure A tibble with `redcap_form_name` and `structure` columns.
#' @param linked_arms A longitudinal instrument-to-event mapping from [link_arms()].
#'   Use `NULL` for classic projects.
#' @param allow_mixed_structure Whether to treat the nonrepeating portions of
#'   mixed longitudinal instruments as repeating.
#'
#' @returns A tibble with one row per instrument and columns `redcap_form_name`,
#'   `redcap_data`, and `structure`. Repeating and mixed instruments appear first.
#' @keywords internal
clean_redcap <- function(
  db_data,
  db_metadata,
  form_structure,
  linked_arms = NULL,
  allow_mixed_structure = FALSE
) {
  assert_data_frame(db_data)
  assert_data_frame(db_metadata)

  longitudinal <- !is.null(linked_arms)
  has_repeat_instances <- db_has_repeat_forms(db_data)
  repeat_structures <- if (longitudinal) c("repeating", "mixed") else "repeating"
  form_groups <- list(
    repeating = filter(form_structure, .data$structure %in% repeat_structures),
    nonrepeating = filter(form_structure, .data$structure == "nonrepeating")
  )
  if (nrow(form_groups$repeating) + nrow(form_groups$nonrepeating) == 0L) {
    return(tibble(redcap_form_name = form_structure$redcap_form_name[0], redcap_data = list(), structure = character()))
  }

  fields_by_form <- split(db_metadata$field_name_updated, db_metadata$form_name)
  events_by_form <- if (longitudinal) split(linked_arms$unique_event_name, linked_arms$form)
  keep_arm <- longitudinal && any(str_detect(linked_arms$unique_event_name, "arm_2"))

  # Compute the shared longitudinal keys on first use and reuse them across forms,
  # avoiding a full pass over the export for each form. Deferring the calculation
  # preserves validation order and skips the work if every form needs its own keys.
  delayedAssign("longitudinal_data", add_partial_keys(db_data, var = .data$redcap_event_name))

  extract_group <- function(forms, repeating, keyed_data, mixed_by_form) {
    tibble(
      redcap_form_name = forms$redcap_form_name,
      redcap_data = map(forms$redcap_form_name, function(form_name) {
        get_instrument_data(
          form_name = form_name,
          db_data = db_data,
          fields = fields_by_form[[form_name]],
          keyed_data = keyed_data,
          repeating = repeating,
          longitudinal = longitudinal,
          events = events_by_form[[form_name]],
          keep_arm = keep_arm,
          has_repeat_instances = has_repeat_instances,
          mixed_fields = mixed_by_form[[form_name]]
        )
      }),
      structure = forms$structure
    )
  }

  # Keep the old validation order. Classic projects process repeating forms first.
  # Reverse the groups for longitudinal projects so nonrepeating extraction errors
  # still surface before mixed-structure validation for the repeating group.
  processing_order <- if (longitudinal) rev(names(form_groups)) else names(form_groups)
  cleaned <- list()
  for (group in processing_order) {
    forms <- form_groups[[group]]
    if (nrow(forms) == 0L) {
      next
    }

    repeating <- group == "repeating"
    mixed_by_form <- NULL
    if (longitudinal && repeating) {
      if (allow_mixed_structure) {
        mixed_by_form <- get_mixed_fields_by_form(db_data, db_metadata)
      } else {
        check_repeat_and_nonrepeat(db_data)
      }
    }

    cleaned[[group]] <- extract_group(
      forms,
      repeating,
      keyed_data = if (longitudinal) longitudinal_data else get_classic_keyed_data(db_data, repeating),
      mixed_by_form = mixed_by_form
    )
  }

  rbind(cleaned$repeating, cleaned$nonrepeating)
}

#' @title Derive classic instrument keys
#' @description Remove raw repeat rows for nonrepeating forms before deriving keys.
#' @param db_data A classic REDCap export.
#' @param repeating Whether the instruments repeat.
#' @returns A data frame with partial keys.
#' @noRd
get_classic_keyed_data <- function(db_data, repeating) {
  if (!repeating && db_has_repeat_forms(db_data)) {
    db_data <- filter(db_data, is.na(.data$redcap_repeat_instance))
  }
  add_partial_keys(db_data)
}

#' @title Extract a single REDCap instrument
#' @description Apply project-specific row rules and create the instrument tibble.
#' @param form_name The instrument name.
#' @param db_data The original project export, used to select fields and convert
#'   mixed instruments before deriving their keys.
#' @param fields The instrument's updated metadata field names.
#' @param keyed_data The shared export with event, arm, and instance columns
#'   derived as applicable. For classic nonrepeating forms, raw repeat rows have
#'   already been filtered out. Instruments requiring mixed-structure conversion
#'   derive keys separately from their converted data.
#' @param repeating Whether to extract the instrument as repeating.
#' @param longitudinal Whether the project is longitudinal.
#' @param events The mapped event names for this instrument.
#' @param keep_arm Whether to retain the longitudinal arm column.
#' @param has_repeat_instances Whether the raw export has a repeat-instance column.
#' @param mixed_fields Reference data for converting the instrument's mixed rows.
#' @returns A tibble containing the instrument's data.
#' @noRd
get_instrument_data <- function(
  form_name,
  db_data,
  fields,
  keyed_data,
  repeating,
  longitudinal,
  events,
  keep_arm,
  has_repeat_instances,
  mixed_fields
) {
  record_id <- get_record_id_field(db_data)
  timestamp <- paste0(form_name, "_timestamp")
  status <- paste0(form_name, "_complete")
  dag <- "redcap_data_access_group"

  if (fields[1] != record_id) {
    fields <- c(record_id, fields)
  }
  fields <- names(select(db_data, all_of(fields), any_of(timestamp), all_of(status)))
  if (timestamp %in% fields) {
    fields <- c(fields, "redcap_survey_identifier")
  }
  if (dag %in% names(db_data)) {
    fields <- c(fields, dag)
  }

  form_data <- if (is.null(mixed_fields)) {
    keyed_data
  } else {
    add_partial_keys(convert_mixed_instrument(db_data, mixed_fields), var = .data$redcap_event_name)
  }

  if (repeating && longitudinal) {
    form_data <- filter(
      form_data,
      (!is.na(.data$redcap_form_instance) | if_any(matches("redcap_event_instance"), ~ !is.na(.x))) &
        .data$redcap_repeat_instrument == .env$form_name
    )
  } else if (repeating) {
    form_data <- filter(form_data, !is.na(.data$redcap_form_instance) & .data$redcap_repeat_instrument == .env$form_name)
  } else if (longitudinal && has_repeat_instances) {
    form_data <- filter(form_data, is.na(.data$redcap_form_instance))
  }
  if (longitudinal) {
    form_data <- filter(form_data, .data$redcap_event_name %in% events)
  }

  instance_keys <- c("redcap_event", "redcap_arm", "redcap_form_instance", "redcap_event_instance")
  keys <- if (longitudinal) instance_keys else "redcap_form_instance"
  leading_cols <- if (!longitudinal && !repeating) c(dag, instance_keys) else c(keys, dag)

  out <- select(form_data, all_of(fields), any_of(keys))
  out <- relocate(out, any_of(leading_cols), .after = all_of(record_id))
  out <- rename(out, redcap_survey_timestamp = any_of(timestamp), form_status_complete = all_of(status))
  out <- relocate(out, any_of(c("redcap_survey_timestamp", "form_status_complete")), .after = everything())

  if (longitudinal) {
    out <- remove_empty_rows(out, record_id)
    if (!keep_arm) {
      out <- select(out, -"redcap_arm")
    }
    if ("redcap_event_instance" %in% names(form_data) && all(is.na(out$redcap_event_instance))) {
      out <- select(out, -"redcap_event_instance")
    }
  }
  if (has_repeat_instances && (longitudinal || !repeating) && all(is.na(out$redcap_form_instance))) {
    out <- select(out, -"redcap_form_instance")
  }
  tibble(out)
}
