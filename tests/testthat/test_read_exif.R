
context("read_exif functions")

images_folder <- system.file("images", package = "exifr")
test_files <- list.files(images_folder, recursive=TRUE, full.names=TRUE)

test_that("read_exif reads images in the inst directory", {
  df <- read_exif(test_files, quiet = FALSE)
  expect_equal(nrow(df), 2)
  expect_equal(ncol(df), 268)
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
  expect_message(read_exif(test_files, quiet = FALSE),
                 "Generating command line arguments")
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
  expect_equal(colnames(df1), colnames(df2))
  # identical_cols <- purrr::map2_lgl(df1, df2, identical)
  df1$FileAccessDate <- NULL
  df2$FileAccessDate <- NULL
  expect_identical(df1[order(df1$SourceFile),], df2[order(df2$SourceFile),])
})

test_that("tags option works", {
  df <- read_exif(test_files, tags = c("FileName", "ImageSize"))
  expect_equal(colnames(df), c("SourceFile", "FileName", "ImageSize"))
  df2 <- read_exif(test_files, tags = c("NotATag"))
  expect_equal(colnames(df2), "SourceFile")
  expect_error(read_exif(test_files, tags = "has space"), "tags cannot contain whitespace")
})

test_that("command-line length is properly dealt with", {
  files <- rep(test_files, 1000)
  df <- read_exif(files, quiet = FALSE)
  expect_true(setequal(df$SourceFile, test_files))
  df$FileAccessDate <- NULL
  expect_equal(nrow(unique(df)), 2)
})
