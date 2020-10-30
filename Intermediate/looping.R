#### WORKSHOP TITLE, CCTWS 2020
#### Module #: Speeding things up with looping
#### Author: Abbey Feuka


########################
# Notes:
#   1. Rule of thumb: if you repeat the same function/line of code >3 times, consider using a looping function
#   2. 
#   3.


########################
####  Demonstration #### 
########################

###
### For loops
###

# Repeat the same line of code as many times as you specify
for(i in 1:10){
  print(i) # print() just prints what's inside in the console
}

# vector <- numeric(LENGTH OF SEQUENCE)
# for(INDEX in SEQUENCE){ #start loop
#   vector[INDEX] <- FUNCTION USING INDEX
# } #end loop

# This is usful when you want to automatatically update a vector
v <- numeric(10) # create a vector of 10 0's
v
for(i in 1:10){
  v[i] <- i
}
v

# for loops are usful for iterative operations
running.mean <- numeric(0)
for(i in 1:10){
  running.mean[i] <- mean(1:i)
}
running.mean

# Loops are useful for random walks!
xy <- matrix(data=0,nrow=10,ncol=2) #columns = coordinates
for(t in 2:10){
  xy[t,] <- rnorm(n=2,mean=xy[t-1,],sd=0.5)
}

plot(xy[,1],xy[,2])
lines(xy[,1],xy[,2])

###
### Apply functions
###

# Similar to for loops, but condensed code and a bit less flexible

# apply() is used for matrices
# apply(OBJECT, MARGIN (1=row, 2=colum), FUNCTION)
mat <- matrix(data=c(rep(1,4),rep(2,4),rep(3,4)),nrow=4,ncol=3)
apply(mat, 1, sum)
apply(mat, 2, prod)

# sapply() can be used for matrices, vectors, or arrays
vec <- 1:10
sapply(vec, function(x){x+1})

#####################
####  Exercises ####
#####################

# 1.) Fix the following code so that it runs:
y <- numeric(0)
for(1:10){
  y[i] <- mean(1:i)
}

# 2.) Sum each the column in the following matrix:
prac <- matrix(rnorm(20,10,4),4,5)

# 3.) Create a vector where each value is the previous value squared, starting with 2.


