context("vis-2d-point")

library(vdiffr)

test_that("to console", {
  # expect_doppelganger(
  #   "default dispatch point: int / int -> jitter",
  #   vis_2d_point(dummy_types, aes = c("int1", "int2")) %>%
  #     pull_gg()
  # )

  expect_doppelganger(
    "default dispatch point: int / num -> point",
    vis_2d_point(dummy_types, aes = c("int2", "num1")) %>%
      pull_gg()
  )

  expect_doppelganger(
    "default dispatch point: int / chr -> point",
    vis_2d_point(dummy_types, aes = c("int2", "num1")) %>%
      pull_gg()
  )

  # expect_doppelganger(
  #   "default dispatch point: int / int -> jitter",
  #   vis_2d_point(dummy_types, aes = c("int2", "int2")) %>%
  #     pull_gg()
  # )

  # expect_doppelganger(
  #   "override dispatch jitter",
  #   vis_2d_point(mtcars_converted, aes = c("cyl", "vs"), geom = ggplot2::geom_area) %>%
  #     pull_gg()
  # )

  expect_doppelganger(
    "custom names",
    vis_2d_point(mtcars_converted,
      aes = c("cyl", "vs"),
      geom = ggplot2::geom_point, names = c("x", "Y")
    ) %>%
      pull_gg()
  )
})

test_that("to file", {
  withr::with_dir(
    tempdir(), {
      ts <- time_stamp() %>%
        add_ext("png")
      out <- vis_2d_point_to_file(iris,
        c(x = "Sepal.Width", y = "Sepal.Length", size = "Petal.Width"),
        file = ts, dimensions = width_heigh_from_aspect_ratio(1, scale = 5)
      )
      expect_true(file.exists(out))
      unlink(c(ts, out))
    }
  )
})
