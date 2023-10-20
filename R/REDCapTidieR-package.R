#' @keywords internal
#' @aliases REDCapTidieR-package
#' @importFrom checkmate assert_character assert_data_frame check_character
#' check_choice check_environment check_logical expect_character expect_double
#' expect_factor expect_logical
#' @importFrom cli cli_abort cli_fmt cli_text cli_vec cli_warn qty
#' @importFrom dplyr %>% across bind_rows case_when filter group_by if_any if_else
#' left_join mutate pull recode relocate rename row_number select slice summarise
#' @importFrom formattable percent
#' @importFrom lobstr obj_size
#' @importFrom lubridate is.difftime is.period
#' @importFrom purrr compose map map2 map_int map_lgl pluck pmap_chr some
#' @importFrom REDCapR redcap_arm_export redcap_event_instruments redcap_instruments
#' redcap_metadata_read redcap_read_oneshot sanitize_token
#' @importFrom rlang .data !!! abort as_closure caller_arg caller_env catch_cnd
#' check_installed cnd_muffle current_call current_env enexpr enquo env_poke
#' eval_tidy get_env global_env is_atomic is_bare_formula is_bare_list
#' is_installed new_environment quo_get_expr try_fetch zap as_label
#' @importFrom stringi stri_split_fixed
#' @importFrom stringr str_detect str_replace str_replace_all str_squish str_trunc
#' str_trim
#' @importFrom tibble as_tibble is_tibble tibble
#' @importFrom tidyr complete fill pivot_wider nest unnest unnest_wider
#' @importFrom tidyselect all_of any_of ends_with eval_select everything
#' starts_with where
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
