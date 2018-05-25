#' Visualize to a file
#'
#' @param transformer `[template parameter]` The bare name of the tranformer to
#'   use, e.g. `vis_2d_point`.
#' @param aes A string to indicate the column for which a distribution should
#'   be shown.
#' @inheritParams generic_exported
#' @param sub_dir The sub-directory to save the plot. marely used to
#'   construct the `file` argument.
#' @param file The path to the file where the visualization should be stored.
#'   The file may contain an extension - or the extension can be specified with
#'   the `device` argument.
#' @param dimensions Height and width constructed with [grid::unit()],
#'   passed to [ggplot2::ggsave()].
#' @name vis_to_file
vis_to_file <- function(transformer,
                        data,
                        aes,
                        name = NULL,
                        geom = NULL,
                        sub_dir = NULL,
                        file = file_path(
                          pkg_name(), sub_dir, time_stamp(name)
                        ),
                        dimensions = rep(unit(5, "cm"), 2),
                        ...) {
  ensure_dir(dirname(file))
  plot <- transformer(data, aes, name, geom, ...) %>%
    flatten_gg()

  ggsave(
    file,
    plot = plot,
      width = dimensions[1],
      height = dimensions[2]
  )
  invisible(file)
}
