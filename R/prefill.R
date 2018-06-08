#' Prefill some aes arguments of a transformer
#'
#' @param transformer A transformer function like [vis_2d_point()] that should
#'   gain prefilled aesthetics.
#' @param ... Named aesthetics, e.g. `color = "variable_x"`.
#' @examples
#' # If you prefill in-place, you need to supply `k_dimensional`, since it
#' # cannot be inferred from the transformer name itself.
#' mtcars %>%
#'   vis_cols(everything(),
#'     transformer = prefill_aes(vis_2d_point, color = "vs"), k_dimensional = 2
#'   ) %>%
#'   pull_gg(-1)
#' # Alternatively, you explificlty assign the object and give it a name
#' # that can be recognized by `vis_cols`.
#' vis_2d_point_with_color <- prefill_aes(vis_2d_point, color = "vs")
#' mtcars %>%
#'   vis_cols(everything(),
#'     transformer = vis_2d_point_with_color, k_dimensional = 2
#' ) %>%
#' pull_gg(-1)
prefill_aes <- function(transformer, ...) {
  named_aes <- c(...)
  function(data, aes, names = aes, geom = NULL, ...) {
    transformer(data, c(aes, c(named_aes)), names, geom, ...)
  }
}
