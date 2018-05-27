context("test-set-aes")

test_that("multiplication works", {
  expect_equal(
    set_aes(c(x = "cyl", y = "mpg"), names(mtcars)),
    c(x = "cyl", y = "mpg")
  )
  expect_equal(
    set_aes(c(x = "cyl"), names(mtcars)),
    c(x = "cyl")
  )

  expect_equal(
    set_aes(c(y = "cyl"), names(mtcars)),
    c(y = "cyl")
  )

  expect_equal(
    set_aes(c("cyl", x = "vs"), names(mtcars)),
    c(x = "vs", y = "cyl")
  )

  expect_equal(
    set_aes(c("cyl", "vs"), names(mtcars)),
    c(x = "cyl", y = "vs")
  )

  expect_equal(
    set_aes(c(col = "hp", "cyl", "vs"), names(mtcars)),
    c(x = "cyl", y = "vs", col = "hp")
  )

  expect_equal(
    set_aes(c(col = "hp", "cyl", x = "vs"), names(mtcars)),
    c(x = "vs", y = "cyl", col = "hp")
  )
})

