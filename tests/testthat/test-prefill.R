context("test-prefill")

test_that("can prefill aesthetics", {

  plot <- mtcars %>%
    vis_cols(everything(),
             transformer = prefill_aes(vis_2d_point, color = "vs"), k_dimensional = 2
    ) %>%
    pull_gg(-1)
  expect_doppelganger("point prefilled with color in place", plot)

  vis_2d_point_with_color <- prefill_aes(vis_2d_point, color = "vs")
  plot <- mtcars %>%
    vis_cols(everything(),
             transformer = vis_2d_point_with_color
    ) %>%
    pull_gg(-1)
  expect_doppelganger("point prefilled with color with assignment", plot)
})
