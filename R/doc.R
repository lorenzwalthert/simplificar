#' Generic data selection
#'
#' @param data The data to use for plotting.
#' @param name The name of the variable to plot. If `NULL` (the default), the
#'   name is inferred form `aes`.
#' @param names The names of the variables to plot. If `NULL` (the default),
#' the names are inferred form `aes`.
#' @param ... Variables to select. You can use tidy selectors such as
#'   `starts_with(...)`, see [tidyselect::select_helpers()] for details.
#' @param geom The bare name of the geom to use. If `NULL` (the default),
#'   it is determined by the class of the data to plot.
#' @param return_vis Whether or not the plot should, in addition to being
#'   written to a file, be the return value of the function call.
#' @name generic_exported
#' @keywords internal
NULL
