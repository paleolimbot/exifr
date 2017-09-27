
# .onLoad hook for when namespace is loaded
.onLoad <- function(libname, pkgname) {
  configure_exiftool(quiet = TRUE, install_url = TRUE)
}

# .onAttach for library(exifr)
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Using ExifTool version ", exiftool_version())
}
