#' @importFrom purrr when
set_1d_geom_distr <- function(class) {
  when(class,
    any((.) %in% c("numeric", "integer")) ~ geom_density,
    ~  geom_bar
  )
}

set_geom_2d_distr <- function(class) {
  when(class,
       any((.) %in% c("numeric", "integer")) ~ geom_violin,
       ~geom_jitter
  )
}


set_2d_geom_point <- function(class) {
  when(class,
       any((.) %in% c("character", "factor", "integer")) ~ geom_jitter,
       ~ geom_point
  )
}

#' Extracts dots and returns named elements
#'
#' Otherwise, there is a downstream problem if functions use `...` and there
#' are unnamed arguments, they are matched by position.
#' @param ... Values passed to `...`.
set_dots <- function(...) {
  all <- list(...)
  all[names(all) != ""]
}

set_name <- function(name, sub) {
  set_null_to(name, deparse(sub))
}

set_data_name <- function(data_name, name) {
  if (!is.null(name)) return(name)
  data_name
}

k_dimensional <- function(tranformer_name) {
  stopifnot(length(tranformer_name) == 1)
  k_d <- strsplit(tranformer_name, "_", fixed = TRUE)[[1]][2]
  substr(k_d, 1, nchar(k_d) - 1) %>%
    as.integer()
}

#' @importFrom rlang is_empty
set_vars <- function(quos, data, k_dimensional) {
  if (is_empty(quos)){
    vars <- tidyselect::vars_select(names(data), everything()) %>% unname()
  } else {
    vars <- vars_from_quo(quos, data, k_dimensional)
  }
}

set_called_for_side_effects <- function(called_for_side_effects, transformer_name) {
  if (is.null(called_for_side_effects)) {
    ifelse(grepl("file$", transformer_name), TRUE, FALSE)
  } else {
    called_for_side_effects
  }
}
