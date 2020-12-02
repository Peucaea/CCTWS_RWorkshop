#### WORKSHOP TITLE, CCTWS 2020
#### Module #1: Occupancy Data Preparation
#### Author: Tawni Riepe


########################
# Notes:
#   1. Single season occupancy model we want our data to include a single for for each site
#   2. Need three columns (for each visit) for detection at each site or location (i.e. 110, 000, 101, 111)
#   3. Need three columns for each of the detection variables

########################
#  Libraries:

library(dplyr)

########################
####  Demonstration #### 
########################

####
####  Upload and View Data
####

setwd("~/Desktop/Workshops/CCTWS R Workshop/CCTWS_RWorkshop/Intermediate/Occupancy Modules/Module 1 - Data Prep") # set working directory

frogs <- read.csv("raw_survey_data.csv") #read raw frog data into R
sitecoords1 <- read.csv("point_locations.csv") #read coordinate data into R

View(frogs) # view data sheet

unique(frogs$species) #view the number of species

####
####  Subset each of the three visits to coordinate data
####

#  1. Extract first visits to each site 

frogsV1 <- subset(frogs, visit ==1) #subset all variables from the first visit at each site.

#  2. Link coordinate data with each site 

lookup_1a <- merge(x = sitecoords1, by.x = "point_id", y = frogsV1, 
                   by.y = "pointID", all.x = TRUE)   #similar to a Vlookup in excel, "search in sitecoords1 data for point_id then match the point_id in frogsV1 data
                                                     #to the column labeled pointID and merge"

#  3. Identify sites as a group for the summarise() function for the analysis. Changes the structure of the data.

lookup_1b <- group_by(lookup_1a, point_id)

#  4. Summarize each dataset for each detection covariate. Summarise() gives you summary data for each covariate at each site.

lookup_1cloud <- data.frame(summarise(lookup_1b, cloud = mean(cloud))) # mean could be max, min, etc
lookup_1julian <- data.frame(summarise(lookup_1b, julian = mean(date)))
lookup_1temp <- data.frame(summarise(lookup_1b, temp = mean(temp)))


#####################
####  Challenges ####
#####################

#  1. Link coordinate data for the other two visits with each site and determine the mean for each coviariate at each site


####
####  Create Detection Histories 
####

#  1. Combine each visit covariate with each type of covariate.

point_idValues <- data.frame("point_id" = lookup_1cloud$point_id) # create dataframe for point id values from any dataframe.

#Combine all three site covariates for cloud cover for each visit
cloudVals <- cbind("cloud1" = lookup_1cloud$cloud, "cloud2" = lookup_2cloud$cloud, "cloud3" = lookup_3cloud$cloud) 

#Combine all three site covariates for date (julian) for each visit
julianVals <- cbind("julian1" = lookup_1julian$julian, "julian2" = lookup_2julian$julian, "julian3" = lookup_3julian$julian)

#Combine all three site covariates for temperature for each visit
tempVals <- cbind("temp1" = lookup_1temp$temp, "temp2" = lookup_2temp$temp, "temp3" = lookup_3temp$temp)

#  2. Combine all site covariates by visit into a single data set

AllDetCov <- cbind(point_idValues, cloudVals, julianVals, tempVals)
View(AllDetCov)

#  3. Remove any detections of frogs that occured beyond 100m from the observer

frogs100 <- subset(frogs, distance <= 100) #keep only less than 100
frogsV1 <- subset(frogs100, visit ==1) #removes all data except from visit 1
frogsV2 <- subset(frogs100, visit ==2) #removes all data except from visit 2
frogsV3 <- subset(frogs100, visit ==3) #removes all data except from visit 3

#  4. Subset a single species (single species occupancy model)

focalspecies <- "wood frog" #focus on the wood frog from the data set

frogsV1_foc <- subset(frogsV1, species == focalspecies)
frogsV2_foc <- subset(frogsV2, species == focalspecies)
frogsV3_foc <- subset(frogsV3, species == focalspecies)

#  5. Create detection history

##extract abundance data from the first visit for the wood frog
lookup1 <- merge(x = sitecoords1, by.x = "point_id", y = frogsV1_foc, by.y = "pointID",
                 all.x = TRUE)

##convert nondetectections to a 0 in the abundance column
lookup1$abundance[is.na(lookup1$abundance)] <- 0 #make all NA values a 0 in the abundance column
lookup1 <- mutate(lookup1, vis1 # create new column called vis1 for occupancy
                  = if_else(abundance == 0,0,1)) #if else statement if abundace = 0 then occupancy = 0 if not then 1.

visit1data <- data.frame("v1" = lookup1$vis1, "point1" = lookup1$point_id) #create single data for site and occupancy

###Complete for the other two visits

##Visit 2
lookup2 <- merge(x = sitecoords1, by.x = "point_id", y = frogsV2_foc, by.y = "pointID",
                 all.x = TRUE)
lookup2$abundance[is.na(lookup2$abundance)] <- 0
lookup2 <- mutate(lookup2, vis2 = if_else(abundance == 0,0,1))

visit2data <- data.frame("v2" = lookup2$vis2, "point2" = lookup1$point_id) 

##Visit 3  

lookup3 <- merge(x = sitecoords1, by.x = "point_id", y = frogsV3_foc, by.y = "pointID",
                 all.x = TRUE)
lookup3$abundance[is.na(lookup3$abundance)] <-0
lookup3 <- mutate(lookup3, vis3 = if_else(abundance == 0,0,1))

visit3data <- data.frame("v3" = lookup3$vis3, "point3" = lookup1$point_id)


#  6. Combine all visits together

det.history <- cbind(visit1data, visit2data, visit3data) #detection histories for all three visits for the wood frog

site.history <- merge(x = sitecoords1, by.x = "point_id", y = det.history, 
                      by.y = "point1", all.x = TRUE) #combine detection history and coordinate information

View(site.history) #three columns that are the same

site.history <- subset(site.history, select = - pointid)#delete unwanted columns from the site.history data 
site.history <- subset(site.history, select = - point2)
site.history <- subset(site.history, select = - point3)

#  7. Combine into a single data file for analysis

WoodFrogOccupancyData <- merge(x = site.history, by.x = "point_id", y = AllDetCov, by.y = "point_id",
                           all.x = TRUE)
View(WoodFrogOccupancyData)
write.csv(WoodFrogOccupancyData, "woodfrog.occupancy.csv")












