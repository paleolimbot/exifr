
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
#' Sigma/Foveon and Sony. For more information, see the
#' \href{http://www.sno.phy.queensu.ca/~phil/exiftool/}{ExifTool website}.
#'
#' Note that binary tags such as thumbnails are loaded as base64-encoded
#' strings that start with "base64:".
#'
#' @param path A vector of filenames
#' @param tags A vector of tags to output. It is a good idea to specify this
#'   when reading large numbers of files, as it decreases the output overhead
#'   significantly. Spaces will be stripped in the output data frame. This
#'   parameter is not case-sensitive.
#' @param recursive TRUE to pass the "-r" option to ExifTool
#' @param args Additional arguments
#' @param quiet Use FALSE to display diagnostic information
#'
#' @return A data frame (tibble) with columns SourceFile and one per tag read in
#'   each file. The number of rows may differ, particularly if recursive is set
#'   to TRUE, but in general will be one per file.
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
    if(length(missing_dirs) > 0) {
      stop("Did you mean recursive = TRUE? ",
           "The following directories are missing (or are not directories). ",
            paste(missing_files, collapse = ", "))
      }
  } else {
    missing_files <- path[!file.exists(path) | dir.exists(path)]
    if(length(missing_files) > 0) {
      stop("Did you mean recursive = TRUE? ",
           "The following files are missing (or are not files): ",
           paste(missing_files, collapse = ", "))
      }
  }

  if(length(path) == 0) {
    return(tibble::tibble(SourceFile = character(0)))
  }

  if(recursive) {
    args <- c(args, "-r")
  }

  if(!is.null(tags)) {
    # tags cannot have spaces...whitespace is stripped by ExifTool
    tags <- gsub("\\s", "", tags)
    args <- c(paste0("-", tags), args)
  }

  # required args are -n for numeric output,
  # -j for JSON output, -q for quiet, and -b to make sure
  # output is base64 encoded
  args <- unique(c("-n", "-j", "-q", "-b", args))
  # an extra -q further silences warnings
  if(quiet) {
    args <- c(args, "-q")
  }

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
  images_per_command <- length(path)
  commands <- exiftool_command(args = args, fnames = path)
  ngroups <- 1
  groups <- rep(1, length(path))

  while(any(nchar(commands) >= (command_length * 0.75)) && (images_per_command >= 2)) {
    # make the images per command half of previous value
    images_per_command <- images_per_command %/% 2

    # calculate number of groups
    ngroups <- (length(path) + images_per_command - 1) %/% images_per_command
    groups <- rep(seq_len(ngroups), rep(images_per_command, ngroups))[seq_along(path)]

    # subdivide path into groups and generate the commands
    commands <- vapply(
      split(path, groups),
      function(fnames) exiftool_command(args = args, fnames = fnames),
      character(1)
    )
  }

  # ---- run the commands, read output ----

  if(!quiet) message("Running ", length(commands), " commands")
  results <- lapply(split(path, groups), function(fnames) read_exif_base(args, fnames, quiet = quiet))
  tibble::as_tibble(do.call(plyr::rbind.fill, results))
}

# base function to read a single command to a df
read_exif_base <- function(args, fnames, quiet = TRUE) {
  # run command
  return_value <- exiftool_call(args, fnames, intern = TRUE, quiet = quiet)

  # read, return the output
  tibble::as_tibble(jsonlite::fromJSON(return_value))
}
