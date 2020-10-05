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
for(i in 1:10){
  v[i] <- i
}
v

running.mean <- numeric(0)
for(i in 1:10){
  running.mean[i] <- mean(1:i)
}
running.mean

###
### Apply functions
###

# Similar to for loops, but condensed code for matrices

# apply(OBJECT, MARGIN (1=row, 2=colum), FUNCTION)
mat <- matrix(data=c(rep(1,4),rep(2,4),rep(3,4)),nrow=4,ncol=3)
apply(mat, 1, sum)
apply(mat, 2, prod)

vec <- 1:10
sapply(vec, function(x){x+1})

#####################
####  Exercises ####
#####################

# 1.)  

# 2.) 

# 3.) 
