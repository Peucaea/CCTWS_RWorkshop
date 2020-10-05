#### WORKSHOP TITLE, CCTWS 2020
#### Module 1: R Basics
#### Author: Abbey Feuka


########################
# Notes:
#   1. To run code, click the line you want to run and click "Run", or CTRL + r (PC) or Command + r (mac)
#   2. Object names can include letters, numbers, '.', and '_' but must START with a letter (and are case-sensitive)
#   3. Use the 'Help' tab to look up the documentation for any function


########################
####  Demonstration #### 
########################

####
####  Objects and data types
####

# Create values with '<-' (or '=')
n <- 5
n2 <- 10

n

# Vectors (set of values in one "line")
n_vec <- c(1, 2, 3, 4, 5) 
n_vec2 <- c(1:5)

species <- c("eagle", "snake", "trout")

class(n_vec)
class(species)

n_vals <- c(n, n2)
n_chars <- c("n", "n2")
class(n_vals)
class(n_chars)

# Matrices and dataframes
# A matrix is a set of rows and columns of only one data type (typically numbers)
# A dataframe can hold all data types (e.g, numbers, characters, factors)

# cbind() and rbind() combine vectors into matrices
n_mat_c <- cbind(n_vec, n_vec2)
n_mat_c
class(n_mat)
n_mat_r <- rbind(n_vec, n_vec2)
n_mat_r

# data.frame() combines vectors into dataframes
n_df <- data.frame(n_vec, n_vec2)
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

# R is just a big calculator, but can use both objects and numbers in calculations
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

#  [i] references the ith element of an object
n_vec[1]
species[2]

# Matrices and dataframes are indexed by [rows,columns]
n_mat_c[1,2]
n_mat_c[1,]
n_mat_c[,2]

# One perk of using lebeled dataframes is calling columns using $
n_df$n_vec
class(n_df)
class(n_df$n_vec)

#####################
####  Exercises  ####
#####################

####
####   
####
# 1. Calculate your age in dog years using named objects (7 dog years per 1 human year).

# 2. Create a vector that contains numeric and character elements. What happens?

# 3. Create vectors of your top 3 favorite species and turn them into a matrix

# 4. How do you add row names to a dataframe within the data.frame() function?




