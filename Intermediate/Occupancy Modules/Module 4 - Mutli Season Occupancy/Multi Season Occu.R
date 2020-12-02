#### WORKSHOP TITLE, CCTWS 2020
#### Module #4: Multi Season Occupancy Modeling
#### Author: Tawni Riepe


########################
# Notes:
#   1. Dynamic modeling that is useful to make predictions over multiple years
#   2. Adding two more parameters: colonization (gamma) and extinction (epsilon)
#   3. Still have p and psi but psi is typically derived because we can only obtain the parmeter estimate for the 
#      first season of the study and patterns after must be inferred
#   4. Multi season occupancy uses four states
#       a. y = detection histories
#       b. yearlySiteCovs = covariates which are site specific but change every year
#       c. siteCovs = site specific covariates but remain stable over time 
#       d. obsCovs: observation specific

########################
#  Libraries:

library(unmarked)
library(AICcmodavg)

########################
####  Demonstration #### 
########################

setwd("~/Desktop/Workshops/CCTWS R Workshop/CCTWS_RWorkshop/Intermediate/Occupancy Modules/Module 4 - Mutli Season Occupancy")
mdata <- read.csv("finalfrogdata.multi.csv")
View(mdata)

####
####  Create Unmarked Dataframe
####

#  1. Define input datasets

M <- (nrow(mdata)) #number of site = M
J <- 2 #number of secondary sampling periods (visits per season)
T <- 3 #number of primary sample periods (seasons)

#  2. Create a matrix with the observation covariates and detection histories across all years.

yy <- matrix(c(mdata$det1.1, mdata$det1.2,  #detection histories for visit 1 and 2 in year 1
               mdata$det2.1, mdata$det2.2,  #detection histories for visit 1 and 2 in year 2
               mdata$det3.1, mdata$det3.2), #detection histories for visit 1 and 2 in year 3
             M, #number of rows in your matrix
             J*T #number of columns in your matrix (JxT because you are resampling during ever sampling occasion)
)

cloud <- matrix(c(mdata$cloud1.1, mdata$cloud1.2,  #cloud coverage for visit 1 and 2 in year 1
                  mdata$cloud2.1, mdata$cloud2.2,  #cloud coverage for visit 1 and 2 in year 2
                  mdata$cloud3.1, mdata$cloud3.2), #cloud coverage for visit 1 and 2 in year 3
                M,
                J*T
)
date <- matrix(c(mdata$julian1.1, mdata$julian1.2,  #dates for visit 1 and 2 in year 1
                 mdata$julian2.1, mdata$julian2.2,  #dates for visit 1 and 2 in year 2
                 mdata$julian3.1, mdata$julian3.2), #dates for visit 1 and 2 in year 3
               M,
               J*T
)

#  3. Create a matrix for each of the site covariates and years of the seasons.


shrub <- matrix(c(mdata$X21), nrow(mdata), 1, byrow = TRUE)

forest <- matrix(c(mdata$X82), nrow(mdata), 1, byrow = TRUE)

thistle <- matrix(c(mdata$X23), nrow(mdata), 1, byrow = TRUE)

year <- matrix(c('1','2','3'), nrow(mdata), T, byrow = TRUE)
#  4. Create the unmarked dataframe

unmarked.multi <- unmarkedMultFrame(y = yy, 
                                    yearlySiteCovs = list(year = year),
                                    siteCovs = data.frame(shrub = shrub, 
                                                          forest = forest,
                                                          thistle = thistle),
                                    obsCovs = list(cloud = cloud,
                                                   date = date),
                                    numPrimary = T) #number of seasons

####
####  Create detection probability model
####

#  1. Keep psi (first season occupancy), gamma (colonization), epsilon (extinction rate) constant

p.null <- colext(psiformula = ~1, gammaformula = ~1, epsilonformula = ~1, pformula = ~1,
                 data = unmarked.multi, method = "BFGS")
p.date <- colext(psiformula = ~1, gammaformula = ~1, epsilonformula = ~1, pformula = ~date,
                 data = unmarked.multi, method = "BFGS")
p.cloud <- colext(psiformula = ~1, gammaformula = ~1, epsilonformula = ~1, pformula = ~cloud,
                  data = unmarked.multi, method = "BFGS")

p.year <- colext(psiformula = ~1, gammaformula = ~1, epsilonformula = ~1, pformula = ~year,
                 data = unmarked.multi, method = "BFGS")

#  2. Model selection

modlist1 <- list(
  p.null=p.null,
  p.date=p.date,
  p.cloud=p.cloud,
  p.year=p.year
)
aictab(modlist1)
#suggest no covariates here explain the detection probability

confint(p.null, type = "det") #overlapping zeros...something else may be going on..


#  3. Visualize pattern if the cloud covariate was the top model.

nd <- data.frame(("cloud"=(seq(0, 100, length.out = 100))))
colnames(nd) <- c("cloud")
pred.p <- predict(p.cloud, type = "det", newdata = nd)
print(predictions <- cbind(pred.p, nd)) #predicted detection probability given the cloud model

plot(1, xlim=c(0,1), ylim=c(0,1.0), type="n", axes=T, xlab="Cloud Coverage (%)",
     pch=20, ylab="Detection Probability", family="serif",
     cex.lab=1.25, cex.main=1.75)
lines(predictions$cloud, predictions$Predicted, col = "black", lwd = 2)
lines(predictions$cloud, predictions$lower, lty = 2, col = "black")
lines(predictions$cloud, predictions$upper, lty = 2, col = "black")

####
####  Create psi model using cloud model to explain detection for first year occupancy
####

#  1. Create the model
psi.null <- colext(psiformula= ~1, gammaformula = ~ 1, epsilonformula = ~ 1, pformula = ~ cloud, 
                   data = unmarked.multi, method="BFGS")
psi.shrub <- colext(psiformula= ~shrub, gammaformula = ~ 1, epsilonformula = ~ 1, pformula = ~ cloud, 
                    data = unmarked.multi, method="BFGS")
psi.forest <- colext(psiformula= ~forest, gammaformula = ~ 1, epsilonformula = ~ 1, pformula = ~ cloud, 
                     data = unmarked.multi, method="BFGS")
psi.thistle <- colext(psiformula= ~thistle, gammaformula = ~ 1, epsilonformula = ~ 1, pformula = ~ cloud, 
                      data = unmarked.multi, method="BFGS")
  
modlist2 <- list(
  psi.null =psi.null,
  psi.shrub=psi.shrub,
  psi.forest=psi.forest,
  psi.thistle=psi.thistle
)

aictab(modlist2)
##thistle is an important predictor for occupancy (null model is > 2.0 from suggested top model)

#  2. Visualize the data with predicted data for psi

nd2 <- data.frame(("thistle"=(seq(0, 100, length.out = 100))))
colnames(nd2)<-c("thistle")
pred.psi <- predict(psi.thistle, type='psi', newdata=nd2)
print(predictions<-cbind(pred.psi, nd2))

plot(1, xlim=c(0,100), ylim=c(0,1), type="n", axes=T, xlab="Thistle (% cover)",
     pch=20, ylab="First-year Occupancy Probability", family="serif",
     cex.lab=1.25, cex.main=1.75)

lines(predictions$thistle, predictions$Predicted, col="black", lwd=2)
lines(predictions$thistle, predictions$lower, lty=2, col="black")
lines(predictions$thistle, predictions$upper, lty=2, col="black")
#high thistle sites hosting very high occupancy 

####
####  Create colonization model
####

#pretend shrub impacts our first year occupancy and include as a covariate for the first season occupancy
#and as a covariate for gamma (colonization).

gamma.null <- colext(psiformula= ~thistle, gammaformula = ~ 1, epsilonformula = ~ 1, pformula = ~ cloud, 
                     data = unmarked.multi, method="BFGS")

gamma.thistle <- colext(psiformula= ~thistle, gammaformula = ~thistle, epsilonformula = ~ 1, pformula = ~ cloud, 
                      data = unmarked.multi, method="BFGS")

gamma.shrub <- colext(psiformula= ~thistle, gammaformula = ~shrub, epsilonformula = ~ 1, pformula = ~ cloud, 
                        data = unmarked.multi, method="BFGS")

gamma.forest <- colext(psiformula= ~thistle, gammaformula = ~forest, epsilonformula = ~ 1, pformula = ~ cloud, 
                      data = unmarked.multi, method="BFGS")
modlist3 <- list(
  gamma.null=gamma.null,
  gamma.thistle=gamma.thistle,
  gamma.shrub=gamma.shrub,
  gamma.forest =gamma.forest 
  
)
aictab(modlist3)

#####################
####  Challenges ####
#####################

#  1. Create a summary of all other models that may affect epsilon (extinction). Be sure it makes sense biologically.

