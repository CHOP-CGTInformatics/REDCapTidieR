join_data_tibbles <- function(suprtbl,
                              x,
                              y,
                              by = NULL,
                              type = "left",
                              suffix = c(".x", ".y")) {
  record_id_field <- get_record_id_field(suprtbl$redcap_data[[1]])
  join_fn <- get_join_fn(type)

  # Append the supertibble with the primary keys column
  suprtbl <- suprtbl |>
    mutate(pks = purrr::map_chr(redcap_data, ~extract_keys(., record_id_field = record_id_field))) %>%
    select(redcap_form_name, redcap_form_label, redcap_data, redcap_metadata, structure, pks)

  tbl_x <- extract_tibble(suprtbl, x)
  tbl_x_type <- get_structure(suprtbl, x)
  tbl_y <- extract_tibble(suprtbl, y)
  tbl_y_type <- get_structure(suprtbl, y)

  # Mixed structure requires special handling
  is_mixed <- any(c(tbl_x_type, tbl_y_type) == "mixed")

  if (is_mixed) {
    required_columns <- c("redcap_event_instance", "redcap_form_instance")
    tbl_x <- add_missing_columns(tbl_x, required_columns)
    tbl_y <- add_missing_columns(tbl_y, required_columns)
  }

  join_fn <- get_join_fn(type)
  by <- build_by(suprtbl, x, y, is_mixed)

  join_fn(tbl_x, tbl_y, by = by, suffix = suffix) %>%
    relocate(starts_with("form_status_complete"), .after = everything())
}

extract_keys <- function(suprtbl, record_id_field) {
  redcap_keys <- c(record_id_field, "redcap_event", "redcap_form_instance",
                   "redcap_event_instance", "redcap_arm")

  suprtbl |>
    colnames() |>
    intersect(redcap_keys) |>
    paste(collapse = ", ")
}

get_structure <- function(suprtbl, tbl_name) {
  tbl <- extract_tibble(suprtbl, tbl = tbl_name)
  suprtbl$structure[suprtbl$redcap_form_name == tbl_name]
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

add_missing_columns <- function(tbl, columns) {
  missing_cols <- setdiff(columns, names(tbl))
  tbl[missing_cols] <- NA
  return(tbl)
}

