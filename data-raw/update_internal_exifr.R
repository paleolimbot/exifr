
library(tidyverse)
library(curl)

# update the packaged version of exiftool, so that a reasonably new version is available
# in the installed package

curl_download(
  "https://sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-11.22.tar.gz",
  "data-raw/exiftool-current.tar.gz"
) %>%
  untar(exdir = "data-raw")

ex_root <- list.files("data-raw", "^Image-ExifTool", full.names = TRUE)

pkg_root <- "data-raw/exiftool"
dir.create(pkg_root)

file.copy(file.path(ex_root, "lib"), pkg_root, recursive = TRUE)
file.copy(file.path(ex_root, "exiftool"), file.path(pkg_root, "exiftool.pl"))

# make compressed version
withr::with_dir("data-raw", {
  unlink("exiftool.zip")
  zip("exiftool.zip", list.files("exiftool", full.names = TRUE, recursive = TRUE))
})

# copy to installed files
unlink("inst/exiftool", recursive = TRUE)
file.copy(pkg_root, "inst", recursive = TRUE)

# copy compressed version to gh-pages branch
system("data-raw/update_internal_exifr.sh")

# cleanup
unlink(ex_root, recursive = TRUE)
unlink(pkg_root, recursive = TRUE)
unlink("data-raw/exiftool-current.tar.gz")
unlink("data-raw/exiftool.zip")
