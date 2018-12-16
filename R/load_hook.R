
# .onLoad hook for when namespace is loaded
.onLoad <- function(libname, pkgname) {
  configure_exiftool(quiet = TRUE, install_url = TRUE)
}

# .onAttach for library(exifr)
.onAttach <- function(libname, pkgname) {
  version <- try(exiftool_version(), silent = TRUE)
  if(!inherits(version, "try-error")) {
    packageStartupMessage("Using ExifTool version ", version)
  } else {
    # there are already a bunch of warnings as a result of the failed
    # configuration
  }
}
