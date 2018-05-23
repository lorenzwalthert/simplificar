#' Plot a distribution
#'
#' Functions to create a distribution plot to be sent to the console or written
#' to a file.
#' @inheritParams generic_exported
#' @param data A data frame with data to visualize.
#' @param aes A string to indicate the column for which a distribution should
#'   be shown.
#' @param fill The color to fill the density area with.
#' @param ... Passed to the geom. See 'Details'.
#' @details
#' The following types are implemented:
#'
#' * Histogram for discrete data with the following geom:
#'   [ggplot2::geom_histogram()].
#' * Density Plot for continuous data with the following geom:
#'   [ggplot2::geom_density()].
#'
#' If the column has not the target class, you can convert one or multiple
#' columns easily with [transform_cols()].
#' @examples
#' vis_1d_distr(mtcars, aes = "cyl") %>%
#'   flatten_gg()
#' @name vis_1d_distr
NULL

#' @describeIn vis_1d_distr Create a visualization and returns it in the
#'   console.
#' @export
vis_1d_distr <- function(data,
                         aes,
                         name = NULL,
                         geom = NULL,
                         fill = "gray60",
                         ...) {
  dots <- set_dots(...)
  name <- set_name(name, aes)
  class <- class(unlist(data[, aes]))
  geom <- set_null_to(geom, set_1d_geom_distr(class))
  plot <- ggplot(data, invoke(aes_string, aes)) +
    invoke(geom, c(fill = fill, dots)) + xlab(name)
  tibble(
    data = deparse(substitute(data)),
    aes_string = concentrate(aes),
    class_string = concentrate(class),
    gg = list(plot),
    aes = list(aes),
    class = list(class)
  )
}

#' @include templates.R
#' @describeIn vis_1d_distr The same as vis_1d_distr, but called for its side
#'   effect, i.e. to save the visualization to a file.
#' @importFrom purrr partial
#' @inheritParams vis_to_file
#' @inheritParams vis_1d_distr
#' @export
vis_1d_distr_to_file <- function(data,
                                 aes,
                                 name = NULL,
                                 geom = NULL,
                                 fill = "gray60",
                                 sub_dir = NULL,
                                 file = file_path(
                                   pkg_name(), sub_dir, time_stamp(name)
                                 ),
                                 dimensions = rep(unit(5, "cm"), 2),
                                 device = "pdf") {
  vis_to_file(vis_1d_distr,
    data = data,
    aes = aes,
    name = name,
    sub_dir = sub_dir,
    file = file,
    dimensions = dimensions,
    device = device
  )
}

