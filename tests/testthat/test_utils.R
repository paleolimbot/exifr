
context("exiftool utils")


test_that("perl configure works properly", {
  expect_is(configure_perl(), "character")
  expect_message(configure_perl(quiet = FALSE), "perl found at")
  expect_silent(configure_perl(quiet = TRUE))
})

test_that("exiftool configure works properly", {
  expect_is(configure_exiftool(), "character")
  expect_message(configure_exiftool(quiet = FALSE), "ExifTool found at")
  expect_silent(configure_exiftool(quiet = TRUE))
})

test_that("exiftool install works properly", {
  old_exiftool <- getOption("exifr.exiftoolcommand")
  install_loc <- tempfile()[1]
  dir.create(install_loc)
  expect_is(configure_exiftool(command = character(0), install_url = TRUE,
                               install_location = install_loc),
            "character")
  expect_equal(exiftool_version(), 10.61)
  unlink(install_loc, recursive = TRUE)
  options(exifr.exiftoolcommand = old_exiftool)
})
