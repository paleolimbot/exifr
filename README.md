
<!-- README.md is generated from README.Rmd. Please edit that file -->
exifr
=====

Ever needed to read in EXIF data from images or other files in R? [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) by Phil Harvey is the most comprenesive tool available for reading, writing and editing meta information in a wide variety of files. ExifTool supports many different metadata formats including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP and ID3, as well as the maker notes of many digital cameras by Canon, Casio, FLIR, FujiFilm, GE, HP, JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung, Sanyo, Sigma/Foveon and Sony.

`exifr` provides a thin wrapper around [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) allowing the reading of image file metadata with a single command.

Installation
------------

You will need Perl to use exifr, which may already be installed on your system (Mac, Linux). If you are on Windows you need to install Perl before installing exifr (easily done from [Strawberry Perl](http://www.strawberryperl.com/) or [Active State Perl](https://www.activestate.com/activeperl/downloads).

You can install exifr from github with:

``` r
# install.packages("devtools")
devtools::install_github("paleolimbot/exifr")
```

...or from CRAN with:

``` r
install.packages("devtools")
```

If you can load the package, everything should be installed correctly:

``` r
library(exifr)
#> Trying 'exiftool' on the console...
#> Found
```

Example
-------

It makes the most sense to use the `read_exif()` function with `list.files()`, but it will also process directories (when using `recursive = TRUE`).

``` r
image_files <- list.files(system.file("images", package = "exifr"), 
                          full.names = TRUE)
read_exif(image_files)
#> # A tibble: 2 x 268
#>                                                                    SourceFile
#>                                                                         <chr>
#> 1 /Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images
#> 2 /Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images
#> # ... with 267 more variables: ExifToolVersion <dbl>, FileName <chr>,
#> #   Directory <chr>, FileSize <int>, FileModifyDate <chr>,
#> #   FileAccessDate <chr>, FileInodeChangeDate <chr>,
#> #   FilePermissions <int>, FileType <chr>, FileTypeExtension <chr>,
#> #   MIMEType <chr>, ExifByteOrder <chr>, Make <chr>, Model <chr>,
#> #   Orientation <int>, XResolution <int>, YResolution <int>,
#> #   ResolutionUnit <int>, ModifyDate <chr>, YCbCrPositioning <int>,
#> #   ExposureTime <dbl>, FNumber <dbl>, ISO <int>, ExifVersion <chr>,
#> #   DateTimeOriginal <chr>, CreateDate <chr>,
#> #   ComponentsConfiguration <chr>, CompressedBitsPerPixel <int>,
#> #   ShutterSpeedValue <int>, ApertureValue <dbl>, MaxApertureValue <dbl>,
#> #   Flash <int>, FocalLength <dbl>, MacroMode <int>, SelfTimer <int>,
#> #   Quality <int>, CanonFlashMode <int>, ContinuousDrive <int>,
#> #   FocusMode <int>, RecordMode <int>, CanonImageSize <int>,
#> #   EasyMode <int>, DigitalZoom <int>, Contrast <int>, Saturation <int>,
#> #   Sharpness <int>, CameraISO <chr>, MeteringMode <int>,
#> #   FocusRange <int>, CanonExposureMode <int>, LensType <int>,
#> #   MaxFocalLength <int>, MinFocalLength <int>, FocalUnits <int>,
#> #   MaxAperture <int>, MinAperture <dbl>, FlashActivity <int>,
#> #   FlashBits <int>, ZoomSourceWidth <int>, ZoomTargetWidth <int>,
#> #   ManualFlashOutput <int>, ColorTone <int>, FocalPlaneXSize <dbl>,
#> #   FocalPlaneYSize <dbl>, AutoISO <int>, BaseISO <int>, MeasuredEV <dbl>,
#> #   TargetAperture <dbl>, ExposureCompensation <dbl>, WhiteBalance <int>,
#> #   SlowShutter <int>, SequenceNumber <int>, OpticalZoomCode <int>,
#> #   FlashGuideNumber <int>, FlashExposureComp <int>,
#> #   AutoExposureBracketing <int>, AEBBracketValue <int>,
#> #   ControlMode <int>, FocusDistanceUpper <dbl>, FocusDistanceLower <dbl>,
#> #   MeasuredEV2 <dbl>, BulbDuration <int>, CameraType <int>,
#> #   AutoRotate <int>, NDFilter <int>, SelfTimer2 <int>, BracketMode <int>,
#> #   BracketValue <int>, BracketShotNumber <int>, CanonImageType <chr>,
#> #   CanonFirmwareVersion <chr>, SerialNumber <int>,
#> #   SerialNumberFormat <dbl>, FileNumber <int>, OwnerName <chr>,
#> #   CanonModelID <dbl>, CanonFileLength <int>, MeasuredRGGB <chr>,
#> #   WB_RGGBLevelsAuto <chr>, WB_RGGBLevelsDaylight <chr>, ...
```

You'll notice there are a lot of columns! You can choose the exact tags you want to extract using the `tags` argument:

``` r
read_exif(image_files, tags = c("filename", "imagesize"))
#> # A tibble: 2 x 3
#>                                                                    SourceFile
#>                                                                         <chr>
#> 1 /Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images
#> 2 /Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images
#> # ... with 2 more variables: FileName <chr>, ImageSize <chr>
```

Details
-------

In the background, `read_exif()` is calling `exiftool` on the console, and reading the results to R. You can see the exact command used by `read_exif()` by passing `quiet = FALSE`. This can be useful when debugging, as occasionally images need to get read in that need some kind of special treatment.

``` r
read_exif(image_files, tags = c("filename", "imagesize"), quiet = FALSE)
#> Generating command line arguments...
#> Running 1 commands
#> exiftool -n -j -q -filename -imagesize '/Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images/Canon.jpg' '/Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images/img.JPG'
#> # A tibble: 2 x 3
#>                                                                    SourceFile
#>                                                                         <chr>
#> 1 /Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images
#> 2 /Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images
#> # ... with 2 more variables: FileName <chr>, ImageSize <chr>
```

You can also roll-your-own `exiftool` call by using `exiftool_call()`. For the previous example, it would look something like this:

``` r
exiftool_call(args = c("-n", "-j", "-q", "-filename", "-imagesize"),
              fnames = image_files)
```

    #> exiftool -n -j -q -filename -imagesize '/Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images/Canon.jpg' '/Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images/img.JPG'
    #> [{
    #>   "SourceFile": "/Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images/Canon.jpg",
    #>   "FileName": "Canon.jpg",
    #>   "ImageSize": "8x8"
    #> },
    #> {
    #>   "SourceFile": "/Library/Frameworks/R.framework/Versions/3.3/Resources/library/exifr/images/img.JPG",
    #>   "FileName": "img.JPG",
    #>   "ImageSize": "30x25"
    #> }]
