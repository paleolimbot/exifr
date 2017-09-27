
#' Configure perl, ExifTool
#'
#' @param command The exiftool command or location of exiftool.pl
#' @param perl_path The path to the perl executable
#' @param install_url The url from which exiftool could be installed
#' @param install_location The location to install exiftool
#' @param quiet Use quiet = FALSE to display status updates
#'
#' @return The exiftool command, invisibly
#' @export
#'
configure_exiftool <- function(command = NULL, perl_path = NULL,
                               install_url = NULL,
                               install_location = NULL,
                               quiet = FALSE) {
  # configure perl
  if(is.null(perl_path)) {
    perl_path <- configure_perl(quiet = quiet)
  }

  if(is.null(command)) {
    # use default list of possible locations
    command <- c(getOption("exifr.exiftoolcommand"),
                 "exiftool",
                 paste(shQuote(perl_path),
                       shQuote(system.file("exiftool/exiftool.pl", package = "exifr"))))
  } else if(length(command) == 0) {
    command <- character(0)
  } else {
    # try both the command and perl 'command'
    command <- c(command,
                 paste(shQuote(perl_path),
                       shQuote(command)))
  }

  for(com in command) {
    if(test_command(paste(com, "-ver"), quiet = quiet)) {
      if(!quiet) message("ExifTool found at ", com)
      options(exifr.exiftoolcommand = com)
      return(invisible(com))
    }
  }

  if(is.null(install_url)) {
    # don't install!
    stop("Could not find ExifTool at any of the following commands: ",
         paste(command, collapse = ", "))
  }

  if(identical(install_url, TRUE)) {
    install_url <- "http://paleolimbot.github.io/exifr/exiftool.zip"
  }

  message("Could not find ExifTool at any of the following commands: ",
          paste(command, collapse = ", "),
          ". Attempting to install from ",
          install_url)

  if(is.null(install_location)) {
    # define default install locations
    install_location <- c(
      file.path(system.file("", package = "exifr")),
      path.expand("~/exiftool")
    )
  }

  # find writable locations
  write_dir <- find_writable(install_location)

  # attempt to download the file
  download_file <- tempfile()[1]
  on.exit(unlink(download_file))
  curl::curl_download(install_url, download_file, quiet = quiet)

  # extract downloaded file
  if(!quiet) message("Extracting exiftool to ", write_dir)
  utils::unzip(download_file, exdir = write_dir)

  # configure exiftool
  invisible(configure_exiftool(file.path(write_dir, "exiftool", "exiftool.pl"),
                               perl_path = perl_path, install_url = NULL))
}

#' @rdname configure_exiftool
#' @export
configure_perl <- function(perl_path = NULL, quiet = FALSE) {
  if(is.null(perl_path)) {
    # use default list of possible locations
    perl_path <- c(getOption("exifr.perlpath"),
              "perl",
              "C:\\Perl64\\bin\\perl",
              "C:\\Perl\\bin\\perl",
              "C:\\Strawberry\\perl\\bin\\perl")
  }

  for(p in perl_path) {
    if(test_command(paste(shQuote(p), "--version"), quiet = quiet)) {
      if(!quiet) message("perl found at ", p)
      options(exifr.perlpath = p)
      return(invisible(p))
    }
  }

  stop("Could not find perl at any of the following locations: ",
       paste(perl_path, collapse = ", "),
       ". Specify perl location using options(exifr.perlpath='my/path/to/perl')")
}

test_command <- function(command, quiet = TRUE) {
  if(!quiet) message("Trying command: ", command)
  suppressWarnings(suppressMessages(0==try(system(command, ignore.stdout = TRUE,
    ignore.stderr = TRUE, show.output.on.console = FALSE), silent=TRUE)))
}

find_writable <- function(install_location) {
  for(il in install_location) {
    testfile <- file.path(il, ".dummyfile")
    file.create(testfile, showWarnings = FALSE)
    if(file.exists(testfile)) {
      unlink(testfile)
      return(il)
    }
  }

  stop("Could not find a writable directory in which to install ExifTool. Tried ",
       paste(install_location, collapse = ", "))
}
