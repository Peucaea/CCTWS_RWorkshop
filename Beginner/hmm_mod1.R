#### WORKSHOP TITLE, CCTWS 2020
#### Module 2: Importing data to R 
#### Author: Hanna McCaslin


########################
# Notes:
#   1. Working directories!
#   2. 
#   3.


########################
####  Demonstration #### 
########################
library(palmerpenguins)
data("penguins")

####
####  Reading in data  
####
penguins <- read.csv("penguins.csv", header = TRUE)

# add txt example read.table("example.txt")
# add excel example
library(readxl) 

####
####  Data details  - talk abotu why cleaning in R is useful (reproducability)
####

# Structure 
str(penguins)
     # data frame
nrow(penguins)
ncol(penguins)

# Viewing data
penguins
head(penguins)
head(penguins, 10)
tail(penguins)
View(penguins)

# View specific parts of data
penguins[8,] # rows
# vs
penguins[,8] # columns
penguins$sex 

str(penguins$sex)
penguins$sex <- as.factor(penguins$sex)
str(penguins$sex)
penguins$sex[1:10] # what am i accessing here?

str(penguins$bill_length_mm)

summary(penguins)

####
####  Subsetting data 
####

# Subset by column
# '=' vs '=='
adelie_penguins <- subset(penguins, species == "adelie") # wrong, why?
adelie_penguins <- subset(penguins, species == "Adelie")

penguins_early <- subset(penguins, year < 2009)

# Subset by row 
penguins <- penguins[1:10,]

####
####  Write out data  
####
write.csv(adelie_penguins, "adelie_penguins.csv")


#####################
####  Exercises  ####
#####################

####
####   
####
# 1. Load the dataset 'penguins_raw' into R and look at the structure of the variables
          # Int vs num vs chr vs fact

####
####  Basic Images 
####


####
####  Basic Movies 
####


