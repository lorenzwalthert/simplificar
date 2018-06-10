context("vis_cols")

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


test_that("interaction transformer and k_dimensionial", {
  expect_error(
    vis_cols(iris, "Sepal.Width", contains("Petal"), transformer = vis_distr),
    "?vis_cols, argument k_dimensional"
  )
  expect_error(
    vis_cols(
      iris, "Sepal.Width", contains("Petal"), transformer = vis_distr,
      k_dimensional = 2
    ), NA
  )
})

test_that("to file", {
  withr::with_dir(
    tempdir(), {
      out <- vis_cols(iris,
        "Sepal.Width", "Sepal.Length", "Petal.Width",
        transformer = vis_2d_point_to_file
      )
      expect_true(all(file.exists(add_ext(out, "pdf"))))
      unlink(out)
    }
  )
})
