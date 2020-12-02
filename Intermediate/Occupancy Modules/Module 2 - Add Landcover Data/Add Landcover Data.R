#### WORKSHOP TITLE, CCTWS 2020
#### Module #2: Adding Landcover Data to your occcupancy data
#### Author: Tawni Riepe


########################
# Notes:
#   1. Add landcover data from the National Land Cover Database (NLCD). 
#       Good to use when you don't have a lot of site covariates
#       Can also use other layers (NDVI, riparian area coverage etc)
#   2. Raster data projected in Alber's Equal Area Conic projection
#   3. For short hand projection codes visit https://www.r-bloggers.com/map-projections-for-r-shapefiles-united-states/

########################
#  Libraries:

library(raster)
library(dplyr)

########################
####  Demonstration #### 
########################

setwd("~/Desktop/Workshops/CCTWS R Workshop/CCTWS_RWorkshop/Intermediate/Occupancy Modules/Module 2 - Add Landcover Data")

####
####  Loading Raster data from NLCD
####

#  1. Add NLCD data as a raster

nlcd_data <- raster("state_college_nlcd.tif")
nlcd_data <- setMinMax(nlcd_data) #set extent of the raste

#  2. Project raster in the area we are interested in (AEAC projection)

nlcd_data_a <- projectRaster(from = nlcd_data, crs = "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0+y_0=0 
                             +ellps=GRS80 +datum=NAD83 +units=m +no_defs")

#  3. Add coordinates from the wood frog data and turn into a spatial object

coords1 <- data.frame(cbind("long" = site.history$long, "lat" = site.history$lat))

sites1 <- sf::st_as_sf( #sf = turns coordinates into spatial objects
  coords1, coords = c("long","lat"), 
  crs = 4269) #coordinate reference system (crs) = 4269 represents NAD83

#project points into the same crs as the raster
sites1 <- sf::st_transform(sites1, crs = "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 
                           +ellps=GRS80 +datum=NAD83 +units=m +no_defs")

#  4. Plot the data

plot(nlcd_data_a, xlim = c(xmin(nlcd_data_a) + 15000, xmax(nlcd_data_a) - 15000),
     ylim = c(ymin(nlcd_data_a) + 10000, ymax(nlcd_data_a))) 
plot(nlcd_data_a, add = TRUE)   #plot landcover data with min and max

plot(sites1, add = TRUE)  #add site coordinate where wood frog observations occurred

####
####  Extract Landcover data for occupancy analysis use
####

#  1. Extract landcover data within a 500m buffer zone around each point 

extract1 <- raster::extract(x = nlcd_data_a, y = sites1, buffer = 500, df = TRUE)
extract1 <- data.frame(extract1)

##summarize the data so we understand it..
NLCD_freq <- mutate(extract1, NLCD = as.integer(state_college_nlcd)) %>%
  group_by(ID, NLCD) %>%
  summarise(freq = n()) %>%
  ungroup() %>%
  group_by(ID) %>%
  mutate(ncells = sum(freq), prop_land = round(freq/ncells, 2) * 100) %>%
  ungroup()

##re-assign site names
sitesPicklist <- data.frame(FalseName = seq(from = 1, to = 41, length.out = 41), OrigName = site.history$point_id)

##restructure the dataset to understand the percent of landcover (10-82) and site names
wide <- full_join(NLCD_freq, sitesPicklist, by=c("ID" = "FalseName")) %>%
  dplyr::select(-ID, -freq, -ncells) %>%
  tidyr::spread(NLCD, prop_land, fill = 0)

##link site data with detection data
FinalFrogData <- as.data.frame(full_join(wide, WoodFrogOccupancyData, by = c("OrigName" = "point_id")))
View(FinalFrogData) #note 10-82 are types of landcover...could always change these to discripations.. sand to forested.
write.csv(FinalFrogData, "finalfrogdata.csv")
