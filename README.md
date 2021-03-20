
<!-- README.md is generated from README.Rmd. Please edit that file -->

# exifr

[![Travis-CI Build
Status](https://travis-ci.org/paleolimbot/exifr.svg?branch=master)](https://travis-ci.org/paleolimbot/exifr)
[![Coverage
Status](https://img.shields.io/codecov/c/github/paleolimbot/exifr/master.svg)](https://codecov.io/github/paleolimbot/exifr?branch=master)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/exifr)](https://cran.r-project.org/package=exifr)

Ever needed to read in EXIF data from images or other files in R?
[ExifTool](https://exiftool.org) by Phil Harvey is the most comprenesive
tool available for reading, writing and editing meta information in a
wide variety of files. ExifTool supports many different metadata formats
including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop
IRB, FlashPix, AFCP and ID3, as well as the maker notes of many digital
cameras by Canon, Casio, FLIR, FujiFilm, GE, HP, JVC/Victor, Kodak,
Leaf, Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson,
Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung,
Sanyo, Sigma/Foveon and Sony. This package provides a thin wrapper
around [ExifTool](https://exiftool.org) allowing the reading of image
file metadata with a single command.

## Installation

You will need Perl to use exifr, which may already be installed on your
system (Mac, Linux). If you are on Windows you need to install Perl
before installing exifr (easily done from [Strawberry
Perl](https://strawberryperl.com/) or [Active State
Perl](https://www.activestate.com/activeperl/downloads/). Mac users can
also install ExifTool directly from
[sourceforge](https://sourceforge.net/projects/exiftool/files/), which
is not necessary but may be useful if ExifTool is to be used outside of
R.

You can install exifr from github with:

``` r
# install.packages("devtools")
devtools::install_github("paleolimbot/exifr")
```

…or from CRAN with:

``` r
install.packages("exifr")
```

If you can load the package, everything should be installed correctly:

``` r
library(exifr)
#> Using ExifTool version 12.22
```

## Example

It makes the most sense to use the `read_exif()` function with
`list.files()`, but it will also process directories (when using
`recursive = TRUE`).

``` r
image_files <- list.files(system.file("images", package = "exifr"), full.names = TRUE)
read_exif(image_files)
#> # A tibble: 2 x 275
#>   SourceFile ExifToolVersion FileName Directory FileSize FileModifyDate
#>   <chr>                <dbl> <chr>    <chr>        <int> <chr>         
#> 1 /Library/…            12.2 binary_… /Library…    13726 2021:03:20 10…
#> 2 /Library/…            12.2 Canon.j… /Library…     2697 2021:03:20 10…
#> # … with 269 more variables: FileAccessDate <chr>, FileInodeChangeDate <chr>,
#> #   FilePermissions <int>, FileType <chr>, FileTypeExtension <chr>,
#> #   MIMEType <chr>, JFIFVersion <chr>, ExifByteOrder <chr>, Make <chr>,
#> #   Model <chr>, Orientation <int>, XResolution <int>, YResolution <int>,
#> #   ResolutionUnit <int>, Software <chr>, ModifyDate <chr>, Artist <chr>,
#> #   YCbCrPositioning <int>, ExposureTime <dbl>, FNumber <dbl>,
#> #   ExposureProgram <int>, ISO <int>, SensitivityType <int>, ExifVersion <chr>,
#> #   DateTimeOriginal <chr>, CreateDate <chr>, ComponentsConfiguration <chr>,
#> #   CompressedBitsPerPixel <int>, ExposureCompensation <dbl>,
#> #   MaxApertureValue <dbl>, MeteringMode <int>, LightSource <int>, Flash <int>,
#> #   FocalLength <dbl>, Warning <chr>, ImageQuality <int>,
#> #   FirmwareVersion <chr>, WhiteBalance <int>, FocusMode <int>,
#> #   AFAreaMode <chr>, ImageStabilization <int>, MacroMode <int>,
#> #   ShootingMode <int>, Audio <int>, DataDump <chr>, WhiteBalanceBias <int>,
#> #   FlashBias <int>, InternalSerialNumber <chr>, PanasonicExifVersion <chr>,
#> #   VideoFrameRate <int>, ColorEffect <int>, TimeSincePowerOn <dbl>,
#> #   BurstMode <int>, SequenceNumber <int>, ContrastMode <int>,
#> #   NoiseReduction <int>, SelfTimer <int>, Rotation <int>, AFAssistLamp <int>,
#> #   ColorMode <int>, OpticalZoomMode <int>, ConversionLens <int>,
#> #   TravelDay <int>, BatteryLevel <int>, WorldTimeLocation <int>,
#> #   ProgramISO <int>, AdvancedSceneType <int>, FacesDetected <int>,
#> #   AFPointPosition <chr>, NumFacePositions <int>, Face1Position <chr>,
#> #   Face2Position <chr>, Face3Position <chr>, Face4Position <chr>,
#> #   Face5Position <chr>, IntelligentExposure <int>, FacesRecognized <int>,
#> #   RecognizedFace1Name <chr>, RecognizedFace1Position <chr>,
#> #   RecognizedFace1Age <chr>, RecognizedFace2Name <chr>,
#> #   RecognizedFace2Position <chr>, RecognizedFace2Age <chr>,
#> #   RecognizedFace3Name <chr>, RecognizedFace3Position <chr>,
#> #   RecognizedFace3Age <chr>, FlashWarning <int>, Title <chr>, BabyName <chr>,
#> #   Location <chr>, IntelligentResolution <int>, HDRShot <int>,
#> #   BurstSpeed <int>, ClearRetouch <int>, WBShiftCreativeControl <int>,
#> #   SweepPanoramaDirection <int>, SweepPanoramaFieldOfView <int>,
#> #   InternalNDFilter <dbl>, FilterEffect <chr>, ClearRetouchValue <dbl>, …
```

You’ll notice there are a lot of columns\! You can choose the exact tags
you want to extract using the `tags` argument:

``` r
read_exif(image_files, tags = c("filename", "imagesize"))
#> # A tibble: 2 x 3
#>   SourceFile                                               FileName    ImageSize
#>   <chr>                                                    <chr>       <chr>    
#> 1 /Library/Frameworks/R.framework/Versions/4.0/Resources/… binary_tag… 30 25    
#> 2 /Library/Frameworks/R.framework/Versions/4.0/Resources/… Canon.jpg   8 8
```

## Details

In the background, `read_exif()` is calling `exiftool` on the console,
and reading the results to R. You can see the exact command used by
`read_exif()` by passing `quiet = FALSE`. This can be useful when
debugging, as occasionally images need to get read in that need some
kind of special treatment.

``` r
read_exif(image_files, tags = c("filename", "imagesize"), quiet = FALSE)
#> Generating command line arguments...
#> Running 1 commands
#> 'perl' '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/exifr/exiftool/exiftool.pl' -n -j -q -b -filename -imagesize '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/exifr/images/binary_tag.JPG' '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/exifr/images/Canon.jpg'
#> # A tibble: 2 x 3
#>   SourceFile                                               FileName    ImageSize
#>   <chr>                                                    <chr>       <chr>    
#> 1 /Library/Frameworks/R.framework/Versions/4.0/Resources/… binary_tag… 30 25    
#> 2 /Library/Frameworks/R.framework/Versions/4.0/Resources/… Canon.jpg   8 8
```

You can also roll-your-own `exiftool` call by using `exiftool_call()`.
For the previous example, it would look something like this:

``` r
exiftool_call(args = c("-n", "-j", "-q", "-filename", "-imagesize"), fnames = image_files)
```

    #> 'perl' '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/exifr/exiftool/exiftool.pl' -n -j -q -filename -imagesize '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/exifr/images/binary_tag.JPG' '/Library/Frameworks/R.framework/Versions/4.0/Resources/library/exifr/images/Canon.jpg'
    #> [{
    #>   "SourceFile": "/Library/Frameworks/R.framework/Versions/4.0/Resources/library/exifr/images/binary_tag.JPG",
    #>   "FileName": "binary_tag.JPG",
    #>   "ImageSize": "30 25"
    #> },
    #> {
    #>   "SourceFile": "/Library/Frameworks/R.framework/Versions/4.0/Resources/library/exifr/images/Canon.jpg",
    #>   "FileName": "Canon.jpg",
    #>   "ImageSize": "8 8"
    #> }]
