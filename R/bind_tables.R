#' Bind REDCap Tidy Tibbles to Specified Environments
#'
#' Supply a \code{read_redcap_tidy()} output to load REDCap data tables to specified environment locations.
#'
#' @param .data A tidy table provided by \code{read_redcap_tidy()}
#' @param environment The environment to assign the tidy data (default \code{global_env()}). For new environment, it is recommended to use \code{rlang::new_environment()}.
#' @param redcap_form_name Specify REDCap form names to load into environment. Default behavior is all forms.
#' @param structure Specify REDCap structure to load into environment, either \code{repeating} or \code{nonrepeating}. Defaults to all structures.
#'
#' @importFrom rlang env_poke current_env new_environment global_env
#' @importFrom purrr map2
#'
#' @export

bind_tables <- function(.data,
                        environment = global_env(),
                        redcap_form_name = NULL,
                        structure = NULL){

  # Name variables
  my_redcap_form_names <- redcap_form_name
  my_structures <- structure
  assigned_environment <- environment

  env_data <- .data

  # Apply conditional loading for specific forms or structures
  if (!is.null(my_redcap_form_names)) {
    env_data <- env_data %>%
      filter(redcap_form_name %in% my_redcap_form_names)
  }

  if (!is.null(my_structures)) {
    env_data <- env_data %>%
      filter(structure %in% my_structures)
  }

  table_names <- env_data %>%
    pull(redcap_form_name)

  # Map over table names and environment data to load into environment
  map2(.x = table_names,
       .y = env_data$redcap_data,
       .f = ~ env_poke(env = assigned_environment,
                       nm = .x,
                       value = .y)
  )

}
