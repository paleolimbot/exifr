
# .onLoad hook for when namespace is loaded
.onLoad <- function(libname, pkgname) {
  configure_exiftool(quiet = TRUE, install_url = TRUE)
  message("Using ExifTool version ", exiftool_version())
}
