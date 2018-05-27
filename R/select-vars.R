#' Select variables
#'
#' Wrapper around [tidyselect::vars_select()].
#' @importFrom rlang abort quo_text
#' @importFrom purrr map2 map_chr
#' @importFrom utils combn
vars_from_quo <- function(quos, data, k_dimensional) {
  peeled <- map(quos, ~ rlang::get_expr(.x))
  class <- map_chr(peeled, ~ class(.x)[1])
  if (!all(class %in% c("name", "call", "character", "integer", "numeric"))) {
    abort(paste(
      "variables selected in ... must be either bare (e.g. vs),",
      "quoted (e.g. 'vs'), selected with a tidyselect verb",
      "(e.g. contains('vs') or indicate a column index."
    ))
  }
  peeled <- map2(peeled, class, function(var, class) {
    if (class %in% "name") {
      quo_text(var)
    } else {
      var
  }})
  peeled <- tidyselect::vars_select(names(data), !!! peeled) %>% unname()
  if (k_dimensional == 1) {
    unlist(peeled)
  } else {
    peeled %>%
      unlist() %>%
      unname() %>%
      combn(2, simplify = FALSE) %>%
      map(unlist)
  }
}
