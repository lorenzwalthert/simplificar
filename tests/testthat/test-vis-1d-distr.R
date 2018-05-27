context("vis-1d-distr")

library(vdiffr)

test_that("to console", {
  expect_doppelganger(
    "default dispatch continous",
    vis_1d_distr(mtcars, aes = "cyl") %>%
      pull_gg()
  )

  expect_doppelganger(
    "default dispatch discrete",
    vis_1d_distr(mtcars_converted, aes = "cyl") %>%
      pull_gg()
  )

  expect_doppelganger(
    "override geom",
    vis_1d_distr(mtcars, aes = "cyl", geom = ggplot2::geom_histogram) %>%
      pull_gg()
  )

  # DOES NOT (YET) WORK
  # expect_doppelganger(
  #   "override geom nse", {
  #     ggg <- ggplot2::geom_histogram
  #     vis_1d_distr(mtcars, aes = "cyl", geom = ggg) %>%
  #       pull_gg()
  # })

  expect_doppelganger(
    "custom fill",
    vis_1d_distr(mtcars, aes = "cyl", fill = "blue") %>%
      pull_gg()
  )

  expect_doppelganger(
    "custom other element passed with ...",
    vis_1d_distr(mtcars, aes = "cyl", bw = 11) %>%
      pull_gg()
  )

  expect_doppelganger(
    "custom name ...",
    vis_1d_distr(mtcars, aes = "cyl", name = "x.cyl") %>%
      pull_gg()
  )
})

test_that("to file", {
  withr::with_dir(
    tempdir(), {
      ts <- time_stamp() %>%
        add_ext("png")
      return <-  vis_1d_distr_to_file(mtcars, aes = "cyl", file = ts)
      expect_true(file.exists(ts))
      unlink(c(ts, return))
    })
})
