#' Superheroes Data
#'
#' A dataset of superheroes in a REDCapTidieR `supertbl` object
#'
#' @format
#' ## `heroes_information`
#' A `tibble` with 734 rows and 12 columns:
#' \describe{
#'   \item{record_id}{REDCap record ID}
#'   \item{name}{Hero name}
#'   \item{gender}{Gender}
#'   \item{eye_color}{Eye color}
#'   \item{race}{Race}
#'   \item{hair_color}{Hair color}
#'   \item{height}{Height}
#'   \item{weight}{Weight}
#'   \item{publisher}{Publisher}
#'   \item{skin_color}{Skin color}
#'   \item{alignment}{Alignment}
#'   \item{form_status_complete}{REDCap instrument completed?}
#' }
#'
#' ## `super_hero_powers`
#' A `tibble` with 5,966 rows and 4 columns:
#' \describe{
#'   \item{record_id}{REDCap record ID}
#'   \item{redcap_form_instance}{REDCap repeat instance}
#'   \item{power}{Super power}
#'   \item{form_status_complete}{REDCap instrument completed?}
#' }
#' @source <https://www.superherodb.com/>
"superheroes_supertbl"
