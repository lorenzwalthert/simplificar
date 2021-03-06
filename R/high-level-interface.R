#' Visualize all columns
#'
#' @inheritParams generic_exported
#' @param transformer A transformation function that defines the concrete
#'   visualization.
#' @param sub_dir The name of the sub-directory under ./simplificar used to
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
#' vis_cols(mtcars, contains("c"), "vs",
#'   transformer = vis_distr, k_dimensional = 2
#' ) %>%
#'  merge_vis()
#' # all combinations of multiple aesthetics
#' mtcars %>%
#'   transform_cols("vs", "as.factor") %>%
#'   vis_cols(vs, hp, cyl, transformer = vis_2d_point) %>%
#'   dplyr::slice(1) %>%
#'   flatten_gg()
#'
#' dummy_types %>%
#'   vis_cols(num1, fct1, int1, transformer = vis_2d_distr) %>%
#'   merge_vis()
#' @importFrom rlang enquos
#' @importFrom purrr map_chr
#' @export
vis_cols <- function(data,
                     ...,
                     transformer = vis_1d_distr,
                     sub_dir = NULL,
                     called_for_side_effects = NULL,
                     k_dimensional = NULL,
                     return_vis = FALSE) {
  transformer_name <- deparse(substitute(transformer))
  k_dimensional <- set_null_to(k_dimensional, k_dimensional(transformer_name))
  data_name <- deparse(substitute(data))
  vars <- set_vars(enquos(...), names(data), k_dimensional)


  called_for_se <- set_called_for_side_effects(
    called_for_side_effects, transformer_name
  )

  if (called_for_se & !return_vis) {
    sub_dir <- set_null_to(sub_dir, data_name)
    if (sub_dir == ".") {
      sub_dir <- NULL
    }
    out <- map_chr(vars, transformer, sub_dir = sub_dir, data = data) %>%
      invisible()
  } else {
    if (grepl("_to_file$", deparse(substitute(transformer)))) {
    out_raw <- map(vars, transformer,
      sub_dir = sub_dir, data = data, return_vis = return_vis
    )
    } else {
      out_raw <- map(vars, transformer, data = data)
    }
    out <- out_raw %>%
      invoke(rbind, .)
    out$data <- data_name
  }
  out
}

#' Define the aspect ration and it's scale
#'
#' Convenient wrapper for specifying height and width.
#' @param ratio The aspect ratio.
#' @param scale How to transform the ration to obtain width and heigh.
#' @param units The measurement unit, e.g. "cm". See [grid::unit()].
#' @export
width_height_from_aspect_ratio <- function(ratio = 16 / 9, scale = 5, units = "cm") {
  grid::unit(scale * c(ratio, 1 / ratio), units)
}
