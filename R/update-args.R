#' Override aes using the geom and class for user convenience
#'
#' Certain geoms don't play nice with certain aesthetics, so the aesthetics are
#' modified to be more meaningful with that geom. See 'Examples'.
#' @param class The named vector with classes of the aesthetics.
#' @param aes The currentaesthetics itself.
#' @param geom The current geom.
#' @examples
#' library("ggplot2")
#' p <- ggplot(mtcars)
#' # nice
#' p + geom_violin(aes(factor(cyl), mpg))
#' # nonsense
#' p + geom_violin(aes(mpg, factor(cyl)))
#' mtcars %>%
#'   transform_cols("cyl", "as.factor") %>%
#'   vis_2d_distr(c("cyl", "mpg")) %>%
#'   pull_gg()
#' mtcars %>%
#'   transform_cols("cyl", "as.factor") %>%
#'   vis_2d_distr(c("mpg", "cyl")) %>%
#'   pull_gg()
update_aes <- function(class, aes, geom) {
  when(class,
    (.["x"] %in% c("numeric", "integer")) &
      (.["y"] %in% c("factor", "character")) &
      (deparse(geom) %in% "geom_violin") ~ c(
        x = unname(aes["y"]),
        y = unname(aes["x"])
      ),
    ~ aes
  )
}
