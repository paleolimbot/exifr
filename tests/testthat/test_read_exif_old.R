
context("backwards compatibility")


test_that("exifr() output matches previous output", {
  cannon_old <- structure(list(SourceFile = "inst/images/Canon.jpg", ExifToolVersion = 10.61,
                               FileName = "Canon.jpg", Directory = "inst/images", FileSize = 2697L,
                               FileModifyDate = "2016:02:04 17:43:34-04:00", FileAccessDate = "2017:09:26 01:51:46-03:00",
                               FileInodeChangeDate = "2017:09:25 00:39:46-03:00", FilePermissions = 644L,
                               FileType = "JPEG", FileTypeExtension = "JPG", MIMEType = "image/jpeg",
                               ExifByteOrder = "II", Make = "Canon", Model = "Canon EOS DIGITAL REBEL",
                               Orientation = 1L, XResolution = 180L, YResolution = 180L,
                               ResolutionUnit = 2L, ModifyDate = "2003:12:04 06:46:52",
                               YCbCrPositioning = 1L, ExposureTime = 4L, FNumber = 14L,
                               ISO = 100L, ExifVersion = 221L, DateTimeOriginal = "2003:12:04 06:46:52",
                               CreateDate = "2003:12:04 06:46:52", ComponentsConfiguration = "1 2 3 0",
                               CompressedBitsPerPixel = 9L, ShutterSpeedValue = 0L, ApertureValue = 14.0000278113061,
                               MaxApertureValue = 4.49999024812953, Flash = 0L, FocalLength = 34L,
                               MacroMode = 0L, SelfTimer = 0L, Quality = 4L, CanonFlashMode = 0L,
                               ContinuousDrive = 1L, FocusMode = 3L, RecordMode = 2L, CanonImageSize = 0L,
                               EasyMode = 1L, DigitalZoom = -1L, Contrast = 1L, Saturation = 1L,
                               Sharpness = 1L, CameraISO = "n/a", MeteringMode = 5L, FocusRange = 2L,
                               CanonExposureMode = 4L, LensType = 65535L, MaxFocalLength = 55L,
                               MinFocalLength = 18L, FocalUnits = 1L, MaxAperture = 4L,
                               MinAperture = 26.9086852881189, FlashActivity = 0L, FlashBits = 0L,
                               ZoomSourceWidth = 3072L, ZoomTargetWidth = 3072L, ManualFlashOutput = 0L,
                               ColorTone = 0L, FocalPlaneXSize = 23.2156, FocalPlaneYSize = 15.494,
                               AutoISO = 100L, BaseISO = 100L, MeasuredEV = -1.25, TargetAperture = 14.2543794902454,
                               ExposureCompensation = 0L, WhiteBalance = 0L, SlowShutter = 3L,
                               SequenceNumber = 0L, OpticalZoomCode = 8L, FlashGuideNumber = 0L,
                               FlashExposureComp = 0L, AutoExposureBracketing = 0L, AEBBracketValue = 0L,
                               ControlMode = 1L, FocusDistanceUpper = 655.35, FocusDistanceLower = 5.46,
                               MeasuredEV2 = -1.25, BulbDuration = 4L, CameraType = 252L,
                               AutoRotate = 0L, NDFilter = -1L, SelfTimer2 = 0L, BracketMode = 0L,
                               BracketValue = 0L, BracketShotNumber = 0L, CanonImageType = "CRW:EOS DIGITAL REBEL CMOS RAW",
                               CanonFirmwareVersion = "Firmware Version 1.1.1", SerialNumber = 560018150L,
                               SerialNumberFormat = 2415919104, FileNumber = 1181861L, OwnerName = "Phil Harvey",
                               CanonModelID = 2147484016, CanonFileLength = 4480822L, MeasuredRGGB = "998 1022 1026 808",
                               WB_RGGBLevelsAuto = "1719 832 831 990", WB_RGGBLevelsDaylight = "1722 832 831 989",
                               WB_RGGBLevelsShade = "2035 832 831 839", WB_RGGBLevelsCloudy = "1878 832 831 903",
                               WB_RGGBLevelsTungsten = "1228 913 912 1668", WB_RGGBLevelsFluorescent = "1506 842 841 1381",
                               WB_RGGBLevelsFlash = "1933 832 831 895", WB_RGGBLevelsCustom = "1722 832 831 989",
                               WB_RGGBLevelsKelvin = "1722 832 831 988", WB_RGGBBlackLevels = "124 123 124 123",
                               ColorTemperature = 5200L, NumAFPoints = 7L, ValidAFPoints = 7L,
                               CanonImageWidth = 3072L, CanonImageHeight = 2048L, AFImageWidth = 3072L,
                               AFImageHeight = 2048L, AFAreaWidth = 151L, AFAreaHeight = 151L,
                               AFAreaXPositions = "1014 608 0 0 0 -608 -1014", AFAreaYPositions = "0 0 -506 0 506 0 0",
                               AFPointsInFocus = 0L, ThumbnailImageValidArea = "0 159 7 112",
                               UserComment = NA, FlashpixVersion = 100L, ColorSpace = 1L,
                               ExifImageWidth = 160L, ExifImageHeight = 120L, InteropIndex = "THM",
                               InteropVersion = 100L, RelatedImageWidth = 3072L, RelatedImageHeight = 2048L,
                               FocalPlaneXResolution = 3443.946188, FocalPlaneYResolution = 3442.016807,
                               FocalPlaneResolutionUnit = 2L, SensingMethod = 2L, FileSource = 3L,
                               CustomRendered = 0L, ExposureMode = 1L, SceneCaptureType = 0L,
                               ImageWidth = 8L, ImageHeight = 8L, EncodingProcess = 0L,
                               BitsPerSample = 8L, ColorComponents = 3L, YCbCrSubSampling = "2 2",
                               Aperture = 14L, DriveMode = 0L, ImageSize = "8x8", Lens = 18L,
                               LensID = 65535L, Megapixels = 6.4e-05, ScaleFactor35efl = 1.58865289136055,
                               ShootingMode = 7L, ShutterSpeed = 4L, WB_RGGBLevels = "1719 832 831 990",
                               BlueBalance = 1.19061936259772, CircleOfConfusion = 0.018913043114871,
                               DOF = "4.30934711141906 0", FOV = 36.8608919968783, FocalLength35efl = 54.0141983062587,
                               HyperfocalDistance = 4.36584573248839, Lens35efl = 28.5957520444899,
                               LightValue = 5.61470984411521, RedBalance = 2.06734816596512),
                          class = "data.frame", row.names = c(NA, -1L))
  cannon_new <- exifr(system.file("images/Canon.jpg", package = "exifr"))
  expect_true(setequal(colnames(cannon_new), colnames(cannon_old)))

  # some columns aren't quite the same due to guessing by read.csv
  cols <- setdiff(names(cannon_old), c("FileAccessDate", "FileModifyDate", "FileInodeChangeDate",
                                       "ExifVersion", "UserComment", "Directory", "SourceFile",
                                       "FlashpixVersion", "InteropVersion",
                                       "FilePermissions"))
  expect_identical(cannon_old[cols], as.data.frame(cannon_new[cols]))

  # check for deprecation message
  expect_message(exifr(system.file("images/Canon.jpg", package = "exifr")),
                 "exifr\\(\\) is deprecated")
})

test_that("deprecation message exists for exiftool.call", {
  expect_identical(
    exiftool.call(args = "--help", intern = TRUE),
    exiftool_call(args = "--help", intern = TRUE)
  )
  expect_message(exiftool.call(args = "--help", intern = TRUE),
                 "exiftool\\.call has been deprecated")
})
