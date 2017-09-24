
#' Read EXIF data from files
#'
#' Reads EXIF data into a \code{data.frame} by calling the ExifTool command-line
#' application, written by Phil Harvey. Depending on number of images and
#' command-line length requirements, the command may be called multiple times.
#'
#' From the \href{http://www.sno.phy.queensu.ca/~phil/exiftool/}{ExifTool
#' website}: ExifTool is a platform-independent Perl library plus a command-line
#' application for reading, writing and editing meta information in a wide
#' variety of files. ExifTool supports many different metadata formats including
#' EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop IRB, FlashPix,
#' AFCP and ID3, as well as the maker notes of many digital cameras by Canon,
#' Casio, FLIR, FujiFilm, GE, HP, JVC/Victor, Kodak, Leaf,
#' Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson,
#' Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung, Sanyo,
#' Sigma/Foveon and Sony.
#'
#' For more information, see the \href{http://www.sno.phy.queensu.ca/~phil/exiftool/}{ExifTool
#' website}.
#'
#' @param path A vector of filenames
#' @param tags A vector of tags to output. It is a good idea to specify this when reading large numbers
#'   of files, as it decreases the output overhead significantly.
#' @param recursive TRUE to pass the "-r" option to ExifTool
#' @param args Additional arguments
#' @param quiet Use FALSE to display diagnostic information
#'
#' @return A data frame (tibble) with columns SourceFile and one per tag read in each file.
#'   The number of rows may differ, particularly if recursive is set to TRUE, but in general
#'   will be one per file.
#' @export
#'
#' @examples
#' files <- list.files(path.package("exifr"), recursive=TRUE, pattern="*.jpg", full.names=TRUE)
#' exifinfo <- read_exif(files)
#' # is equivalent to
#' exifinfo <- read_exif(path.package("exifr"), recursive=TRUE)
#'
#' read_exif(files, tags=c("filename", "imagesize"))
#'
read_exif <- function(path, tags = NULL, recursive = FALSE, args = NULL, quiet = TRUE) {

  # ---- general input processing ----
  # expand path
  path <- path.expand(path)

  # check that all files exist (files that do not exist cause problems later,
  # as do directories without recursive = TRUE)
  if(recursive) {
    missing_dirs <- path[!dir.exists(path)]
    if(length(missing_dirs) > 0) stop("Did you mean recursive = TRUE? ",
                                      "The following directories are missing (or are not directories). ",
                                       paste(missing_files, collapse = ", "))
  } else {
    missing_files <- path[!file.exists(path) | dir.exists(path)]
    if(length(missing_files) > 0) stop("Did you mean recursive = TRUE? ",
                                       "The following files are missing (or are not files): ",
                                       paste(missing_files, collapse = ", "))
  }

  if(length(path) == 0) {
    return(tibble::tibble(SourceFile = character(0)))
  }

  if(recursive) {
    args <- c(args, "-r")
  }

  if(!is.null(tags)) {
    # tags cannot have spaces, or they are interpreted as filenames
    if(any(grepl("\\s", tags))) stop("tags cannot contain whitespace")
    args <- c(paste0("-", tags), args)
  }

  args <- c("-n", "-j", "-q", args)

  # ---- generate system commands ----

  if(!quiet) message("Generating command line arguments...")

  if(.Platform$OS.type == "windows") {
    command_length <- 8191 # according to https://support.microsoft.com/en-us/kb/830473
  } else {
    # according to the interweb this should be around 100kb, but 50kb should do
    # (is 'getconf ARG_MAX' on mac, equals 262144)
    command_length <- 50 * 1024
  }

  # initialize variables
  path_list <- list(path)
  images_per_command <- length(path)
  commands <- exiftool_command(args = args, fnames = path)

  while(any(nchar(commands) >= (command_length * 0.75)) && (images_per_command >= 2)) {
    # make the images per command half of previous value
    images_per_command <- images_per_command %/% 2

    # calculate number of groups
    ngroups <- (length(path) + images_per_command - 1) %/% images_per_command
    groups <- rep(seq_len(ngroups), rep(images_per_command, ngroups))[seq_along(path)]

    # subdivide path into groups and generate the commands
    commands <- purrr::map_chr(split(path, groups),
                               ~exiftool_command(args = args, fnames = .x))
  }

  # ---- run the commands, read output ----

  if(!quiet) message("Running ", length(commands), " commands")
  purrr::map_df(commands, read_exif_base, quiet = quiet)
}

# base function to read a single command to a df
read_exif_base <- function(command, quiet = TRUE) {
  # run command
  if(!quiet) message(command)
  return_value <- system(command, intern = TRUE)

  # read, return the output
  tibble::as_tibble(jsonlite::fromJSON(return_value))
}


#' Call exiftool from R
#'
#' Uses \code{system()} to run a basic call to \code{exiftool}.

#' @param args a list of non-shell quoted arguments (e.g. \code{-n -csv})
#' @param fnames a list of filenames (\code{shQuote()} will be applied to this vector)
#' @param intern \code{TRUE} if output should be returned as a character vector.
#' @param ... additional arguments to be passed to \code{system()}
#'
#' @return The exit code if \code{intern=FALSE}, or the standard output as a character vector
#'  if \code{intern=TRUE}.
#' @export
#'
#' @examples
#' exiftool_call("--help")
#'
exiftool_call <- function(args=c("--help"), fnames = NULL, intern = FALSE, ...) {
  system(exiftool.command(args, fnames), intern=intern, ...)
}

# private helper command to generate call to exiftool
exiftool_command <- function(args, fnames) {
  exiftoolpath <- getOption("exifr.exiftoolcommand")
  if(is.null(exiftoolpath)) stop("ExifTool not properly installed")
  if(length(fnames) > 0) {
    paste(exiftoolpath, paste(args, collapse=" "), paste(shQuote(fnames), collapse=" "))
  } else {
    paste(exiftoolpath, paste(args, collapse=" "))
  }
}
