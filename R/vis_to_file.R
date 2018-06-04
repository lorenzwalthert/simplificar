#' Create a visualization and save it to a file
#'
#' These functions do exactly what their counterparts without the `to_file`
#' extension in the function name do, but they save the output to a file.
#' They are called for their side effects only.
#' E.g. [vis_1d_distr_to_file()] does what [vis_1d_distr()]
#' does plus saving the output to a file.
#' @importFrom purrr partial
#' @return
#' Returns the file name to which the visualization was written invisibly.
#' @name vis_to_file
NULL

#' @rdname vis_to_file
#' @inheritParams vis_to_file
#' @inheritParams vis_distr
#' @export
vis_distr_to_file <- function(data,
                                 aes,
                                 name = aes,
                                 geom = NULL,
                                 fill = "gray60",
                                 sub_dir = deparse(substitute(data)),
                                 file = file_path(
                                   pkg_name(), sub_dir, time_stamp(name)
                                 ),
                                 dimensions = rep(unit(5, "cm"), 2),
                                 device = "pdf",
                              return_vis = FALSE,
                                 ...) {
  vis_to_file_impl(vis_1d_distr,
                   data = data,
                   aes = aes,
                   name = name,
                   geom = geom,
                   sub_dir = sub_dir,
                   file = file,
                   dimensions = dimensions,
                   device = device,
                   return_vis = return_vis,
                   ...,
                   # arguments added to dots
                   fill = fill
  ) %>%
    invisible()
}

#' @rdname vis_to_file
#' @export
vis_1d_distr_to_file <- vis_distr_to_file

#' @rdname vis_to_file
#' @export
vis_2d_distr_to_file <- vis_distr_to_file

#' @include templates.R
#' @rdname vis_to_file
#' @inheritParams vis_to_file_impl
#' @inheritParams vis_point
#' @export
vis_point_to_file <- function(data,
                                 aes,
                                 name = aes,
                                 sub_dir = deparse(substitute(data)),
                                 file = file_path(
                                   pkg_name(), sub_dir, time_stamp(name)
                                 ),
                                 dimensions = rep(unit(5, "cm"), 2),
                              device = "pdf",
                              return_vis = FALSE,
                                 ...) {
  vis_to_file_impl(vis_2d_point,
                   data = data,
                   aes = aes,
                   name = name,
                   sub_dir = sub_dir,
                   file = file,
                   dimensions = dimensions,
                   device = device,
                   return_vis = return_vis,
                   ...
  )
}

#' @rdname vis_to_file
#' @export
vis_1d_point_to_file <- vis_point_to_file


#' @rdname vis_to_file
#' @export
vis_2d_point_to_file <- vis_point_to_file
