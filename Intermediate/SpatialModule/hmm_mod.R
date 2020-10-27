#### WORKSHOP TITLE, CCTWS 2020
#### Module #3: Spatial stuff in R
#### Author: Hanna McCaslin


########################
# Objectives for this module:
#   1. Load and visualize spatial data in R 
#   2. Basic manipulation of different spatial data types 
#   3. Extract spatial data to use in analysis

#### Note: I recommend setting working directory to "SpatialModule"

########################
####  Demonstration #### 
########################

####
####  Intro to spatial data & analysis in R
####
library(maps) #One (of many) packages with built in spatial data

map("state")

map("state", "Colorado")
map("state", c("Colorado", "Wyoming", "Utah", "Idaho"))

data(us.cities) #attach built-in data "us.cities"
CO.cities <- us.cities[c(322,247,360,728,192),] #pick out a few cities
CO.cities
CO.cities$name <- c("Fort Collins","Denver","Grand Junction","Pueblo","Colorado Springs")

map("state","Colorado",xlim=c(-111,-100),ylim=c(36.5,41.5))  #map with a few cities
map.cities(CO.cities, country="CO",pch=17,cex=1.5,label=TRUE)


####
####  Import spatial data
####
# Import shape file 
library(rgdal)
colorado_shp <- readOGR(dsn = "shapefiles/colorado/colorado.shp")
plot(colorado_shp)

# Import KML file
mtlion_kml <- readOGR(dsn = "mtlion.kml")
plot(mtlion_kml, pch = 1, cex = 0.75, col = "blue")

plot(colorado_shp)
points(mtlion_kml, pch = 1, cex = 0.75, col = "blue")

# Import points data
mtlion <- read.table("mtlion.csv", header=T, sep=",")  
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

####
####  crs 
####
library(raster) # package for working with raster data (next), contains crs() function
library(sp) # package that contains data structures and functions for working with POINT & POLYGON spatial data

crs(colorado_shp) 
crs(mtlion_kml) 

# Project data into another projection (for making nice maps, matching different data up)
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
mtlion_pts <- mtlion
coordinates(mtlion_pts) <-  ~Longitude + Latitude

head(mtlion_pts@data)
head(mtlion)

# Need to define its crs() - **this is different from changing projection**
crs(mtlion_pts)
crs(mtlion_pts) <- wgs 
     # there are other options for setting this 
     # crs(mtlion_pts), proj string itself

# Plot
plot(colorado_shp, xlim = c(-105.76, -105.25), ylim = c(39.24,39.75))
points(mtlion$Longitude, y = mtlion$Latitude, pch = 1, cex = 0.3, col = "red") # from the dataframe
points(mtlion_pts, cex=0.2, col = "blue") #same, syntax different

####
####  Raster
####

# Basic raster 
r <- raster(ncol=3, nrow=3, xmn=0, xmx=3, ymn=0, ymx=3)
r

#populate the raster with a draw of values from a poisson distribution  
r[] = 1:9
res(r) #check the resolution of the raster cells
ncell(r) #check that the number of cells matches the defined size

plot(r, axes=F)
text(r)
r[1]
r[,1]
r[1,]

#Misc about this raster
cellStats(r, stat = mean)
cellStats(r, stat = max)

# Raster example 
nlcd <- raster("fort_collins.tif") 
crs(nlcd)
res(nlcd) #resolution in the units 
ncell(nlcd) # total number of cells in the raster

plot(nlcd) # may take a few seconds

csu <- c(-105.081631,40.575047) #plot this ontop of 
points(csu) # Why doesn't this work? ...

#... Not the right projection, 
#####
# Brief exercise: turn this CSU point into a spatial object with a crs and project 
# it so that it it plots on the map of fort collins
#####



#####
#NLCD landcover types are categories, so first we'll convert the raster to categorical data, and then associate each category with the names of the landcover type
summary(values(nlcd))

nlcd <- as.factor(nlcd)
unique(nlcd)

#add names of categories to raster layer
land_cover <-  levels(nlcd)[[1]]

#these are the names of the landcover types. The order here maters and aligns with factor order, i.e., 11, 21, 22...
land_cover[,"landcover"] <- c("Open Water", "Developed, Open Space","Developed, Low Intensity",
                             "Developed, Medium Intensity","Developed, High Intensity",
                             "Barren Land","Deciduous Forest", "Evergreen Forest","Mixed Forest",
                             "Shrub/Scrub","Grassland/Herbaceous","Pasture/Hay","Cultivated Crops",
                             "Woody Wetlands","Emergent Herbaceous Wetlands")
levels(nlcd) <- land_cover
print(land_cover)

#assign a color for each landcover type. This is a fairly standard cover scheme for NLCD. Again, the order maters. 
land_col <-  c("#4f6d9f", "#decece", "#d29b85", "#de3021", "#9d1f15",
             "#b2afa5", "#7aa76d", "#336338", "#c0cb99","#cebb89", "#edecd0",
             "#ddd75c", "#a67538", "#bfd7eb", "#7ba3be")

library(rasterVis)
nlcd_plot <- levelplot(nlcd, col.regions=land_col, xlab="", ylab="", main="Greater Fort Collins NLCD 2011")
nlcd_plot

# Crop to a smaller area 
citypark_shp <- readOGR(dsn = "shapefiles/City_Park/City_Park.shp")
crs(citypark_shp)
crs(nlcd) #these are not identical, but very close, so will work for our use

plot(nlcd)
plot(citypark_shp, add = T)

nlcd_crop <- crop(nlcd, citypark_shp)
plot(nlcd_crop)
plot(citypark_shp, add = T)

# Write this new raster out as an image file
writeRaster(nlcd_crop, filename="nlcd_cropped.tif", format = "GTiff")


#####################
####  Exercises  #### 
#####################
## We are going to investigate the relationship between elevation and mountain 
## lion home range

# Read in elevation raster
elevation <- raster("elevation.tif")
plot(elevation)

# Project mtn lion data to match raster 
crs(elevation)
crs(mtlion_pts) #could also use kml, but regular dataframes don't have crs's

mtlion_proj <- spTransform(mtlion_pts, crs(elevation))

# Plot the elevation raster and mountain lion points
plot(elevation)
points(mtlion_proj) 

# crop to a smaller raster around the points
ext <- drawExtent() # This is handy, but not reproducible unless you save the values by hand
ext
ext_save <- c(ext[1:4])

elev_crop <- crop(elevation, ext)
plot(elev_crop)
points(mtlion_proj)

# To investigate if there a relationship between mountain lion home range and elevation, 
# we'll extract the elevation at each of the mountain lion points

# extract spatial data each mountain lion location
mtlion$elevation <- extract(elev_crop, mtlion_proj) 
View(mtlion) # have to be a little careful to keep the elevations associated with the right observations

# Now can use these values as a variable in analysis

