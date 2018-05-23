context("vis_cols")

test_that("correct number of combs are generated depending on transformer", {
  expect_equal(
    vis_cols(iris, "Sepal.Width", "Petal.Width", transformer = vis_2d_point) %>%
      nrow(),
    1
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
