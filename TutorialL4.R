### Louise Searle
### Lesson 4 Tutorial Code

library(rgdal)
getGDALVersionInfo()

## 5 Overview of the raster package

## 5.1 Explore the raster objects

library(raster)
# Generate a RasterLAyer object
r <- raster(ncol=40, nrow=20)
class(r) 
r
# class       : RasterLayer 
# dimensions  : 20, 40, 800  (nrow, ncol, ncell)
# resolution  : 9, 9  (x, y)
# extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
# coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 

# Using the previously generated RasterLAyer object
# Let's first put some values in the cells of the layer
r[] <- rnorm(n=ncell(r))
# Create a RasterStack objects with 3 layers
s <- stack(x=c(r, r*2, r))
# The exact same procedure works for creating a RasterBrick
b <- brick(x=c(r, r*2, r))
# Let's look at the properties of of one of these two objects
b
# class       : RasterBrick 
# dimensions  : 20, 40, 800, 3  (nrow, ncol, ncell, nlayers)
# resolution  : 9, 9  (x, y)
# extent      : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
# coord. ref. : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 
# data source : in memory
# names       :   layer.1,   layer.2,   layer.3 
# min values  : -2.926181, -5.852363, -2.926181 
# max values  :  3.510031,  7.020063,  3.510031 

## 6 Raster objects manipulations

## 6.1 Reading and writing from/to file

install.packages("downloader")
require(downloader)
fileUrl <- "https://github.com/GeoScripting-WUR/IntroToRaster/raw/gh-pages/data/LE71700552001036SGS00_SR_Gewata_INT1U.tif"
download(fileUrl, "LE71700552001036SGS00_SR_Gewata_INT1U.tif", mode = "wb")
load('LE71700552001036SGS00_SR_Gewata_INT1U.tif')

list.files()
# [1] "data"                                      "LE71700552001036SGS00_SR_Gewata_INT1U.tif"
# [3] "Lesson4.Rproj"                             "outputs"                                  
# [5] "R"                                         "TutorialL4.R" 

gewata <- brick('LE71700552001036SGS00_SR_Gewata_INT1U.tif')
gewata
# class       : RasterBrick 
# dimensions  : 593, 653, 387229, 6  (nrow, ncol, ncell, nlayers)
# resolution  : 30, 30  (x, y)
# extent      : 829455, 849045, 825405, 843195  (xmin, xmax, ymin, ymax)
# coord. ref. : +proj=utm +zone=36 +ellps=WGS84 +units=m +no_defs 
# data source : /Users/Louise/Desktop/Geoscripting/Lesson4/LE71700552001036SGS00_SR_Gewata_INT1U.tif 
# names       : LE7170055//ta_INT1U.1, LE7170055//ta_INT1U.2, LE7170055//ta_INT1U.3, LE7170055//ta_INT1U.4, LE7170055//ta_INT1U.5, LE7170055//ta_INT1U.6 
# min values  :                     4,                     6,                     3,                    18,                     6,                     2 
# max values  :                    39,                    56,                    71,                   102,                   138,                   408 

gewataB1 <- raster('LE71700552001036SGS00_SR_Gewata_INT1U.tif')
gewataB1
# class       : RasterLayer 
# band        : 1  (of  6  bands)
# dimensions  : 593, 653, 387229  (nrow, ncol, ncell)
# resolution  : 30, 30  (x, y)
# extent      : 829455, 849045, 825405, 843195  (xmin, xmax, ymin, ymax)
# coord. ref. : +proj=utm +zone=36 +ellps=WGS84 +units=m +no_defs 
# data source : /Users/Louise/Desktop/Geoscripting/Lesson4/LE71700552001036SGS00_SR_Gewata_INT1U.tif 
# names       : LE71700552001036SGS00_SR_Gewata_INT1U 
# values      : 4, 39  (min, max)

