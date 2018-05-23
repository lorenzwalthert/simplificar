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
pull_gg <- function(tbl, index = 1) {
  index <- ifelse(index < 0, nrow(tbl) + index + 1, index)
  tbl$gg[[index]]

}

gg_tbl_cols <- function() {
  quos(data = NA, aes_string = NA, class_string = NA, gg = NA, aes = NA, class = NA)
}
