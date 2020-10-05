#### WORKSHOP TITLE, CCTWS 2020
#### Module #3: Spatial stuff in R
#### Author: Hanna McCaslin


########################
# Notes:
#   1.
#   2. 
#   3.


########################
####  Demonstration #### 
########################

####
####  Intro to spatial data & analysis in R
####
library(maps) # One (of many) packages with built in spatial data

map("state")

map("state", "Colorado")
map("state", c("Colorado", "Wyoming", "Utah", "Idaho"))

data(us.cities) #attach built-in data "us.cities"
CO.cities <- us.cities[c(322,247,360,728,192),] # pick out a few cities
CO.cities
CO.cities$name <- c("Fort Collins","Denver","Grand Junction","Pueblo","Colorado Springs")

map("state","Colorado",xlim=c(-111,-100),ylim=c(36.5,41.5))  # map with a few cities
map.cities(CO.cities, country="CO",pch=17,cex=1.5,label=TRUE)


####
####  Import spatial data
####
# Import shape file 
library(rgdal)
colorado_shp <- readOGR(dsn = "Intermediate/shapefiles/colorado.shp")
plot(colorado_shp)

# Import KML file
mtlion_kml <- readOGR(dsn = "Intermediate/mtlion.kml")
plot(mtlion_kml, pch = 1, cex = 0.75, col = "blue")

plot(colorado_shp)
points(mtlion_kml, pch = 1, cex = 0.75, col = "blue")

# Import points data
mtlion <- read.table("Intermediate/mtlion.csv", header=T, sep=",")  
View(mtlion)
points(mtlion$Longitude, y = mtlion$Latitude, pch = 1, cex = 0.3, col = "red")

# Base R plot
plot(colorado_shp)
points(mtlion$Longitude, y = mtlion$Latitude, pch = 1, cex = 0.3, col = "red")

# Let's zoom in on the mountain lion locations - use the data frame version for now
# Use the range of the lat/lons
range(mtlion$Longitude)
range(mtlion$Latitude)

plot(colorado_shp, xlim = c(-105.76, -105.25), ylim = c(39.24,39.75))
points(mtlion$Longitude, y = mtlion$Latitude, pch = 1, cex = 0.3, col = "red")

####  crs 
####
library(raster) # package for working with raster data (next), contains crs() function
library(sp) # package that contains data structures and functions for working with POINT & POLYGON spatial data

crs(colorado_shp) 
crs(mtlion_kml) 

# Project data into another projection (for making nice maps)
wgs <- crs(colorado_shp)
albers_projection <- "+proj=aea +lat_0=23 +lon_0=-96 +lat_1=29.5 +lat_2=45.5 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs"

colorado_shp_aea <- spTransform(colorado_shp, albers_projection)
crs(colorado_shp_aea)
plot(colorado_shp_aea)
plot(colorado_shp)

####
####  Points & polygons data 
####
# Let's turn mtlion dataframe into spatial data 

# Need to define its crs() - note this is different from changing projection

# Plot


####
####  Raster
####

# Basic raster 
##### TBD #####

# Raster example
nlcd <- raster("Intermediate/co_nlcd2011.tif") # change my strategy to use the fort collins nlcd 
crs(nlcd)
res(nlcd) # resolution in lat/lon (30m x 30m)
ncell(nlcd) # total number of cells in the raster

plot(nlcd) # will take a few seconds

# Let's crop the raster to a smaller rectangle around the mountain lion locations
ext <- extent(-105.76, -105.25, 39.24,39.75) #first create new, smaller extent. The values are ordered according to the following the format: xmin, xmax, ymin, ymax.

nlcd_crop <- crop(nlcd, ext)
ncell(nlcd_crop) 

plot(nlcd_crop)
points(mtlion$Longitude, y = mtlion$Latitude, pch = 1, cex = 0.3)

#write this new raster out as an image file
writeRaster(nlcd_crop, filename="nlcd_cropped.tif", format = "GTiff")

#####################
####  Exercises  #### #create and map a KDE in R
#####################

#NLCD landcover types are categories, so first we'll convert the raster to categorical data, and then associate each category with the names of the landcover type

nlcd_crop <- as.factor(nlcd_crop)
unique(nlcd_crop)

#add names of categories to raster layer
land_cover = levels(nlcd)[[1]]

#these are the names of the landcover types. The order here maters and aligns with factor order, i.e., 11, 21, 22...
land_cover[,"landcover"] = c("Open Water", "Developed, Open Space","Developed, Low Intensity",
                             "Developed, Medium Intensity","Developed, High Intensity",
                             "Barren Land","Deciduous Forest", "Evergreen Forest","Mixed Forest",
                             "Shrub/Scrub","Grassland/Herbaceous","Pasture/Hay","Cultivated Crops",
                             "Woody Wetlands","Emergent Herbaceous Wetlands")
levels(nlcd) = land_cover
print(land_cover)

# look at relative abundance of the landcover types


# Kernel density estimate for mountain lion home range




# Is there a relationship between mountain lion home range and landcover?
# Project mtn lion data to match raster

# extract what landocver types are at each mountain lion location
extract()

# any patterns?




