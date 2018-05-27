#' Select variables
#'
#' Wrapper around [tidyselect::vars_select()] with some pre-and post-processing.
#' Most notable, for any number of selected variables that are greater than
#' the number of dimensions, all sets of combinations of the variables with
#' cardinality `k_dimensional` are formed.
#' @param quos Captured variables with `rlang::quos()`.
#' @param data_name All column names of the data from which to select.
#' @param k_dimensional The cardinality of the transformer.
#' @importFrom rlang abort quo_text
#' @importFrom purrr map2 map_chr
#' @importFrom utils combn
#' @importFrom glue glue
vars_from_quo <- function(quos, data_name, k_dimensional) {
  vars <- tidyselect::vars_select(data_name, !!! quos) %>%
    unlist() %>%
    unname()
  if (length(vars) < k_dimensional) {
    abort(glue(
      "You need to select at least as many variables as your transformer has ",
      "dimensions. The selected variables are {vars}. The dimension of the ",
      "transformer is {k_dimensional}."
    ))
  }
  vars %>%
    combn(k_dimensional, simplify = FALSE) %>%
    map(unlist)
}
