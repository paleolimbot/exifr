
context("exiftool utils")


test_that("perl configure works properly", {
  expect_is(configure_perl(), "character")
  expect_message(configure_perl(quiet = FALSE), "Perl found at")
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
  expect_is(
    configure_exiftool(
      command = character(0),
      install_url = TRUE,
      install_location = install_loc,
      quiet = TRUE
    ),
    "character"
  )
  expect_true(exiftool_version() >= 11.22)
  unlink(install_loc, recursive = TRUE)
  options(exifr.exiftoolcommand = old_exiftool)
})

test_that("Internal version of exiftool works", {
  # if internal exiftool isn't packaged, this will be ""
  internal_exiftool <- system.file("exiftool/exiftool.pl", package = "exifr")
  if(internal_exiftool != "") {
    old_exiftool <- getOption("exifr.exiftoolcommand")
    expect_message(configure_exiftool(command = internal_exiftool), "ExifTool found at")
    options(exifr.exiftoolcommand = old_exiftool)
  }
})

test_that("empty strings do not pass configure_perl()", {
  old_perl <- getOption("exifr.perlpath")
  expect_warning(configure_perl(perl_path = ""), "Could not find perl at any of the following locations")
  options(exifr.perlpath = old_perl)
})

test_that("empty strings do not pass configure_exiftool()", {
  old_exiftool <- getOption("exifr.exiftoolcommand")
  expect_warning(configure_exiftool(command = ""), "Could not find ExifTool at any of the following locations")
  options(exifr.exiftoolcommand = old_exiftool)
})

test_that("command tester works", {
  # "perl" is installed at "perl" on CRAN and travis
  perl_command <- configure_perl(quiet = TRUE)
  expect_true(test_command(perl_command, "-V"))
  expect_true(test_command(perl_command, "-V", return_code = 0))
  expect_false(test_command(perl_command, "-V", regex_stderr = ".+"))
  expect_false(test_command(perl_command, "-V", regex_stdout = "this is definitely not in the version text"))
  expect_true(test_command(perl_command, "-V", regex_stdout = "configuration", return_code = 0))
  expect_true(test_command(perl_command, "--not-an-arg"))
  expect_false(test_command(perl_command, "--not-an-arg", return_code = 0))
})
