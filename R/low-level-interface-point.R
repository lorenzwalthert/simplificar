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
vis_point <- function(data,
                         aes,
                         names = aes,
                         geom = NULL,
                         ...) {
  data <- as_tibble(data)
  aes <- set_aes(aes, names(data))
  names <- set_null_to(names, aes)
  class <- data[, aes] %>%
    map_chr(~class(.x)[1])
  geom <- set_null_to(geom, set_geom_point(class))
  dots <- drop_unnamed_dots(...)
  plot <- ggplot(data, invoke(aes_string, aes)) +
    invoke(eval(geom), dots) + xlab(names[1]) + ylab(names[2])
  tbl_output(data, aes, class, plot)
}

#' @export
#' @rdname vis_point
vis_1d_point <- vis_point

#' @export
#' @rdname vis_point
vis_2d_point <- vis_point
