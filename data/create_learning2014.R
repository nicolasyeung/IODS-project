#Nicolas Yeung, Novemeber 6th 2023, beginning of assignment 2 Regression and Model Validation

library(tidyverse)
library(dplyr)

#loading data
learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#exploring dataframe structure
dim(learning2014)

str(learning2014)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
deep_columns <- select(learning2014, one_of(deep_questions))
# and create column 'deep' by averaging
learning2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning 
surface_columns <- select(learning2014, one_of(surface_questions))
# and create column 'surf' by averaging
learning2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning 
strategic_columns <- select(learning2014, one_of(strategic_questions))
# and create column 'stra' by averaging
learning2014$stra <- rowMeans(strategic_columns)


#creating new analysis_dataset
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
analysis_dataset <-  learning2014[, c("gender","Age","attitude", "deep", "stra", "surf", "Points")]

#filtering away the Points that were zero
trimmed_analysis_dataset <- filter(analysis_dataset, Points > 0)

#getting the path to the IODS folder
getwd()
#using the path to set the working directory
setwd("C:/Users/nicol/Downloads/PHD_302/IODS-project")

#writing a csv file to my project folder
write.csv(trimmed_analysis_dataset, "learning2014.csv")

