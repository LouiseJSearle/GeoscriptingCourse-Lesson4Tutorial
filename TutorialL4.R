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

?dataType
# Setting the data type is useful if you want to write values to disk. 
# In other cases use functions such as round()
# Datatype definition     minimum possible value	maximum possible value
# LOG1S	 FALSE (0)	 TRUE (1)
# INT1S	 -127	 127
# INT1U	 0	 255
# INT2S	 -32,767	 32,767
# INT2U	 0	 65,534
# INT4S	 -2,147,483,647	 2,147,483,647
# INT4U	 0	 4,294,967,296
# FLT4S	 -3.4e+38	 3.4e+38
# FLT8S	 -1.7e+308	 1.7e+308

## 6.4 Croping a raster objectvv

# Plot the first layer of the RasterBrick
plot(gewata, 1)
e <- drawExtent(show=TRUE) ## you click on map to select extent!
# Crop gewata using e
gewataSub <- crop(gewata, e)
# Now visualize the new cropped object
plot(gewataSub, 1)

## 6.5 Creating layer stacks

# Again, make sure that your working directory is properly set
getwd()

# Download the data
fileUrl <- "https://github.com/GeoScripting-WUR/IntroToRaster/raw/gh-pages/data/tura.zip"
download(fileUrl, "tura.zip", mode = "wb")
unzip(zipfile='tura.zip')

# Retrieve the content of the tura sub-directory
list <- list.files(path='tura/', full.names=TRUE)
plot(raster(list[1]))

# Create stack of files
turaStack <- stack(list)
turaStack

# Write this file at the root of the working directory
writeRaster(x=turaStack, filename='turaStack.grd', datatype='INT2S')

## 7 Simple raster arithmetic

## 7.2 Subsetting layers from from RasterStack and RasterBrick

ndvi <- (gewata[[4]] - gewata[[3]]) / (gewata[[4]] + gewata[[3]])
plot(ndvi)

# Define the function to calculate NDVI from 
# calc()
ndvCalc <- function(x) {
     ndvi <- (x[[4]] - x[[3]]) / (x[[4]] + x[[3]])
     return(ndvi)
}
ndvi2 <- calc(x=gewata, fun=ndvCalc)
# overlay()
ndvOver <- function(x, y) {
     ndvi <- (y - x) / (x + y)
     return(ndvi)
}
ndvi3 <- overlay(x=gewata[[3]], y=gewata[[4]], fun=ndvOver)
# Verify
all.equal(ndvi, ndvi2)
# TRUE
all.equal(ndvi, ndvi3)
# TRUE

## 7.3 Re-projections

# One single line is sufficient to project any raster to any projection
ndviLL <- projectRaster(ndvi, crs='+proj=longlat')

