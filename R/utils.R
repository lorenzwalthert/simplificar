set_null_to <- function(test, default) {
  if (is.null(test)) return(default)
  test
}


eval_txt <- function(txt, allow_bare = FALSE) {
  if (class(txt) %in% "character" | allow_bare == FALSE) {
    eval(parse(text = txt))
  } else {
    txt
  }

}

pkg_name <- function() {
  "simplificar"
}
