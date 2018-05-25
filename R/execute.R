#' Visualize all colum
#'
#' @inheritParams generic_exported
#' @param transformer A transformation function that defines the concrete
#'   visualization.
#' @param sub_dir The name of the sub-directory under ./whakahou used to
#'   save the data under, if you select a transformer with side effects. If
#'   set to `NULL` (the default), the name of the argument `data` is taken.
#' @param called_for_side_effects Whether or not the function is called for it's
#'   side effects. If `NULL` (the default), this is inferred from `transformer`.
#'   If `transformer` ends with "file", it is assumed that the function is
#'   called *only* for its side effects and no output to the console is
#'   returned.
#' @param k_dimensional The number of dimensions of the plot. If `NULL` (the
#'   default), then it is inferred from `transformer` in the following way. This
#'   works if the transformer is named after the convention
#'   `[something]_[nd]_[something]` whereas `[something]` may not contain an
#'   underscore and `n` is the number of dimensions. An example of a
#'   transformer meeting this requirement is [vis_1d_distr()].
#' @importFrom purrr map walk invoke map
#' @importFrom rlang quos
#' @examples
#' # one aesthetic
#' vis_cols(mtcars, 2) %>%
#'   flatten_gg()
#' vis_cols(mtcars, contains("c"), "vs", transformer = vis_1d_distr) %>%
#'  merge_vis()
#' # all combinations of multiple aesthetics
#' mtcars %>%
#'   transform_cols("vs", "as.factor") %>%
#'   vis_cols(vs, hp, cyl, transformer = vis_2d_point) %>%
#'   dplyr::slice(1) %>%
#'   flatten_gg()
#' @importFrom rlang enquos
#' @export
vis_cols <- function(data,
                     ...,
                     transformer = vis_1d_distr,
                     sub_dir = NULL,
                     called_for_side_effects = NULL,
                     k_dimensional = NULL) {
  transformer_name <- deparse(substitute(transformer))
  k_dimensional <- set_null_to(k_dimensional, k_dimensional(transformer_name))
  vars <- set_vars(enquos(...), data, k_dimensional)
  data_name <- deparse(substitute(data))

  called_for_se <- set_called_for_side_effects(
    called_for_side_effects, transformer_name
  )

  if (called_for_se) {
    sub_dir <- set_null_to(sub_dir, data_name)
    if (sub_dir == ".") {
      sub_dir <- NULL
    }
    walk(vars, transformer, sub_dir = sub_dir, data = data)
  } else {
    out <- map(vars, transformer, data = data) %>%
      invoke(rbind, .)
    out$data <- data_name
    out
  }
}

#' @importFrom rlang abort quo_text
#' @importFrom purrr map_if map_chr
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
  peeled <- map_if(peeled, class %in% "name", quo_text)
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



#' Merge visualizations into one
#'
#' Simple wrapper around [gridExtra::grid.arrange()].
#' @param data A `gg table`, that is, a data frame with plots, see [blow_gg()].
#' @param ... Further parameters passed to [gridExtra::grid.arrange()].
#' @importFrom purrr invoke
#' @examples
#' plots <- vis_cols(iris, transformer = vis_1d_distr)
#' merge_vis(plots)
#' @export
merge_vis <- function(data, ...) {
  invoke(gridExtra::grid.arrange, data$gg, ...)
}

#' Define the aspect ration and it's scale
#'
#' Convenient wrapper for specifying height and width.
#' @param ratio The aspect ratio.
#' @param scale How to transform the ration to obtain width and heigh.
#' @param units The measurement unit, e.g. "cm". See [grid::unit()].
#' @export
width_heigh_from_aspect_ratio <- function(ratio = 16/9, scale = 5, units = "cm") {
  grid::unit(scale * c(ratio, 1 / ratio), units)
}
