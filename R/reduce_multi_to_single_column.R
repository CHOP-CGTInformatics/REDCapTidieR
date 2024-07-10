reduce_multi_to_single_column <- function(supertbl, tbl, cols, raw_or_label = "label", cols_to, multi_val = "Multiple") {

  cols_exp <- enquo(cols)

  data_tbl <- supertbl %>%
    extract_tibble(tbl)

  project_identifier <- supertbl$redcap_metadata[[1]]$field_name[[1]]

  out <- data_tbl %>%
    select(project_identifier, !!!eval_select(cols_exp, data_tbl))

  field_names <- names(out)[names(out) != project_identifier]

  out <- out %>%
    mutate(
      !!cols_to := case_when(rowSums(select(., starts_with("race"))) > 1 ~ TRUE,
                       TRUE ~ FALSE)

    )

  metadata <- supertbl$redcap_metadata[supertbl$redcap_form_name == tbl][[1]] %>%
    filter(field_name %in% names(out)[names(out) != project_identifier]) %>%
    select(field_name, select_choices_or_calculations) %>%
    mutate(
      original_field = sub("___.*$", "", field_name)
    ) %>%
    mutate(pairs = strsplit(select_choices_or_calculations, " \\| "),
           label_value = NA)

  for(i in seq(nrow(metadata))) {
    metadata$label_value[i] <- metadata$pairs[[i]][i]
  }

  metadata <- metadata %>%
    tidyr::separate_wider_delim(label_value, delim = ", ", names = c("raw", "label")) %>%
    select(field_name, raw, label)

  replace_true <- function(col, col_name, metadata, raw_or_label) {
    replacement <- metadata %>% filter(field_name == col_name) %>% pull(raw_or_label)
    col <- ifelse(col == TRUE, replacement, NA) # col == TRUE works for raw or label because TRUE == 1 and 1 == TRUE
    # Convert non-TRUEs to NA, since values can be either "FALSE" or "0" for unchecked values
    return(col)
  }

  out <- out %>%
    mutate(across(-c(project_identifier, !!cols_to), ~ replace_true(.x,
                                                                    dplyr::cur_column(),
                                                                    metadata = metadata,
                                                                    raw_or_label = raw_or_label)))

  out <- out %>%
    mutate(across(field_names, as.character), # enforce to character strings
           # across(field_names, ~case_when(. == "FALSE" ~ NA_character_, TRUE ~ .)),
           across(!!cols_to, ~as.character(.))) %>%
    rowwise() %>%
    mutate(
      !!cols_to := ifelse(!!rlang::sym(cols_to) == "TRUE", multi_val, NA_character_),
      !!cols_to := ifelse(is.na(!!rlang::sym(cols_to)),
                      ifelse(any(c_across(cols) != "FALSE"),
                             na.omit(c_across(cols)[c_across(cols) != "FALSE"])[1],
                             NA_character_),
                      !!rlang::sym(cols_to))
    ) %>%
    ungroup() %>%
    select(project_identifier, !!cols_to) %>%
    mutate(
      !!cols_to := factor(!!rlang::sym(cols_to), levels = c(metadata[[raw_or_label]], multi_val))
    )

  out %>%
    right_join(data_tbl, by = project_identifier) %>%
    relocate(!!cols_to, .after = everything())
}

