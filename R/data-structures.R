#' Common conversions
#'
#' Common conversation operations between objects of class gg (called raw gg)
#' and tabular extensions of it (called gg table) that contains meta
#' information.
#' @param tbl A tibble.
#' @param ... Objects of class `gg`, that is, plots created with `ggplot`.
#' @name gg_conversions
#' @examples
#' gg_table <- vis_cols(mtcars, 2)
#' gg_raw <- gg_table %>%
#'   flatten_gg()
#' # the reverse operation (only column gg can be restored)
#' gg_raw %>%
#'   blow_gg()
#' @family post-creation manipulators
NULL

#' @describeIn gg_conversions Flattens a gg table into its raw counterpart.
#' @export
flatten_gg <- function(tbl) {
  stopifnot(nrow(tbl) == 1L)
  tbl$gg[[1]]
}

blow_gg_one <- function(gg) {
  blown <- tibble(
    !!! gg_tbl_cols()
  )
  blown$gg <- list(gg)
  blown
}

#' @describeIn gg_conversions Blows up a raw gg into a gg table.
#' @export
blow_gg <- function(...) {
  map(list(...), blow_gg_one) %>%
    invoke(rbind, .) %>%
    as_tibble()
}

concentrate <- function(aes) {
  paste0(unlist(aes), collapse = ", ")
}

#' @describeIn gg_conversions extract a raw gg given it's row number in the
#'   gg table.
#' @param index An index. Positive numbers refer to the nth plot in the
#'   gg table, negative numbers count backwards.
#' @export
#' @family post-creation manipulators
pull_gg <- function(tbl, index = 1) {
  index <- ifelse(index < 0, nrow(tbl) + index + 1, index)
  tbl$gg[[index]]

}

gg_tbl_cols <- function() {
  quos(data = NA, aes_string = NA, class_string = NA, gg = NA, aes = NA, class = NA)
}


#' Mutate gg raw objects in a gg table
#'
#' A dplyr-like mutate to modify certain gg raw objects in a gg table.
#' @param data A gg table.
#' @param add Terms to add to the plot.
#' @param ... Positional indices that indicate the row for which the
#'   corresponding raw gg object should be modified. If empty, all columns
#'   are modified.
#' @importFrom purrr map_at
#' @importFrom stats as.formula
#' @examples
#' mtcars %>%
#'   vis_cols(vs, contains("hp"), "cyl", transformer = vis_2d_point) %>%
#'   mutate_gg(ggplot2::stat_summary(fun.y = mean, geom = "line"), 2, 3) %>%
#'   pull_gg(2)
#' @export
#' @family post-creation manipulators
#' @importFrom rlang seq2
mutate_gg <- function(data, add, ...) {
  dots <- set_dots_mutate(..., nrow = nrow(data))
  form <- as.formula(paste0("~.x + ", deparse(substitute(add))))
  data$gg <- map_at(data$gg, dots, form)
  data
}

set_dots_mutate <- function(..., nrow) {
  dots <- c(...)
  if (length(dots) == 0L) {
    seq2(1, nrow)
  } else {
    dots
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
#' @family post-creation manipulators
merge_vis <- function(data, ...) {
  invoke(gridExtra::grid.arrange, data$gg, ...)
}
