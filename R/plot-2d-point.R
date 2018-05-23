#' Create a scatter plot
#'
#' Functions to create a scatter plot to be sent to the console or written
#' to a file.
#' @param aes A character vector to indicate the columns that should be mapped.
#'   Passed to [ggplot2::aes_string()]. Note that you can also plot aesthetics
#'   other than x and y too.
#' @inheritParams vis_1d_distr
#' @inheritParams generic_exported
#' @examples
#' # ordinary scatter plots for continuous data
#' plot <- vis_2d_point(iris,
#'   c(x = "Sepal.Width", y = "Sepal.Length", size = "Petal.Width")
#' )
#' plot %>%
#'   dplyr::filter(purrr::map_lgl(.data$aes, ~ any(.x %in% "Sepal.Length")))
#' # jitter plots if both variables are categorical
#' mtcars %>%
#'   transform_cols(c("vs", "am"), "as.factor") %>%
#'   vis_2d_point(c("vs", "am"), width = 0.1, height = 0.1) %>%
#'   pull_gg()
#' @export
vis_2d_point <- function(data,
                         aes,
                         names = NULL,
                         geom = NULL,
                         ...) {
  names <- set_name(names, aes)
  class <- data[, aes] %>%
    map_chr(~class(.x)[1])
  geom <- set_null_to(geom, set_2d_geom_point(class))
  dots <- set_dots(...)
  plot <- ggplot(data, invoke(aes_string, aes)) +
    invoke(geom, dots) + xlab(names[1]) + ylab(names[2])
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
#' @describeIn vis_2d_point The same as vis_2d_point, but called for its side
#'   effect, i.e. to save the visualization to a file.
#' @importFrom purrr partial
#' @inheritParams vis_to_file
#' @inheritParams vis_2d_point
#' @export
vis_2d_point_to_file <- function(data,
                                 aes,
                                 name = aes,
                                 sub_dir = NULL,
                                 file = file_path(
                                   pkg_name(), sub_dir, time_stamp(name)
                                 ),
                                 dimensions = rep(unit(5, "cm"), 2),
                                 device = "pdf") {
  vis_to_file(vis_2d_point,
    data = data,
    aes = aes,
    name = name,
    sub_dir = sub_dir,
    file = file,
    dimensions = dimensions,
    device = device
  )

}
