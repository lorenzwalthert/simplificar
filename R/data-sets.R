#' A transfered dataset
#' @docType dataset
#' @include convert.R utils.R
mtcars_converted  <- mtcars %>%
  transform_cols(c("vs", "am"), transformer = "readr::parse_factor", levels = 1:0) %>%
  transform_cols(c("cyl"), transformer = "readr::parse_factor", levels = c(4, 6, 8))
