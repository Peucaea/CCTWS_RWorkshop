##############################
####  Challenges Answers  ####
####      Module 3        ####
##############################

#  1. Create a summary of other models that may affect detection probabilities for the wood frog.

unmarked.data <- unmarkedFrameOccu(
  y = frog[,c('v1', 'v2', 'v3')], #detection history for each visit at each site
  siteCovs = frog[, c('X21', 'X82')], #Site covariates - they do not change across each visit
  obsCovs = list(cloud = frog[,c('cloud1', 'cloud2', 'cloud3')], #observation covariates change, need to tell where they are and rename
                 date = frog[,c('julian1', 'julian2', 'julian3')],
                 temp = frog[,c('temp1', 'temp2', 'temp3')]))


p.null <- occu(~1~1, data = unmarked.data) #occu(p, psi, data), 1 = constant
p.cloud <- occu(~cloud~1, data = unmarked.data)
p.cloud.date <- occu(~cloud+date ~1, data = unmarked.data)
p.cloud.temp <- occu(~cloud+temp ~1, data = unmarked.data)
p.cloud.date.temp <- occu(~cloud+date+temp~1, data = unmarked.data)
p.date.temp <- occu(~date+temp~1, data = unmarked.data)
p.date <- occu(~date~1, data = unmarked.data)
p.temp <- occu(~temp~1, data = unmarked.data)

modlist1 <- list(
  p.null = p.null, p.cloud = p.cloud,
  p.date = p.date, p.temp = p.temp, 
  p.cloud.date = p.cloud.date, p.cloud.temp = p.cloud.temp,
  p.cloud.date.temp = p.cloud.date.temp, p.date.temp = p.date.temp)

aictab(modlist1) #date best predicts detection probability data

#  2. Using the top model, predict what the detection probaiblity would be on julian date of 100, 200, and 300.

summary(p.date)
newdate <- data.frame(date = c(100,200,300)) 
predict(p.date, type = "det", newdata = newdate)


#  3. Create a summary of other models that may affect occupancy for the wood frog including the null and top detection probability covariate(s).

psi.null <- occu(~1~1, data = unmarked.data)
p.date.psi.null <- occu(~date~1, data = unmarked.data)
p.date.psi.shrub <- occu(~date~X21, data = unmarked.data)
p.date.psi.forest <- occu(~date~X82, data = unmarked.data)  
p.date.psi.shrub.forest <- occu(~date~X21+X82, data = unmarked.data)
p.null.psi.shrub.forest <- occu(~1~X21+X82, data = unmarked.data)  
  
modlist2 <- list(
  psi.null=psi.null,
  p.date.psi.null=p.date.psi.null,
  p.date.psi.shrub=p.date.psi.shrub,
  p.date.psi.forest=p.date.psi.forest,
  p.date.psi.shrub.forest=p.date.psi.shrub.forest,
  p.null.psi.shrub.forest =p.null.psi.shrub.forest)

aictab(modlist2)  

