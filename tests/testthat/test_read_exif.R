
context("read_exif functions")

images_folder <- system.file("images", package = "exifr")
test_files <- list.files(images_folder, recursive=TRUE, full.names=TRUE)

test_that("read_exif reads images in the inst directory", {
  df <- read_exif(test_files, quiet = FALSE)
  expect_equal(nrow(df), 2)
  expect_true(ncol(df) > 250)
  expect_true("SourceFile" %in% colnames(df))
  expect_true(setequal(test_files, df$SourceFile))
})

test_that("read_exif reads a single file as a data frame", {
  df <- read_exif(test_files[1], quiet = FALSE)
  expect_is(df, "data.frame")
  expect_equal(nrow(df), 1)
  expect_true("SourceFile" %in% colnames(df))
  expect_true(setequal(test_files[1], df$SourceFile))
})

test_that("quiet argument supresses messages", {
  expect_silent(read_exif(test_files))
  expect_message(
    read_exif(test_files, quiet = FALSE),
    "Generating command line arguments"
  )
})

test_that("recursive option works", {
  # check type errors
  expect_error(read_exif(images_folder), "The following files are missing")
  expect_silent(read_exif(images_folder, recursive = TRUE))
  expect_error(read_exif(system.file("", package = "exifr")), "The following files are missing")
  expect_silent(read_exif(system.file("", package = "exifr"), recursive = TRUE))
  # check results are identical
  df1 <- read_exif(images_folder, recursive = TRUE)
  df2 <- read_exif(list.files(images_folder, full.names = TRUE))
  expect_true(setequal(colnames(df1), colnames(df2)))
  # identical_cols <- mapply(df1, df2, identical)
  df1$FileAccessDate <- NULL
  df2$FileAccessDate <- NULL
  cols <- unique(c(colnames(df1), colnames(df2)))
  expect_identical(
    df1[order(df1$SourceFile), cols],
    df2[order(df2$SourceFile), cols]
  )
})

test_that("tags option works", {
  df <- read_exif(test_files, tags = c("FileName", "ImageSize"))
  expect_equal(colnames(df), c("SourceFile", "FileName", "ImageSize"))
  df2 <- read_exif(test_files, tags = c("NotATag"), quiet = TRUE)
  expect_equal(colnames(df2), "SourceFile")
  expect_identical(
    read_exif(test_files, tags = "file name"),
    read_exif(test_files, tags = "filename")
  )
})

test_that("command-line length is properly dealt with", {
  files <- rep(test_files, 500)
  df <- read_exif(files, tags = c("FileName", "ImageSize"), args = "-fast", quiet = FALSE)
  expect_true(setequal(df$SourceFile, test_files))
  expect_equal(nrow(unique(df)), 2)
})

# # perl isn't necessarily on the path
# test_that("included exiftool with perl works as well as command-line", {
#   internal_exiftool <- paste("perl", system.file("exiftool/exiftool.pl", package = "exifr"))
#   old_opts <- options(exifr.exiftoolcommand = internal_exiftool)
#   expect_is(read_exif(test_files), "data.frame")
#   options(old_opts)
# })

test_that("binary tags are loaded as base64", {
  btag_file <- system.file("images/binary_tag.JPG", package = "exifr")
  # read in only binary columns
  df <- read_exif(btag_file,
                  tags = c("DataDump", "RecognizedFace1Name",
                           "RecognizedFace1Age", "RecognizedFace2Name",
                           "RecognizedFace2Age", "RecognizedFace3Name",
                           "RecognizedFace3Age",
                           "Title", "BabyName", "Location", "ThumbnailImage"))

  df$SourceFile <- NULL
  expect_true(all(grepl("^base64:", unlist(df))))
})

test_that("exiftool version function works", {
  expect_is(exiftool_version(), "numeric")
})

test_that("exiftool call function works", {
  # check that call function output works
  expect_match(exiftool_call(args = c("-j", "-exiftoolversion"),
                             system.file("images/Canon.jpg", package = "exifr"),
                             intern = TRUE),
               '"ExifToolVersion": [0-9.]+')
  # test that quiet argument suppresses command output
  expect_message(exiftool_call(args = c("-j", "-exiftoolversion"),
                               system.file("images/Canon.jpg", package = "exifr"),
                               intern = TRUE),
                 "-j -exiftoolversion")
  expect_silent(exiftool_call(args = c("-j", "-exiftoolversion"),
                              system.file("images/Canon.jpg", package = "exifr"),
                              intern = TRUE, quiet = TRUE))
})
