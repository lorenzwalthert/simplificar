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
#' All functions documented here are just a forwarder to `vis_distr` and the
#' reason for their existence is because when used as an input to `vis_cols`,
#' the dimensions of the output can be derived from the name of the transformer,
#' so the argument `k_dimensional` does not have to be specified.
#' If the column has not the target class, you can convert one or multiple
#' columns easily with [transform_cols()].
#' @importFrom rlang set_names
#' @examples
#' vis_1d_distr(mtcars, aes = "cyl") %>%
#'   flatten_gg()
#' vis_distr(mtcars, aes = c("cyl", "vs")) %>%
#'   flatten_gg()
#' @export
vis_distr <- function(data,
                         aes,
                         name = aes,
                         geom = NULL,
                         fill = "gray60",
                         ...) {
  data <- as_tibble(data)
  aes <- set_aes(aes, names(data))
  class <- map_chr(data[, aes], ~class(.x)[1]) %>%
    set_names(names(aes))
  if(is.null(geom)) {
    geom <- set_nd_geom_distr(class, aes)
  } else {
    geom <- substitute(geom)
  }
  dots <- set_dots_distr(..., geom = substitute(geom), fill = fill)
  aes <- update_aes(class, aes, geom)
  name <- set_null_to(name, deparse(aes))

  plot <- ggplot(data, invoke(aes_string, aes)) +
    invoke(eval(geom), dots) + xlab(name)
  tibble(
    data = deparse(substitute(data)),
    aes_string = concentrate(aes),
    class_string = concentrate(class),
    gg = list(plot),
    aes = list(aes),
    class = list(class)
  )
}


#' @rdname vis_distr
#' @export
vis_1d_distr <- vis_distr

#' @rdname vis_distr
#' @export
vis_2d_distr <- vis_distr
