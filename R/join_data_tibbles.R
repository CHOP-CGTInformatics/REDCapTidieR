join_data_tibbles <- function(suprtbl,
                              x,
                              y,
                              by = NULL,
                              type = "left",
                              suffix = c(".x", ".y")) {
  record_id_field <- get_record_id_field(suprtbl$redcap_data[[1]]) # nolint: object_usage_linter
  join_fn <- get_join_fn(type)

  # Append the supertibble with the primary keys column
  suprtbl <- suprtbl |>
    mutate(pks = purrr::map_chr(.data$redcap_data, ~ extract_keys(., record_id_field = record_id_field))) %>%
    select(.data$redcap_form_name, .data$redcap_form_label, .data$redcap_data,
           .data$redcap_metadata, .data$structure, .data$pks, .data$redcap_events)

  tbl_x <- extract_tibble(suprtbl, x)
  tbl_x_structure <- get_structure(suprtbl, x)
  tbl_y <- extract_tibble(suprtbl, y)
  tbl_y_structure <- get_structure(suprtbl, y)

  # Mixed structure requires special handling
  is_mixed <- any(c(tbl_x_structure, tbl_y_structure) == "mixed")

  if (is_mixed) {
    # TODO: Determine if ok to remove
    # required_columns <- c("redcap_event_instance", "redcap_form_instance") # nolint: commented_code_linter
    # tbl_x <- add_missing_columns(tbl_x, required_columns) # nolint: commented_code_linter
    # tbl_y <- add_missing_columns(tbl_y, required_columns) # nolint: commented_code_linter

    tbl_x_type <- get_type(suprtbl, x)
    tbl_y_type <- get_type(suprtbl, y)

    tbl_x <- left_join(tbl_x, tbl_x_type, by = "redcap_event")
    tbl_y <- left_join(tbl_y, tbl_y_type, by = "redcap_event")
  }

  join_fn <- get_join_fn(type)
  by <- build_by(suprtbl, x, y, is_mixed)

  join_tbls(tbl_x, tbl_y, join_fn, by, suffix, is_mixed) %>%
    relocate(starts_with("form_status_complete"), .after = everything()) %>%
    select(-starts_with(".repeat_type"))
}

extract_keys <- function(suprtbl, record_id_field) {
  redcap_keys <- c(
    record_id_field, "redcap_event", "redcap_form_instance",
    "redcap_event_instance", "redcap_arm"
  )

  suprtbl |>
    colnames() |>
    intersect(redcap_keys) |>
    paste(collapse = ", ")
}

get_structure <- function(suprtbl, tbl_name) {
  suprtbl$structure[suprtbl$redcap_form_name == tbl_name]
}

get_type <- function(suprtbl, tbl_name) {
  suprtbl %>%
    filter(.data$redcap_form_name == tbl_name) %>%
    pull(.data$redcap_events) %>%
    pluck(1) %>%
    select(.data$redcap_event,
           ".repeat_type" = .data$repeat_type) %>%
    unique()
}

get_join_fn <- function(type) {
  join_functions <- list(
    left = dplyr::left_join,
    right = dplyr::right_join,
    inner = dplyr::inner_join,
    full = dplyr::full_join
  )

  # Check if the specified type is valid
  # TODO: Make a standard check function with cli
  if (!type %in% names(join_functions)) {
    stop("Invalid join type. Choose from 'left', 'right', 'inner', or 'full'.")
  }

  join_functions[[type]]
}

build_by <- function(suprtbl, x, y, is_mixed) {
  x_pks <- suprtbl$pks[suprtbl$redcap_form_name == x] %>%
    stringr::str_split(", ", simplify = TRUE)
  y_pks <- suprtbl$pks[suprtbl$redcap_form_name == y] %>%
    stringr::str_split(", ", simplify = TRUE)

  out <- intersect(x_pks, y_pks)

  if (is_mixed) {
    out <- c(out, "redcap_event_instance", "redcap_form_instance") %>%
      # TODO: Make standard, currently needed for repeat/mixed joins
      unique()
  }

  out
}

# TODO: Determine if ok to remove
add_missing_columns <- function(tbl, columns) {
  missing_cols <- setdiff(columns, names(tbl))
  tbl[missing_cols] <- NA
  return(tbl)
}

join_tbls <- function(x, y, join_fn, by, suffix, is_mixed) {
  if (is_mixed) {
    # Filter based on .repeat_type
    x_together <- x %>% filter(.data$.repeat_type == "repeat_together")
    y_together <- y %>% filter(.data$.repeat_type == "repeat_together")

    x_separate <- x %>% filter(.data$.repeat_type == "repeat_separate")
    y_separate <- y %>% filter(.data$.repeat_type == "repeat_separate")

    # Join together sets
    joined_together <- x_together %>%
      join_fn(y_together, by = by[by != "redcap_form_instance"], suffix = suffix)

    # Join separate sets
    joined_separate <- x_separate %>%
      join_fn(y_separate, by = by[by != "redcap_form_instance"], suffix = suffix)

    # Bind rows together
    result <- bind_rows(joined_together, joined_separate) %>%
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
