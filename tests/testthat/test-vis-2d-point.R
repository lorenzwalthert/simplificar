context("vis-2d-point")

library(vdiffr)

test_that("to console", {
  expect_doppelganger(
    "default dispatch point",
    vis_2d_point(mtcars, aes = c("cyl", "vs")) %>%
      pull_gg()
  )

  # expect_doppelganger(
  #   "default dispatch jitter",
  #   vis_2d_point(mtcars_converted, aes = c("cyl", "vs")) %>%
  #     pull_gg()
  # )

  expect_doppelganger(
    "override dispatch jitter",
    vis_2d_point(mtcars_converted, aes = c("cyl", "vs"), geom = ggplot2::geom_area) %>%
      pull_gg()
  )

  expect_doppelganger(
    "custom names",
    vis_2d_point(mtcars_converted, aes = c("cyl", "vs"),
                 geom = ggplot2::geom_point, names = c("x", "Y")) %>%
      pull_gg()
  )
})
