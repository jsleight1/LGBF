.onLoad <- function(libname, pkgname) {
  resources <- system.file("www", package = "LGBF")
  addResourcePath("www", resources)
}
