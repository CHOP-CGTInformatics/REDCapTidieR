join_data_tibbles <- function(suprtbl, x, y, by = NULL, type = "left", name = "new_tibble", suffix = c(".x", ".y")) {
  record_id_field <- get_record_id_field(suprtbl$redcap_data[[1]])

  # Append the supertibble with the primary keys column
  suprtbl <- suprtbl |>
    mutate(pks = purrr::map_chr(redcap_data, ~extract_keys(., record_id_field = record_id_field))) %>%
    select(redcap_form_name, redcap_form_label, redcap_data, redcap_metadata, structure, pks)

  # Extract the user defined tibbles and assign the structure and pks to attributes
  tbl_x <- extract_tibble(suprtbl, tbl = x)
  attributes(tbl_x)$structure <- suprtbl$structure[suprtbl$redcap_form_name == x]
  attributes(tbl_x)$pks <- suprtbl$pks[suprtbl$redcap_form_name == x] %>% stringr::str_split(", ", simplify = TRUE)

  tbl_y <- extract_tibble(suprtbl, tbl = y)
  attributes(tbl_y)$structure <- suprtbl$structure[suprtbl$redcap_form_name == y]
  attributes(tbl_y)$pks <- suprtbl$pks[suprtbl$redcap_form_name == y] %>% stringr::str_split(", ", simplify = TRUE)

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
    return() # TODO: this is the complicated part
  } else {
    rlang::exec(
      join_functions[[type]], tbl_x, tbl_y, by = intersect(attr(tbl_x, "pks"), attr(tbl_y, "pks")), suffix
    )
  }
}

extract_keys <- function(suprtbl, record_id_field) {
  suprtbl |>
    colnames() |>
    intersect(c(record_id_field, "redcap_event", "redcap_form_instance", "redcap_event_instance", "redcap_arm")) |>
    paste(collapse = ", ")
}
