# Nicolas Yeung, 20231116.  This is my r script to wrangle the data for Assignment 3 on Logistic Regression, Data source was: http://www.archive.ics.uci.edu/dataset/320/student+performance

#setting up the environment
library(dplyr)
library(tidyverse)
library(ggplot2)

#reading in the two files
math <- read.csv("C:/Users/nicol/Downloads/PHD_302/IODS-project/data/Assignement3_Logistic_Regression/student-mat.csv", sep=";", header=TRUE)
por <- read.csv("C:/Users/nicol/Downloads/PHD_302/IODS-project/data/Assignement3_Logistic_Regression/student-por.csv", sep=";", header=TRUE)

#Looking at the dataframes
summary(math)
summary(por)
colnames(math)
colnames(por)

#getting rid of the unneeded columns by creating a list and subtracting it from the columns
free_cols <- c("failures","paid","absences","G1","G2","G3")
join_cols <- setdiff(colnames(por), free_cols)

#joing the tables using inner_join
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

#checking the column names are the same
colnames(math_por)

#creating a new df that only has the columns I am interested in
alc <- select(math_por, all_of(join_cols))

#double checking the columns are what I want after removal
colnames(alc)

#from section exercise section 3.3 for getting rid of duplicate data
for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  if(is.numeric(first_col)) {
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    alc[col_name] <- first_col
  }
}

glimpse(alc)


# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

colnames(alc)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

write.csv(alc, "C:/Users/nicol/Downloads/PHD_302/IODS-project/data/Assignement3_Logistic_Regression/")


