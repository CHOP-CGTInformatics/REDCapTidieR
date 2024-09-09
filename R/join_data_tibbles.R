join_data_tibbles <- function(suprtbl, x, y, by = NULL, type = "left", name = "new_tibble", suffix = c(".x", ".y")) {
  record_id_field <- get_record_id_field(suprtbl$redcap_data[[1]])

  # Append the supertibble with the primary keys column
  suprtbl <- suprtbl |>
    mutate(pks = purrr::map_chr(redcap_data, ~extract_keys(., record_id_field = record_id_field))) %>%
    select(redcap_form_name, redcap_form_label, redcap_data, redcap_metadata, structure, pks)

  tbl_x <- prepare_tibble(suprtbl, x)
  tbl_y <- prepare_tibble(suprtbl, y)

  # Define a named list of join functions corresponding to the join types
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

  # Mixed structure requires special handling
  is_mixed <- any(c(attr(tbl_x, "structure"), attr(tbl_y, "structure")) == "mixed")

  if (is_mixed) {
    stop("Mixed structure table detected, this feature is not currently supported.") # TODO: Fix, this is the complicated part
  } else {
    rlang::exec(
      join_functions[[type]], tbl_x, tbl_y, by = intersect(attr(tbl_x, "pks"), attr(tbl_y, "pks")), suffix
    )
  }
}

extract_keys <- function(suprtbl, record_id_field) {
  redcap_keys <- c(record_id_field, "redcap_event", "redcap_form_instance",
                   "redcap_event_instance", "redcap_arm")

  suprtbl |>
    colnames() |>
    intersect(redcap_keys) |>
    paste(collapse = ", ")
}

prepare_tibble <- function(suprtbl, tbl_name) {
  tbl <- extract_tibble(suprtbl, tbl = tbl_name)
  attributes(tbl)$structure <- suprtbl$structure[suprtbl$redcap_form_name == tbl_name]
  attributes(tbl)$pks <- suprtbl$pks[suprtbl$redcap_form_name == tbl_name] %>%
    stringr::str_split(", ", simplify = TRUE)
  return(tbl)
}
