#### WORKSHOP TITLE, CCTWS 2020
#### Module #3: Single Season Occupancy
#### Author: Tawni Riepe


########################
# Notes:
#   1. Need three main components to create an unmarked frame
#       a.  y = occupancy data for each site/visit
#       b.  siteCovs = covariates which are site specific (landcover, locations)
#       c.  obsCovs = covariates which are observation specific (julian dates, temperature, cloud cover)
#           these change at each visit
#   2. Model function occu() uses three main arguments (p, psi, and the data)
#   3. To keep p (detection probability) or psi (occupancy) constant use 1

########################
#  Libraries:

library(unmarked)
library(AICcmodavg)

########################
####  Demonstration #### 
########################

setwd("~/Desktop/Workshops/CCTWS R Workshop/CCTWS_RWorkshop/Intermediate/Occupancy Modules/Module 3 - Single Season Occupancy")

####
####  Create Unmarked Dataframe
####

frog <- read.csv("finalfrogdata.csv")
View(frog)

#  1. Use unmarkedFrameOccu() to point to the data

unmarked.data <- unmarkedFrameOccu(
  y = frog[,c('v1', 'v2', 'v3')], #detection history for each visit at each site
  siteCovs = frog[, c('X21', 'X82')], #Site covariates - they do not change across each visit
  obsCovs = list(cloud = frog[,c('cloud1', 'cloud2', 'cloud3')], #observation covariates change, need to tell where they are and rename
                 date = frog[,c('julian1', 'julian2', 'julian3')],
                 temp = frog[,c('temp1', 'temp2', 'temp3')]))


####
####  Create single covariate occupancy models for detection probability but keep occupancy constant
####
  
#  1. Create a null model for detection probability (observation covariates)

p.null <- occu(~1~1, data = unmarked.data) #occu(p, psi, data), 1 = constant
p.cloud <- occu(~cloud~1, data = unmarked.data)
p.date <- occu(~date~1, data = unmarked.data)
p.temp <- occu(~temp~1, data = unmarked.data)


#  2. Rank the models using AIC

modlist1 <- list(
  p.null = p.null, p.cloud = p.cloud,
  p.date = p.date, p.temp = p.temp)
aictab(modlist1)

### julian dates may impact detection probability. The date model (only julian dates) is the top-ranked model
### aka julian dates when frogs observed may describe the explanatin for the detection data

#  3. Visualize relationship by predicting detection probability using the date model

newdate <- data.frame(date = seq(0,365, length.out = 100)) #creating new data
pred.p <- predict(p.date, type = "det", newdata = newdate) #predict function to predict p using the p.date model

plot(1, xlim = c(0,365), ylim = c(0,1), type = "n", axes = T, xlab = "Wood frog observation dates (Julian Dates)",
     pch = 20, ylab = "Detection Probability", family = "serif",
     cex.lab = 1.25, cex.main = 1.75) # creating a blank plot
lines(newdate$date, pred.p$Predicted, col = "black", lwd = 2) #predicted values
lines(newdate$date, pred.p$lower, lty = 2, col = "black") #lower CI
lines(newdate$date, pred.p$upper, lty = 2, col = "black") #upper CI

###Interpretation: at julian day 100 - very low detection probability

#  4. Check beta coefficient 95% CI (overlapping zero suggest a weak effect)

confint(p.date, type = "det") #non overlapping
confint(p.cloud, type = "det") #overlapping - cloud cover suggests a weak effect

####
####  Create model using cloud to explain detection and use site covariates to explain occupancy
####

#  1. Create null model

psi.null <- occu(~cloud~1, data = unmarked.data)
psi.shrub <- occu(~cloud~X21, data = unmarked.data)
psi.forest <- occu(~cloud~X82, data = unmarked.data)  

#  2. Rank models with AIC

modlist2 <- list(
  psi.null = psi.null, psi.shrub = psi.shrub,
  psi.forest = psi.forest)

aictab(modlist2)

##Interpretation: The presence of shrubs may impact occupancy. 
##aka only one of the covariates we considered describes the explanation for the occupancy data (shrubs)

#  3. Visualize non-relationship by predicting detection probability using the forest model

newshrub <- data.frame(X21 = seq(0,100, length.out = 100))
pred.psi <- predict(psi.shrub, type = "state", newdata = newshrub)

plot(1, xlim=c(min(frog$X21),max(frog$X21)), ylim=c(0,1), type="n", axes=T, xlab="Shrub Cover (%)",
     pch=20, ylab="Occupancy", family="serif",
     cex.lab=1.25, cex.main=1.75)
lines(newshrub$X21, pred.psi$Predicted, col = "black", lwd = 2)
lines(newshrub$X21, pred.psi$lower, col = "black", lty = 2)
lines(newshrub$X21, pred.psi$upper, col = "black", lty = 2)

#  4. Check beta coefficient 95% CI (overlapping zero suggest a weak effect)

confint(psi.null, type = "state") 
confint(psi.shrub, type = "state")

####
####  Predict number of sites occupied
####

#  1. Number of sites occupied
s <- length(frog$v1)
post.z <- ranef(psi.shrub) #estimates abundance at each site
EBUP <- bup(post.z, stat = "mode") #creates binary variables from posterior distributions of z (bup: best unbiased predictors)
CI <- confint(post.z, level = 0.95)

## number of sites occupied
rbind(sites_occup = c(Estimate = sum(EBUP), colSums(CI)))

##proportion of sites occupied
rbind(prop.sites_occup = c(Estimate = sum(EBUP), colSums(CI))/s)

#####################
####  Challenges ####
#####################

#  1. Create a summary of other models that may affect detection probabilities for the wood frog.

#  2. Using the top model, predict what the detection probaiblity would be on julian date of 100, 200, and 300.

#  3. Create a summary of other models that may affect occupancy for the wood frog including the null and top detection probability covariate(s).

