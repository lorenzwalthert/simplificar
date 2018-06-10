context("test-data-structures")

test_that("blow / pull / flatten", {
  gg_table <- vis_cols(mtcars, 2)

  gg_raw <- gg_table %>%
    flatten_gg()
  expect_equal(gg_raw, gg_table$gg[[1]])
  # the reverse operation (only column gg can be restored)
  gg_blown <- gg_raw %>%
    blow_gg()
  expect_equal(gg_blown$gg[[1]], gg_raw)
  expect_error(
    dplyr::bind_rows(gg_table, gg_table) %>%
      flatten_gg()
  )
  expect_equal(gg_table %>% pull_gg(1), gg_table %>% pull_gg(-1))
})
