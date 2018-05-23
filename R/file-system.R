add_ext <- function(x, ...) {
  paste0(x, ".", ..., collapse = "")
}

ensure_dir <- function(name = pkg_name()) {
  if (!dir.exists(name)) {
    dir.create(name)
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
time_stamp <- function(name) {
  paste0(paste0(name, collapse = "-"), "--", format(Sys.Date(), "%Y-%m-%d"))
}
