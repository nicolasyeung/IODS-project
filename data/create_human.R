#reading the data
library(readr)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#exploring the data
str(hd)
str(gii)

summary(hd)
summary(gii)

#changing column names to agreed abbreviations
names(hd) <- c("HDI.Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus.Rank")
names(gii) <- c("GII.Rank", "Country", "GII", "Mat.Mor", 
               "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", 
               "Labo.F", "Labo.M")

#adding the new combined variables
gii <- mutate(gii, Edu2.FM = Edu2.F / Edu2.M, Labo.FM = Labo.F / Labo.M)

#joining the two data sets by country
human <- inner_join(hd, gii, by = "Country")

#writing a csv file
setwd("C:/Users/nicol/Downloads/PHD_302/IODS-project/data/")
write.csv(human, "human.csv")
