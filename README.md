# EXIF Data in R

[![](http://cranlogs.r-pkg.org/badges/exifr)](https://cran.r-project.org/package=exifr)

Ever needed to read in EXIF data from images or other files in R? [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) by Phil Harvey is the most comprenesive tool available for reading, writing and editing meta information in a wide variety of files. ExifTool supports many different metadata formats including EXIF, GPS, IPTC, XMP, JFIF, GeoTIFF, ICC Profile, Photoshop IRB, FlashPix, AFCP and ID3, as well as the maker notes of many digital cameras by Canon, Casio, FLIR, FujiFilm, GE, HP, JVC/Victor, Kodak, Leaf, Minolta/Konica-Minolta, Motorola, Nikon, Nintendo, Olympus/Epson, Panasonic/Leica, Pentax/Asahi, Phase One, Reconyx, Ricoh, Samsung, Sanyo, Sigma/Foveon and Sony.

`exifr` provides a thin wrapper around [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) allowing the reading of image file metadata with a simple command:

```R
library(exifr)
exifr("my_file.jpg")
```

## Installation

[ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) is written in Perl, so if you are on windows you need to install Perl before installing `exifr` (easily done from [Strawberry Perl](http://www.strawberryperl.com/): [64-Bit](http://strawberryperl.com/download/5.22.1.2/strawberry-perl-5.22.1.2-64bit.msi) (most users), [32-Bit](http://strawberryperl.com/download/5.22.1.2/strawberry-perl-5.22.1.2-32bit.msi) (advanced)). Mac and linux users already have this installed. To install the `{exifr}` package, use the `devtools::install_github()` command like this:

```R
install.packages("devtools") # if you don't already have devtools installed
devtools::install_github("paleolimbot/exifr")
```
