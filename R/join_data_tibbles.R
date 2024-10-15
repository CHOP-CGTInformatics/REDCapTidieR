#' @title Join Two Data Tibbles from a Supertibble
#'
#' @description
#' The [join_data_tibbles()] function provides a way to intelligently join two
#' data tibbles from a REDCaTidieR supertibble. A supertibble is an output of
#' [read_redcap()].
#'
#' [join_data_tibbles()] attempts to correctly assign the `by` when left `NULL` (the default)
#' based on detecting the data tibble structure of `x` and `y`.
#'
#' @inheritParams extract_tibbles
#' @param type A character string for the type of join to be performed borrowing from
#' dplyr. One of "left", "right", "inner", or "full". Default "left".
#' @inheritParams dplyr::inner_join
#'
#'
#' @returns A `tibble`.
#'
#' @export

join_data_tibbles <- function(supertbl,
                              x,
                              y,
                              by = NULL,
                              type = "left",
                              suffix = c(".x", ".y")) {
  record_id_field <- get_record_id_field(supertbl$redcap_data[[1]]) # nolint: object_usage_linter
  join_fn <- get_join_fn(type)

  # Append the supertibble with the primary keys column
  supertbl <- supertbl |>
    mutate(pks = purrr::map_chr(.data$redcap_data, ~ extract_keys(., record_id_field = record_id_field))) %>%
    select(.data$redcap_form_name, .data$redcap_form_label, .data$redcap_data,
           .data$redcap_metadata, .data$structure, .data$pks, matches("redcap_events"))

  tbl_x <- extract_tibble(supertbl, x)
  tbl_x_structure <- get_structure(supertbl, x)
  tbl_y <- extract_tibble(supertbl, y)
  tbl_y_structure <- get_structure(supertbl, y)

  # Mixed structure requires special handling
  is_mixed <- any(c(tbl_x_structure, tbl_y_structure) == "mixed")

  if (is_mixed) {
    # TODO: Determine if ok to remove
    required_columns <- c("redcap_event_instance", "redcap_form_instance") # nolint: commented_code_linter
    tbl_x <- add_missing_columns(tbl_x, required_columns) # nolint: commented_code_linter
    tbl_y <- add_missing_columns(tbl_y, required_columns) # nolint: commented_code_linter

    tbl_x_type <- get_type(supertbl, x)
    tbl_y_type <- get_type(supertbl, y)

    # Add on .repeat_type specifier for the redcap_event column
    tbl_x <- left_join(tbl_x, tbl_x_type, by = "redcap_event")
    tbl_y <- left_join(tbl_y, tbl_y_type, by = "redcap_event")
  }

  join_fn <- get_join_fn(type)
  by <- build_by(supertbl, x, y, is_mixed)

  join_fn(tbl_x, tbl_y, by, suffix) %>%
    relocate(starts_with("form_status_complete"), .after = everything()) %>%
    select(-starts_with(".repeat_type"))
}

#' @title Extract the primary keys associated with a data tibble
#'
#' @param data_tbl A data tibble from a supertibble
#' @param record_id_field The record ID field for the REDCap project, retrieved
#' as an ouput of [get_record_id_field()]
#'
#' @returns a character string
#'
#' @keywords internal
extract_keys <- function(data_tbl, record_id_field) {
  redcap_keys <- c(
    record_id_field, "redcap_event", "redcap_form_instance",
    "redcap_event_instance", "redcap_arm"
  )

  data_tbl |>
    colnames() |>
    intersect(redcap_keys) |>
    paste(collapse = ", ")
}

#' @title Retrieve the structure data for a form from the supertibble
#'
#' @inheritParams join_data_tibbles
#' @param tbl_name the `x` or `y` values assigned to `join_data_tibbles`
#'
#' @keywords internal
get_structure <- function(supertbl, tbl_name) {
  supertbl$structure[supertbl$redcap_form_name == tbl_name]
}

#' @title Retrieve the repeat event type data for a form from the supertibble
#'
#' @inheritParams join_data_tibbles
#' @param tbl_name the `x` or `y` values assigned to `join_data_tibbles`
#'
#' @keywords internal
get_type <- function(supertbl, tbl_name) {
  supertbl %>%
    filter(.data$redcap_form_name == tbl_name) %>%
    pull(.data$redcap_events) %>%
    pluck(1) %>%
    select(.data$redcap_event,
           ".repeat_type" = .data$repeat_type) %>%
    unique()
}

#' @title Retrieve the appropriate user specified join function
#'
#' @inheritParams join_data_tibbles
#'
#' @returns a function
#'
#' @keywords internal
get_join_fn <- function(type) {
  join_functions <- list(
    left = dplyr::left_join,
    right = dplyr::right_join,
    inner = dplyr::inner_join,
    full = dplyr::full_join
  )

  if (!type %in% names(join_functions)) {
    cli::cli_abort("Invalid join type. Choose from 'left', 'right', 'inner', or 'full'.")
  }

  join_functions[[type]]
}

#' @title Intelligently retrieve the join by cols
#'
#' @inheritParams join_data_tibbles
#' @param is_mixed TRUE/FALSE, whether or not the given tables contain a mixed structure
#'
#' @returns a character vector
#'
#' @keywords internal
build_by <- function(supertbl, x, y, is_mixed) {
  x_pks <- supertbl$pks[supertbl$redcap_form_name == x] %>%
    stringr::str_split(", ", simplify = TRUE)
  y_pks <- supertbl$pks[supertbl$redcap_form_name == y] %>%
    stringr::str_split(", ", simplify = TRUE)

  out <- intersect(x_pks, y_pks)

  if (is_mixed) {
    # For mixed tables, depending on the .repeat_types present tables may not
    # have event and form instance columns and must be added
    out <- union(out, c("redcap_event_instance", "redcap_form_instance"))
  }

  out
}

#' @keywords intenral
#' @noRd
add_missing_columns <- function(tbl, columns) {
  missing_cols <- setdiff(columns, names(tbl))
  tbl[missing_cols] <- NA
  return(tbl)
}

#' @title Join data tbls of various structures and types
#'
#' @description
#' [join_tbls()] either performs the `join_fun()` specified by the `type` or, in
#' the event of mixed structure data tibble joins, will seek to split data into
#' three categories before performing the joins. The key identifiers here are
#' `redcap_form_instance` and the added `.repeat_type` columns.
#'
#' @inheritParams join_data_tibbles
#' @param join_fn the user specified join function type output by [get_join_fn()]
#' @param is_mixed TRUE/FALSE mixed data structure
#'
#' @returns a dataframe
#'
#' @keywords internal

join_tbls <- function(x, y, join_fn, by, suffix, is_mixed) {
  if (is_mixed) {
    # Filter based on .repeat_type
    # If repeating together events, can use redcap_form_instance (NA) and redcap_event_instance
    x_together <- x %>% filter(.data$.repeat_type == "repeat_together")
    y_together <- y %>% filter(.data$.repeat_type == "repeat_together")

    # repeating instruments for separately repeating events shouldn't be joined by redcap_form_instance
    x_separate_repeating <- x %>% filter(.data$.repeat_type == "repeat_separate"  & !is.na(.data$redcap_form_instance))
    y_separate_repeating <- y %>% filter(.data$.repeat_type == "repeat_separate"  & !is.na(.data$redcap_form_instance))

    # nonrepeating instruments for separately repeating events should be joined by redcap_form_instance
    x_separate_nonrepeating <- x %>% filter(.data$.repeat_type == "repeat_separate" & is.na(.data$redcap_form_instance))
    y_separate_nonrepeating <- y %>% filter(.data$.repeat_type == "repeat_separate" & is.na(.data$redcap_form_instance))

    # Join together sets
    joined_together <- x_together %>%
      join_fn(y_together, by = by, suffix = suffix)

    joined_separate_repeating <- x_separate_repeating %>%
      join_fn(y_separate_repeating, by = by[by != "redcap_form_instance"], suffix = suffix)

    joined_separate_nonrepeating <- x_separate_nonrepeating %>%
      join_fn(y_separate_nonrepeating, by = by, suffix = suffix)

    # Bind rows together, issue in arrangmenet of output
    result <- bind_rows(joined_together, joined_separate_repeating) %>%
      bind_rows(joined_separate_nonrepeating) %>%
      drop_non_suffix_columns()
  } else {
    result <- join_fn(x, y, by = by, suffix = suffix)
  }
  result
}

drop_non_suffix_columns <- function(data) {
  # Extract column names that contain a "."
  # Note: We can look for periods because REDCap will not allow variables to made
  # with them. Only user tampering with column names in the output would result in this.
  dot_columns <- names(data)[grepl("\\.", names(data))]

  # Extract the base column names without the suffixes (everything before the ".")
  base_columns <- unique(sub("\\..*", "", dot_columns))

  # Filter out base columns that do not exist without a suffix
  columns_to_drop <- base_columns[base_columns %in% names(data)]

  # Drop only those base columns that exist both with and without suffixes
  data <- data %>%
    select(-all_of(columns_to_drop))

  return(data)
}
