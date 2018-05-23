#' Column transformer
#'
#' Convert columns to a target class.
#' @param data Data to convert.
#' @param cols Character vector with columns to convert.
#' @param transformer A quoted function name that applies the conversion,
#'   e.g. `"as.numeric"`.
#' @param ... Arguments passed to the `transformer`.
#' @importFrom purrr map_at invoke
#' @examples
#' mtcars %>%
#'   transform_cols("vs", "readr::parse_factor", levels = 0:1) %>%
#'   transform_cols("vs", "forcats::fct_recode", low = "0", high = "1")
#' @export
transform_cols <- function(data, cols, transformer, ...) {
  transformer <- eval_txt(transformer) %>%
    partial(...)
  map_at(data, cols, ~ transformer(.x)) %>%
    as_tibble()
}
