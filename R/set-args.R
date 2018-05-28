set_nd_geom_distr <- function(class, aes) {
  if (length(aes) < 2L) {
    set_1d_geom_distr(class)
  } else {
    set_2d_geom_distr(class)
  }
}

#' @importFrom purrr when
set_1d_geom_distr <- function(class) {
  when(class,
       all((.) %in% c("numeric", "integer", "Date")) ~ quote(geom_density),
       all((.) %in% c("character", "factor")) ~  quote(geom_bar),
       ~ quote(geom_density)
  )
}

#' @importFrom purrr when
set_2d_geom_distr <- function(class) {
  when(class,
       all((.) %in% c("numeric", "integer")) ~ quote(geom_density_2d),
       (.["y"] %in% c("numeric", "integer")) &
          (.["x"] %in% c("factor", "character")) ~ quote(geom_violin),
       (.["x"] %in% c("numeric", "integer")) &
         (.["y"] %in% c("factor", "character")) ~ quote(geom_violin),
       ~ quote(geom_boxplot)
  )
}



set_geom_point <- function(class) {
  when(class,
       all((.) %in% c("character", "factor", "integer")) ~ quote(geom_jitter),
       ~ quote(geom_point)
  )
}

#' Set the aesthetics mapping
#'
#' Turns a mapping that contains named and unnamed aesthetics into a vector with
#' all aesthetics named according to the argument structure of `ggplot2::aes()`,
#' which is `aes(x, y, ...)`. This may be used down-stream. E.g. for violin
#' plots, the aesthetics x and y are not interchangeable and it is unsafe to
#' assume that x is always the first aesthetic. Hence, by creating a named
#' vector, we can always refer to the aesthetics by name.
#' @param aes The aesthetics to map.
#' @param names_data The names of all columns.
#' @examples
#' simplificar:::set_aes(c(y = "cyl", "vs"), names(mtcars))
#' @keywords internal
set_aes <- function(aes, names_data) {
  aes_named_args <- c("x", "y")
  check_aes(aes, names_data)
  names_aes <- names(aes)
  if (is.null(names_aes)) {
    both <- c(x = aes[1])
    if (length(aes) > 1L) {
      both <- append(both, c(y = aes[2]))
    }
    return(both)
  }
  has_name <- names_aes != ""
  named_args <- names(aes[has_name])
  leftover <- setdiff(aes_named_args, named_args)
  names_aes[!has_name] <- leftover
  names(aes) <- names_aes
  aes[c(aes_named_args[aes_named_args %in% names_aes], setdiff(names_aes, aes_named_args))]
}

#' Extracts dots and returns named elements
#'
#' Otherwise, there is a downstream problem if functions use `...` and there
#' are unnamed arguments, they are matched by position.
#' @param ... Values passed to `...`.
#' @keywords internal
drop_unnamed_dots <- function(...) {
  all <- list(...)
  all[names(all) != ""]
}

#' Drop the package mask
#'
#' @param pkg_string The name of a function, which may contain package prefix
#'   that is to be removed.
#' @examples
#' simplificar:::drop_pkg_mask("ggplot2::geom()")
#' @importFrom purrr map_chr
#' @keywords internal
drop_pkg_mask <- function(pkg_string) {
  strsplit(pkg_string, "\\:{2,3}", fixed = FALSE, perl = TRUE) %>%
    map_chr(~.x[length(.x)])
}

#' Setting the dot argument depending on the geom used.
#' @param ... Values to be passed to the geom.
#' @param geom The bare name of the geom to use.
#' @param fill The fill argument to the geom which may or may not be applicable.
#' @keywords internal
set_dots_distr <- function(..., geom, fill) {
  dots <- drop_unnamed_dots(...)
  deparsed <- deparse(geom)
  when(drop_pkg_mask(deparsed),
       . == "geom_density" ~ c(dots, fill = fill),
       . == "geom_density_2d" ~ dots,
       . == "geom_bar" ~ c(dots, fill = fill),
       . == "geom_histogram" ~ c(dots, fill = fill),
       ~ dots
  )
}


set_data_name <- function(data_name, name) {
  if (!is.null(name)) return(name)
  data_name
}

k_dimensional <- function(transformer_name) {
  stopifnot(length(transformer_name) == 1)
  k_d <- strsplit(transformer_name, "_", fixed = TRUE)[[1]][2]
  maybe_warning <- tryCatch(
    substr(k_d, 1, nchar(k_d) - 1) %>%
      as.numeric(), warning = function(w) w)
  if (inherits(maybe_warning, "warning")) abort(paste0(
    "argument k_dimensional may not be NULL if dimensions can't be derived ",
    "from transformer. See ?vis_cols, argument k_dimensional."
  ))
  maybe_warning
}

#' @importFrom rlang is_empty
set_vars <- function(quos, names_data, k_dimensional) {
  if (is_empty(quos)){
    vars <- tidyselect::vars_select(names_data, everything()) %>% unname()
  } else {
    vars <- vars_from_quo(quos, names_data, k_dimensional)
  }
}

set_called_for_side_effects <- function(called_for_side_effects, transformer_name) {
  if (is.null(called_for_side_effects)) {
    ifelse(grepl("file$", transformer_name), TRUE, FALSE)
  } else {
    called_for_side_effects
  }
}
