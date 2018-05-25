#' @importFrom purrr flatten_chr
add_ext <- function(x, ..., check_ext = c("pdf", "png", "jpg", "jpeg")) {
  dots <- list(...)
  map(dots, add_ext_one, x = x, check_ext = check_ext) %>%
    flatten_chr()
}

#' @importFrom purrr compact
add_ext_one <- function(x, ..., check_ext) {
  dots <- list(...)
  if (length(compact(dots)) < 1L) return(x)
  has_ext <- has_ext(x, check_ext)
  x[!has_ext] <- paste0(x[!has_ext], ".", dots)
  x
}

#' @importFrom purrr map_chr map_lgl
has_ext <- function(x, extension) {
  strsplit(x, ".", fixed = TRUE) %>%
    map_chr(~.x[length(.x)]) %>%
    map_lgl(~.x %in% extension)
}

ensure_dir <- function(name = pkg_name()) {
  if (!dir.exists(name)) {
    dir.create(name, recursive = TRUE)
    cli::cat_bullet("Creating ", name, " directory under root.",
                    bullet = "tick", col = "green"
    )
  }
}



#' A file.path that drops NULL
#'
#' @param ... Passed to [base::file.path()]
#' @importFrom purrr compact invoke
#' @export
#' @examples
#' file_path(NULL, "hi")
file_path <- function(...) {
  compact(list(...)) %>%
    unlist() %>%
    invoke(file.path, .)
}

#' Create a time stamp with a name
#'
#' Simple time stam generation.
#' @param name An identifier.
#' @examples
#' time_stamp("mtcars")
#' @export
time_stamp <- function(name = "x") {
  prefix <- paste0(name, collapse = "-")
  paste0(prefix, "--", format(Sys.Date(), "%Y-%m-%d"))
}
