#' @title
#' Extract longitudinal REDCap databases into tidy tibbles
#'
#' @description
#' Helper function internal to \code{read_redcap} responsible for
#' extraction and final processing of a tidy \code{tibble} to the user from
#' a longitudinal REDCap database.
#'
#' @param db_data_long The longitudinal REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata_long The longitudinal REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#' @param linked_arms Output of \code{link_arms}, linking instruments to REDCap
#' events/arms
#' @param enable_repeat_nonrepeat A logical to allow for support of mixed repeating/non-repeating
#' instruments. Setting to `TRUE` will treat the mixed instrument's non-repeating versions
#' as repeating instruments with a single instance. Applies to longitudinal projects
#' only Default `FALSE`.
#'
#' @return
#' Returns a \code{tibble} with list elements containing tidy dataframes. Users
#' can access dataframes under the \code{redcap_data} column with reference to
#' \code{form_name} and \code{structure} column details.
#'
#' @keywords internal

clean_redcap_long <- function(db_data_long,
                              db_metadata_long,
                              linked_arms,
                              enable_repeat_nonrepeat = FALSE) {
  # Repeating Instrument Check ----
  # Check if database supplied contains any repeating instruments to map onto
  # `redcap_repeat_*` variables

  has_repeat_forms <- "redcap_repeat_instance" %in% names(db_data_long)

  # Apply checkmate checks
  assert_data_frame(db_data_long)
  assert_data_frame(db_metadata_long)

  if (has_repeat_forms) {
    if (enable_repeat_nonrepeat) {
      db_data_long <- convert_mixed_instrument(db_data_long, db_metadata_long)
    } else {
      check_repeat_and_nonrepeat(db_data_long)
    }
  }

  ## Repeating Instruments Logic ----
  if (has_repeat_forms) {
    repeated_forms <- db_data_long %>%
      filter(!is.na(.data$redcap_repeat_instrument)) %>%
      pull(.data$redcap_repeat_instrument) %>%
      unique()

    repeated_forms_tibble <- tibble(
      redcap_form_name = repeated_forms,
      redcap_data = map(
        .data$redcap_form_name,
        ~ distill_repeat_table_long(
          .x,
          db_data_long,
          db_metadata_long,
          linked_arms
        )
      ),
      structure = "repeating"
    )
  }

  ## Nonrepeating Instruments Logic ----
  nonrepeated_forms <- db_metadata_long %>%
    filter(!is.na(.data$form_name)) %>%
    pull(.data$form_name) %>%
    unique()

  if (has_repeat_forms) {
    nonrepeated_forms <- setdiff(
      nonrepeated_forms,
      repeated_forms
    )
  }

  nonrepeated_forms_tibble <- tibble(
    redcap_form_name = nonrepeated_forms,
    redcap_data = map(
      .data$redcap_form_name,
      ~ distill_nonrepeat_table_long(
        .x,
        db_data_long,
        db_metadata_long,
        linked_arms
      )
    ),
    structure = "nonrepeating"
  )

  if (has_repeat_forms) {
    rbind(repeated_forms_tibble, nonrepeated_forms_tibble)
  } else {
    nonrepeated_forms_tibble
  }
}

#' @title
#' Extract non-repeat tables from longitudinal REDCap databases
#'
#' @description
#' Sub-helper function to \code{clean_redcap_long} for single nonrepeat table
#' extraction.
#'
#' @return
#' A \code{tibble} of all data related to a specified \code{form_name}
#'
#' @param form_name The \code{form_name} described in the named column from the
#' REDCap metadata.
#' @param db_data_long The REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata_long The REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#' @param linked_arms Output of \code{link_arms}, linking instruments to REDCap
#' events/arms
#'
#' @keywords internal

distill_nonrepeat_table_long <- function(form_name,
                                         db_data_long,
                                         db_metadata_long,
                                         linked_arms) {
  # Repeating Instrument Check ----
  # Check if database supplied contains any repeating instruments to map onto
  # `redcap_repeat_*` variables
  has_repeat_forms <- "redcap_repeat_instance" %in% names(db_data_long)

  my_record_id <- names(db_data_long)[1]
  my_form <- form_name

  my_fields <- db_metadata_long %>%
    filter(.data$form_name == my_form) %>%
    pull(.data$field_name_updated)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, my_fields)
  }

  # Below necessary to remove descriptive text fields
  # and to add column to indicate that instrument is completed
  my_fields <- db_data_long %>%
    select(
      all_of(my_fields),
      any_of(paste0(my_form, "_timestamp")),
      paste0(my_form, "_complete")
    ) %>%
    names()

  # For forms containing surveys, also pull redcap_survey_identifier
  if (paste0(my_form, "_timestamp") %in% my_fields) {
    my_fields <- c(my_fields, "redcap_survey_identifier")
  }

  # For projects containing DAGs, also pull redcap_data_access_group
  if ("redcap_data_access_group" %in% names(db_data_long)) {
    my_fields <- c(my_fields, "redcap_data_access_group")
  }

  # Setup data for loop redcap_arm linking
  db_data_long <- db_data_long %>%
    add_partial_keys(var = .data$redcap_event_name)

  # Check if data has repeat events after adding partial keys
  has_repeat_events <- "redcap_event_instance" %in% names(db_data_long)

  if (has_repeat_forms) {
    db_data_long <- db_data_long %>%
      filter(is.na(.data$redcap_form_instance))
  }

  # Find events associated with instrument
  events <- linked_arms %>%
    filter(.data$form == my_form) %>%
    pull("unique_event_name")

  # Filter events
  db_data_long <- filter(db_data_long, .data$redcap_event_name %in% events)

  # Final aesthetic cleanup
  out <- db_data_long %>%
    select(
      all_of(my_fields),
      any_of(c("redcap_event", "redcap_arm", "redcap_form_instance", "redcap_event_instance"))
    ) %>%
    relocate(any_of("redcap_data_access_group"), .after = all_of(my_record_id)) %>%
    relocate(
      any_of(c("redcap_event", "redcap_arm", "redcap_form_instance", "redcap_event_instance")),
      .after = !!my_record_id
    ) %>%
    rename("redcap_survey_timestamp" = any_of(paste0(my_form, "_timestamp"))) %>%
    relocate(any_of("redcap_survey_timestamp"), .after = everything()) %>%
    rename("form_status_complete" = paste0(my_form, "_complete")) %>%
    relocate("form_status_complete", .after = everything()) %>%
    remove_empty_rows(my_record_id) # nolint: object_usage_linter

  # Remove arms column if necessary
  if (!any(linked_arms$unique_event_name %>% str_detect("arm_2"))) {
    out <- out %>%
      select(-"redcap_arm")
  }

  # Remove redcap_form_instance arm if necessary
  if (has_repeat_forms) {
    if (all(is.na(out$redcap_form_instance))) {
      out <- out %>%
        select(-"redcap_form_instance")
    }
  }

  # Remove redcap_event_instance if necessary
  if (has_repeat_events) {
    if (all(is.na(out$redcap_event_instance))) {
      out <- out %>%
        select(-"redcap_event_instance")
    }
  }

  out %>%
    tibble()
}

#' @title
#' Extract repeat tables from longitudinal REDCap databases
#'
#' @description
#' Sub-helper function to \code{clean_redcap_long} for single repeat table
#' extraction.
#'
#' @return
#' A \code{tibble} of all data related to a specified \code{form_name}
#'
#' @param form_name The \code{form_name} described in the named column from the
#' REDCap metadata.
#' @param db_data_long The REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata_long The REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#' @param linked_arms Output of \code{link_arms}, linking instruments to REDCap
#' events/arms
#'
#' @keywords internal

distill_repeat_table_long <- function(form_name,
                                      db_data_long,
                                      db_metadata_long,
                                      linked_arms) {
  has_repeat_forms <- "redcap_repeat_instance" %in% names(db_data_long)

  my_record_id <- names(db_data_long)[1]
  my_form <- form_name

  my_fields <- db_metadata_long %>%
    filter(.data$form_name == my_form) %>%
    pull(.data$field_name_updated)

  if (my_fields[1] != my_record_id) {
    my_fields <- c(my_record_id, my_fields)
  }

  # Below necessary to remove descriptive text fields
  # and to add column to indicate that instrument is completed
  my_fields <- db_data_long %>%
    select(
      all_of(my_fields),
      any_of(paste0(my_form, "_timestamp")),
      paste0(my_form, "_complete")
    ) %>%
    names()

  # For forms containing surveys, also pull redcap_survey_identifier
  if (paste0(my_form, "_timestamp") %in% my_fields) {
    my_fields <- c(my_fields, "redcap_survey_identifier")
  }

  # For projects containing DAGs, also pull redcap_data_access_group
  if ("redcap_data_access_group" %in% names(db_data_long)) {
    my_fields <- c(my_fields, "redcap_data_access_group")
  }

  # Setup data for loop redcap_arm linking
  db_data_long <- db_data_long %>%
    add_partial_keys(var = .data$redcap_event_name) %>%
    filter(
      !is.na(.data$redcap_form_instance) &
        .data$redcap_repeat_instrument == my_form
    )

  # Check if data has repeat events after adding partial keys
  has_repeat_events <- "redcap_event_instance" %in% names(db_data_long)

  # Find events associated with instrument
  events <- linked_arms %>%
    filter(.data$form == my_form) %>%
    pull("unique_event_name")

  # Filter events
  db_data_long <- filter(db_data_long, .data$redcap_event_name %in% events)

  # Final aesthetic cleanup
  out <- db_data_long %>%
    filter(.data$redcap_repeat_instrument == my_form) %>%
    select(
      all_of(my_fields),
      any_of(c("redcap_event", "redcap_arm", "redcap_form_instance", "redcap_event_instance")),
    ) %>%
    relocate(any_of("redcap_data_access_group"), .after = all_of(my_record_id)) %>%
    relocate(
      any_of(c("redcap_event", "redcap_arm", "redcap_form_instance", "redcap_event_instance")),
      .after = !!my_record_id
    ) %>%
    rename("redcap_survey_timestamp" = any_of(paste0(my_form, "_timestamp"))) %>%
    relocate(any_of("redcap_survey_timestamp"), .after = everything()) %>%
    rename("form_status_complete" = paste0(my_form, "_complete")) %>%
    relocate("form_status_complete", .after = everything()) %>%
    remove_empty_rows(my_record_id) # nolint: object_usage_linter

  # Remove arms column if necessary
  if (!any(linked_arms$unique_event_name %>% str_detect("arm_2"))) {
    out <- out %>%
      select(-"redcap_arm")
  }

  # Remove redcap_form_instance arm if necessary
  if (has_repeat_forms) {
    if (all(is.na(out$redcap_form_instance))) {
      out <- out %>%
        select(-"redcap_form_instance")
    }
  }

  # Remove redcap_event_instance if necessary
  if (has_repeat_events) {
    if (all(is.na(out$redcap_event_instance))) {
      out <- out %>%
        select(-"redcap_event_instance")
    }
  }

  out %>%
    tibble()
}

#' @title Convert Mixed Structure Instruments to Repeating Instruments
#'
#' @description
#' For longitudinal projects where users set `enable_repeat_nonrepeat` to `TRUE`,
#' this function will handle the process of setting the nonrepeating parts of the
#' instrument to repeating ones with a single instance.
#'
#' @param db_data_long The longitudinal REDCap database output defined by
#' \code{REDCapR::redcap_read_oneshot()$data}
#' @param db_metadata_long The longitudinal REDCap metadata output defined by
#' \code{REDCapR::redcap_metadata_read()$data}
#'
#' @return
#' Returns a \code{tibble} with list elements containing tidy dataframes. Users
#' can access dataframes under the \code{redcap_data} column with reference to
#' \code{form_name} and \code{structure} column details.
#'
#' @keywords internal

convert_mixed_instrument <- function(db_data_long, db_metadata_long) {

  mixed_structure_fields <- get_mixed_structure_fields(db_data_long) %>%
    filter(rep_and_nonrep & !stringr::str_ends(field_name, "_form_complete")) %>%
    left_join(db_metadata_long %>% select(field_name, form_name),
              by = "field_name")

  for (i in 1:nrow(mixed_structure_fields)) {
    field <- mixed_structure_fields$field_name[i]
    form <- mixed_structure_fields$form_name[i]

    # Find column index in db_data_long with the specified field_name
    col_index <- which(colnames(db_data_long) == field)

    # Update redcap_repeat_instance and redcap_repeat_instrument
    db_data_long[, "redcap_repeat_instance"][!is.na(db_data_long[, col_index])] <- 1
    db_data_long[, "redcap_repeat_instrument"][!is.na(db_data_long[, col_index])] <- form
  }

  db_data_long
}

#' @title Get Mixed Structure Instrument List
#'
#' @description
#' Define fields in a given project that are used in both a repeating and
#' nonrepeating manner.
#'
#' @param db_data The REDCap database output generated by
#' \code{REDCapR::redcap_read_oneshot()$data}
#'
#' @returns a dataframe
#'
#' @keywords internal

get_mixed_structure_fields <- function(db_data) {
  # Identify columns to check for repeat/nonrepeat behavior
  safe_cols <- c(
    names(db_data)[1], "redcap_event_name",
    "redcap_repeat_instrument", "redcap_repeat_instance",
    "redcap_data_access_group"
  )

  check_cols <- setdiff(names(db_data), safe_cols)

  # Set up check_data function that looks for repeating and nonrepeating
  # behavior in a given column and returns a boolean
  check_data <- function(db_data, check_col) {
    # Repeating Check
    rep <- any(!is.na(db_data[{{ check_col }}]) & !is.na(db_data["redcap_repeat_instrument"]))

    # Nonrepeating Check
    nonrep <- any(!is.na(db_data[{{ check_col }}]) & is.na(db_data["redcap_repeat_instrument"]))

    rep & nonrep
  }

  # Create a simple dataframe, loop through check columns and append
  # dataframe with column being checked and the output of check_data
  out <- data.frame()
  for (i in seq_along(check_cols)) {
    rep_and_nonrep <- db_data %>%
      check_data(check_col = check_cols[i])

    field_name <- check_cols[i]

    out <- rbind(out, data.frame(field_name, rep_and_nonrep))
  }
  out
}
