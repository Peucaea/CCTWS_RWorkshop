#### WORKSHOP TITLE, CCTWS 2020
#### Module #: TITLE
#### Author:


########################
# Notes:
#   1.
#   2. 
#   3.


########################
####  Demonstration #### 
########################

####
####  Basic Scatterplotting and Polygons 
####

# Any wider description about code chunk...
set.seed(1001)
n=100
S=matrix(runif(2*n),n,2) # sample points randomly in unit square
lambda=5
y=rpois(n,lambda) # simulated count data

plot(S,pch=16,col=1,asp=TRUE,xlab="easting",ylab="northing") # basic points plot
symbols(.5,.5,squares=1,add=TRUE,inches=FALSE)

y.sc=0.25*(y-min(y))+.5  # 0.25 scales size down and 0.5 sets min size 
plot(S,pch=16,cex=y.sc,col=rgb(0,0,0,.25),asp=TRUE,xlab="easting",ylab="northing") # variable size points plot
symbols(.5,.5,squares=1,add=TRUE,inches=FALSE)

y.sc=0.25*(y-min(y))+.5  # 0.25 scales size down and 0.5 sets min size 
plot(S,pch=16,cex=y.sc,col=rgb(0,0,0,.25),asp=TRUE,xlab="easting",ylab="northing",xlim=c(min(S[,1]),max(S[,1])+.3),bty="n") # variable size points plot w/ legend
symbols(.5,.5,squares=1,add=TRUE,inches=FALSE)
legend("right",pch=16,pt.cex=c(min(y.sc),median(y.sc),max(y.sc)),legend=c(min(y),median(y),max(y)),col=rgb(0,0,0,.25),title="y")

a=.1
b=1
y.sc=a+(y-min(y))/diff(range(y))*(b-a) # scale values to between a and b 
plot(S,pch=16,cex=1.5,col=rgb(0,0,0,y.sc),asp=TRUE,xlab="easting",ylab="northing",xlim=c(min(S[,1]),max(S[,1])+.3),bty="n") # points plot w/ transparency 
symbols(.5,.5,squares=1,add=TRUE,inches=FALSE)
legend("right",pch=16,pt.cex=1.5,legend=c(min(y),median(y),max(y)),col=rgb(0,0,0,c(min(y.sc),median(y.sc),max(y.sc))),title="y")

library(viridis)
vir.col=viridis(100)
a=0.01
b=1
y.sc=a+(y-min(y))/diff(range(y))*(b-a) # scale values to between a and b 
y.col=vir.col[round(y.sc*100)]
plot(S,pch=16,cex=1.5,col=y.col,asp=TRUE,xlab="easting",ylab="northing",xlim=c(min(S[,1]),max(S[,1])+.3),bty="n") # points plot w/ color 
symbols(.5,.5,squares=1,add=TRUE,inches=FALSE)
legend("right",pch=16,pt.cex=1.5,legend=c(min(y),median(y),max(y)),col=vir.col[100*c(min(y.sc),median(y.sc),max(y.sc))],title="y")

####
####  Basic Interacting with Plots 
####

set.seed(1001)
n=100
S=matrix(runif(2*n),n,2) # sample points randomly in unit square
lambda=5
y=rpois(n,lambda) # simulated count data

plot(S,pch=16,col=1,asp=TRUE,xlab="easting",ylab="northing") # basic points plot
symbols(.5,.5,squares=1,add=TRUE,inches=FALSE)

locator(1) # then click in plotting region of graphic; tells you point that was clicked

locs=locator(2) # then click in plotting region of graphic twice; stores points that were clicked in 'locs'
locs

locator(3,type="l",lty=1,lwd=2,col=rgb(1,0,0,.5)) # then click on graphic in 3 places; draws line with nodes at clicks

####
####  Basic Maps 
####

library(maps) #wgs84 is default

quartz() #options for pulling plot out of studio
map("world")  # simple world map

map("state")  # simple continental U.S. map in lat/long 

set.seed(1001)
dev.new()
map("state","Colorado")  # simple Colorado map in lat/long 
points(cbind(rnorm(50,-105,.2),rnorm(50,39,.2)),pch=16,col=rgb(0,0,0,.5)) # add random points to map
dev.off()

data(us.cities)  # load cities data from maps package
us.cities  # look at data set

quartz()
CO.cities=us.cities[c(322,247,360,728,192),] # pick out a few cities
CO.cities$name=c("Fort Collins","Denver","Grand Junction","Pueblo","Colorado Springs")
map("state","Colorado",xlim=c(-110,-101),ylim=c(36.5,41.5))  # map with a few cities
map("state",add=TRUE)  # adds surrounding state boundaries in plotting region
map.axes()
map.cities(CO.cities, country="CO",pch=17,cex=1.5,label=TRUE)
map.cities(CO.cities, country="CO",pch=17,cex=1.5,label=TRUE,capitals=2)

#####################
####  Exercises  ####
#####################

####
####  Basic Grids of Points 
####

set.seed(1002)
n.1=10
n.2=20
n=n.1*n.2

s.1=seq(0,1,,n.1)
s.2=seq(0,2,,n.2)
S=as.matrix(expand.grid(s.2,s.1)) # easting,northing
y=S[,1]*S[,2]

library(viridis)
vir.col=viridis(100)
a=0.01
b=1
y.sc=a+(y-min(y))/diff(range(y))*(b-a) # scale values to between a and b 
y.col=vir.col[round(y.sc*100)]

layout(matrix(1:2,2,1))
plot(S,pch=16,cex=1.5,col=y.col,asp=TRUE,xlab="easting",ylab="northing")  # round points
plot(S,pch=15,cex=3,col=y.col,asp=TRUE,xlab="easting",ylab="northing")  # square points (could approximate image)

####
####  Basic Images 
####

matrix(1:12,3,4)  # Note arrangement of numbers in matrix
layout(matrix(1:2,1,2))
image(matrix(1:12,3,4),col=vir.col)  # Plot is rotated left version of matrix 
image(t(matrix(1:12,3,4))[,3:1],col=vir.col)  # Transpose and reverse order of rows matches matrix 

y.mat=matrix(y,n.2,n.1) 
image(x=s.2,y=s.1,z=y.mat,col=vir.col,xlab="easting",ylab="northing",asp=TRUE)  # image with coordinates

filled.contour(x=s.2,y=s.1,z=y.mat,color.pal=viridis,xlab="easting",ylab="northing",asp=TRUE)  # smoothed image with coordinates and scale bar

set.seed(1003)
n.locs=20
locs=cbind(rnorm(n.locs,1,.1),rnorm(n.locs,.5,.1))  # Simulate 20 points 
filled.contour(x=s.2,y=s.1,z=y.mat,color.pal=viridis,xlab="easting",ylab="northing",asp=TRUE,plot.axes={points(locs,pch=16,cex=2,col=rgb(1,0,0,.7));axis(1);axis(2)})  # add points to filled.contour

contour(x=s.2,y=s.1,z=y.mat,xlab="easting",ylab="northing",asp=TRUE)  # contour plot only

####
####  Basic Movies 
####

library(maps)
library(animation)

dev.off() # reset graphics device
us_states=map("state",col=rainbow(6),fill=TRUE,plot=TRUE)  # map of U.S. 
title("U.S. States")

us_states$Y2015=rnorm(63,200,10)  # simulate state-level data for 4 hypothetical years (2015-18)
us_states$Y2016=rnorm(63,300,10)
us_states$Y2017=rnorm(63,400,10)
us_states$Y2018=rnorm(63,500,10)

saveHTML(  # Make interactive animation using html 
  for(i in 5:8){
    map_temp=map(us_states,col=us_states[[i]],fill=TRUE) 
    title(paste(201,i,sep=""))
  }
,img.name="MyHTML",htmlfile="state_movie.html")

saveGIF(  # save movie as GIF 
 for(i in 5:8){
    map_temp <- map(us_states,col=us_states[[i]],fill=TRUE) 
    title(paste(201,i,sep=""))
}, 
movie.name="state_movie.gif",img.name="myGif")

#####################
####  Challenges ####
#####################


# 1.)  Make an image representing distance from Fort Collins and overlay a map of the continental U.S.   

# 2.)  Use the R function 'identify' to determine the location of the central most point in this graphic: 

set.seed(1001)
locs=cbind(rnorm(10,-105,.2),rnorm(10,39,.2))
map("state","Colorado")  
points(locs,pch=16,col=rgb(0,0,0,.5))

# 3.)  Use the R function 'persp' to make a 3-D plot of the surface shown in this graphic:  

set.seed(1002)
n.1=20
n.2=20
n=n.1*n.2

s.1=seq(0,1,,n.1)
s.2=seq(0,1,,n.2)
S=as.matrix(expand.grid(s.2,s.1)) # easting,northing
y=S[,1]*S[,2]
y.mat=matrix(y,n.2,n.1)
image(x=s.2,y=s.1,z=y.mat,col=vir.col,xlab="easting",ylab="northing",asp=TRUE)  
 

