#' Select variables
#'
#' Wrapper around [tidyselect::vars_select()] with some pre-and post-processing.
#' Most notable, for any number of selected varaiable
#' @importFrom rlang abort quo_text
#' @importFrom purrr map2 map_chr
#' @importFrom utils combn
vars_from_quo <- function(quos, data, k_dimensional) {
  tidyselect::vars_select(names(data), !!! quos) %>%
    unlist() %>%
    unname() %>%
    combn(k_dimensional, simplify = FALSE) %>%
    map(unlist)
}
