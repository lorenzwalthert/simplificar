#' @importFrom rlang abort
check_aes <- function(aes, data_names) {
  not_in_names <- !(aes %in% data_names)
  if (any(not_in_names)) {
    abort(paste(
      "The following aesthetics are not present in data: ",
      paste(data_names[not_in_names], collapse = ", ")
    ))
  }
}
