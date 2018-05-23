context("vis_cols")
library("vdiffr")

test_that("correct number of combs are generated depending on transformer", {
  expect_doppelganger(
    "vis-2d-point default",
    vis_cols(iris, "Sepal.Width", "Petal.Width", transformer = vis_2d_point) %>%
      pull_gg()
  )

  expect_equal(
    vis_cols(iris, "Sepal.Width", contains("Petal"), transformer = vis_2d_point) %>%
      nrow(),
    3
  )
  expect_equal(
    vis_cols(iris, "Sepal.Width", contains("Petal"), transformer = vis_1d_distr) %>%
      nrow(),
    3
  )
  expect_equal(
    vis_cols(iris, Sepal.Width, transformer = vis_1d_distr) %>%
      nrow(),
    1
  )
})
