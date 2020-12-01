#### WORKSHOP TITLE, CCTWS 2020
#### Module 1: R Basics
#### Author: Abbey Feuka

########################
# Notes:
#   1. To run code, click the line you want to run and click "Run", or CTRL + r (PC) or Command + r (mac)
#   2. Object names can include letters, numbers, '.', and '_' but must START with a letter 
#   2.a. Object names are case-sensitive!
#   3. Use the 'Help' tab to look up the documentation for any function
#   4. Starting a line of code with # creates a comment, or non-run-able code.

########################
####  R Studio Tour #### 
########################

# What am I looking at?
# Four panels
# - Writing/editing scripts
# - - New script/Save
# - Environment/History
# - - See the objects you're working with
# - Console
# - - Code output
# - Files/Plots/Packages/Help/Viewer
# - - Open new files, view plots, manage packages, get help

########################
####  Demonstration #### 
########################

####
####  Objects and data types
####

# Create objects with '<-'
n <- 5
n2 <- 10

n

# Vectors (set of values in one "line")
n_vec <- c(1, 2, 3, 4, 5) 
n_vec
n_vec2 <- c(1:5)
n_vec2

species <- c("eagle", "snake", "trout", "turtle", "squid")
species

# # class() allows you to determine what type of object something is
# # This is helpful for troubleshooting errors
class(n_vec)
class(species)

n_vals <- c(n, n2)
n_chars <- c("n", "n2")
class(n_vals)
class(n_chars)

# Matrices and dataframes
# # A matrix is a set of rows and columns of only one data type (typically numbers)
# # A dataframe can hold all data types (e.g, numbers, characters, factors)

# cbind(), rbind(), and data.frame() combine vectors into matrices
n_mat_c <- cbind(n_vec, n_vec2)
n_mat_c
class(n_mat_c)

n_mat_r <- rbind(n_vec, n_vec2)
n_mat_r
class(n_mat_r)

n_df <- data.frame(n_vec, species)
n_df
class(n_df)

# data.frame() is especially flexible, check out the documentation
?data.frame() 

# rep() and seq() create patterned numeric vectors quickly
rep(n,10)
rep(species,3)

seq(from=3, to=7, by=0.5)

####
####  Basic operations
####

# R is just a big calculator, it can use objects and numbers in calculations
N <- n + n2
N 

# The following adds/multiplies the scalar with each element of the vector
n + n_vec
n*n_vec
n_vec/2

# Make your first error!
species/2

####
####  Referencing elements / indexing
####

# [i] references the ith element of an object
n_vec[1]
species[2]

# Matrices and dataframes are indexed by [rows, columns]
n_df[1,2]
n_df[1,]
n_df[,2]

# One perk of using labeled dataframes is calling columns using $
n_df$species

# Let's go 3D: arrays (stack of matrices/datframes)
# # Start by making three matrices to stack
m1 <- matrix(data=rep(1,4),nrow=2,ncol=2)
m2 <- matrix(data=rep(2,4),nrow=2,ncol=2)
m3 <- matrix(data=rep(3,4),nrow=2,ncol=2)
# # Then combine them into an array
a <- array(data=c(m1,m2,m3),dim=c(2,2,3))

a
# # one "sheet" of the array
a[,,1] 
# # first column across all sheets
a[,1,]
# # first row across all sheets
a[1,,]

#####################
####  Exercises  ####
#####################

####
####   
####
# 1. Calculate your age in dog years using a named object for your age (7 dog years per 1 human year).
age <- xxx

# 2. Create a vector that contains numeric and character elements. What happens?

# 3. Create vectors of 3 birds, 3 mammals, and 3 fish, and turn them into a matrix

# 4. How do you add row names to a dataframe within the data.frame() function?




