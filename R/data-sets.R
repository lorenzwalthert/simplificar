#' @include convert.R utils.R
mtcars_converted  <- mtcars %>%
  transform_cols(c("vs", "am"), transformer = "readr::parse_factor", levels = 1:0) %>%
  transform_cols(c("cyl"), transformer = "readr::parse_factor", levels = c(4, 6, 8))

#' A dummy dataset
#'
#' An excerpt of the mtcars dataset, renamed columns so for each type
#' (numeric, integer, character, factor), we have two columns.
dummy_types <- tibble::tibble(
  int1 = as.integer(mtcars$hp),
  int2 = as.integer(mtcars$cyl),
  num1 = as.numeric(mtcars$mpg),
  num2 = as.numeric(mtcars$disp),
  fct1 = as.factor(mtcars$vs),
  fct2 = as.factor(mtcars$carb),
  chr1 = as.character(mtcars$am),
  chr2 = as.character(mtcars$gear)
)
