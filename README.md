# EXIF Data in R

Ever needed to read in EXIF data from images or other files in R? [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) by Phil Harvey is the most comprenesive tool available for reading, writing and editing meta information in a wide variety of files. ExifTool supports many different metadata formats including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP and ID3, as well as the maker notes of many digital cameras by Canon, Casio, FLIR, FujiFilm, GE, HP, JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung, Sanyo, Sigma/Foveon and Sony.

`exifr` provides a thin wrapper around [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) allowing the reading of image file metadata with a simple command:

```R
library(exifr)
exifr("my_file.jpg")
```

## Installation

[ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) is written in Perl, so if you are on windows you need to install Perl before installing `exifr` (easily done from [Active State](http://www.activestate.com/activeperl): [64-Bit](http://www.activestate.com/activeperl/downloads/thank-you?dl=http://downloads.activestate.com/ActivePerl/releases/5.20.3.2003/ActivePerl-5.20.3.2003-MSWin32-x64-299574.msi) (most users), [32-Bit](http://www.activestate.com/activeperl/downloads/thank-you?dl=http://downloads.activestate.com/ActivePerl/releases/5.20.3.2003/ActivePerl-5.20.3.2003-MSWin32-x86-64int-299574.msi) (advanced)). Mac and linux users already have this installed. To install the `{exifr}` package, use the `devtools::install_github()` command like this:

```R
install.packages("devtools") # if you don't already have devtools installed
devtools::install_github("paleolimbot/exifr")
```
