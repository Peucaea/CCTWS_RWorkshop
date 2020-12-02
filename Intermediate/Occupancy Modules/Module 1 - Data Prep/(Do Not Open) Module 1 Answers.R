##############################
####  Challenges Answers  ####
####      Module 1        ####
##############################

#  1. Link coordinate data for the other two visits with each site and determine the mean for each coviariate at each site

##Visit 2
frogsV2 <- subset(frogs, visit ==2) #removes all data except from vist 2

lookup_2a <- merge(x = sitecoords1, by.x = "point_id", y = frogsV2, by.y = "pointID", 
                   all.x = TRUE) # add coordinates

lookup_2b <- group_by(lookup_2a, point_id) #group data

lookup_2cloud <- data.frame(summarise(lookup_2b, cloud = mean(cloud))) #summarise the mean of the data
lookup_2julian <- data.frame(summarise(lookup_2b, julian = mean(date)))
lookup_2temp <- data.frame(summarise(lookup_2b, temp = mean(temp)))

##Visit 3
frogsV3 <- subset(frogs, visit ==3)

lookup_3a <- merge(x = sitecoords1, by.x = "point_id", y = frogsV3, by.y = "pointID",
                   all.x = TRUE)
lookup_3b <- group_by(lookup_2a, point_id)

lookup_3cloud <- data.frame(summarise(lookup_3b, cloud = mean(cloud)))
lookup_3julian <- data.frame(summarise(lookup_3b, julian = mean(date)))
lookup_3temp <- data.frame(summarise(lookup_3b, temp = mean(temp)))

