
#.onLoad hook for when namespace is loaded
.onLoad <- function(libname, pkgname) {
  #find command, will throw error if perl is not installed
  command <- findExifToolCommand(quiet=FALSE)
  if(is.null(command)) {
    #try downloading/installing exiftool
    installExifTool(quiet=FALSE)
    command <- findExifToolCommand(quiet=FALSE)
  }

  if(is.null(command)) {
    stop("Could not find ExifTool: installation may have failed")
  } else {
    options(exifr.exiftoolcommand=command)
  }
}

.onUnload <- function(libpath) {
  #remove "exifr.exiftoolcommand" option
  options(exifr.exiftoolcommand=NULL)
}


findExifToolCommand <- function(quiet=TRUE) {
  #try straight-up exiftool command
  if(!quiet) message("Trying 'exiftool' on the console")
  if(testCommand("exiftool --version")) {
    if(!quiet) message("Found")
    return("exiftool")
  } else {
    #find Perl, check default install location
    if(!quiet) message("Checking Perl installation")
    perlpaths <- c("perl", "C:\\Perl64\\bin\\perl", "C:\\Perl\\bin\\perl",
                   "c:\\Strawberry\\perl\\bin\\perl")
    perlpath <- NULL
    for(pp in perlpaths) {
      if(testCommand(paste(pp, "--version"))) {
        #found perl
        perlpath <- pp
        break
      }
    }
    if(is.null(perlpath)) {
      stop("Perl is required for exifr and was not found at any of the following locations: ",
           paste(perlpaths, collapse=" "))
    }
    if(!quiet) message("Found perl at ", perlpath, "; looking for ExifTool")
    #look for exiftool/exiftool.pl in two locations:
    #file.path(path.package("exifr"), ".exiftool/exiftool.pl"), and file.path("~", ".exiftool/exiftool.pl")
    commands <- c(paste(perlpath, file.path(path.package("exifr"), ".exiftool/exiftool.pl")),
                  paste(perlpath, file.path("~", ".exiftool/exiftool.pl")))

    for(command in commands) {
      if(testCommand(paste(command, "--version"))) {
        if(!quiet) message("Found valid exiftool command: ", command)
        return(command)
      }
    }

    #perl is installed, but not ExifTool
    if(!quiet) message("No valid ExifTool installation")
    return(NULL)
  }
}

testCommand <- function(command) {
  suppressWarnings(suppressMessages(0==try(system(command, ignore.stdout = TRUE,
                                                  ignore.stderr = TRUE, show.output.on.console = FALSE), silent=TRUE)))
}

installExifTool <- function(quiet=TRUE) {
  installocs <- c(path.package("exifr"), path.expand("~"))
  exiftoolurl <- "http://paleolimbot.github.io/exifr/exiftool.zip"
  #check for a writable install location
  if(!quiet) message("Checking for writable install location")
  installoc <- NULL
  for(il in installlocs) {
    if(file.access(il, mode=2)) {
      installloc <- il
      break
    }
  }

  if(is.null(installloc)) {
    stop("Could not find writable install location to install ExifTool: tried ",
         paste(installocs, collapse=" "))
  }

  if(!quiet) message("Attempting to install ExifTool to ", installloc)

  #download exiftool zip
  tryCatch({
    zipfile <- file.path(installoc, "exiftool.zip")
    if(!quiet) message("Downloading ExifTool from ", exiftoolurl)
    download.file(exiftoolurl, zipfile, quiet = quiet)
    #check download
    if(!file.exists(zipfile)) {
      stop("Error downloading ExifTool from ", exiftoolurl)
    }
    #unzip
    if(!quiet) message("Extracting ExifTool to ", installloc)
    unzip(zipfile, installloc)
    #remove zip file
    unlink(zipfile)
    #return success
    return(TRUE)
  }, error=function(e){
    stop("Error installing ExifTool: ", e)
  })

}





