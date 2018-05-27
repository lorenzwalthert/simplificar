context("test-vis-2d-distr")

test_that("to_console", {
  expect_doppelganger(
    "default dispatch continous / continous -> contour",
    vis_2d_distr(mtcars, aes = c("cyl", "vs")) %>%
      pull_gg()
  )

  expect_doppelganger(
    "default dispatch factor / continuous -> violin",
    mtcars %>%
      transform_cols("cyl", "as.factor") %>%
      vis_2d_distr(aes = c("cyl", "vs")) %>%
      pull_gg()
  )

  expect_doppelganger(
    "default dispatch continous / factor -> violin",
    mtcars %>%
      transform_cols("vs", "as.factor") %>%
      vis_2d_distr(aes = c("cyl", "vs")) %>%
      pull_gg()
  )
})
