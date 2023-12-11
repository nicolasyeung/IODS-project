#reading in data

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", head = T)

str(BPRS)

summary(BPRS)

#here I have 40 subjects in two groups, scores by BPRS, across 8 weeks.

library(dplyr)
library(tidyr)
library(ggplot2)


# Factor treatment & subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

str(BPRS)

# Convert to long form
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks) #order by weeks variable

# Extract the week number
BPRSL <-  BPRSL %>% 
  mutate(week = as.integer(substr(weeks, 5,5))) %>% select(!one_of("weeks"))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# I now have the data pivoted, the weeks separated as 9 invidiual variables are collapsed into one variable called week
# we also eliminated the text so only an integer is present as a week variable
# 9 weeks time 40 subjects is 360 observations

ggplot(BPRSL, aes(x = week, y = bprs, linetype = subject)) +
  geom_line() +
  scale_linetype_manual(values = rep(1:10, times=4)) +
  facet_grid(. ~ treatment, labeller = label_both) +
  scale_y_continuous(name = "bprs")

#trying to standardize the bprs variable, graph was a bit difficult to read

BPRSL <- BPRSL %>%
  group_by(week) %>%
  mutate( stdbprs = (bprs - mean(bprs))/sd(bprs) ) %>%
  ungroup()

ggplot(BPRSL, aes(x = week, y = stdbprs, linetype = subject)) +
  geom_line() +
  scale_linetype_manual(values = rep(1:10, times=4)) +
  facet_grid(. ~ treatment, labeller = label_both) +
  scale_y_continuous(name = "standardized bprs")

#didn't really help

#printing data
getwd()
setwd("C:/Users/nicol/Downloads/PHD_302/IODS-project")
write_csv(BPRSL, file="bprsl.csv")
write_csv(BPRS, file="bprs.csv")

##############

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", head = T)

glimpse(RATS)

#we have 16 rats, in 3 groups of feeding, with weights measured across 11 timepoints, with each timepoint being a variable.
#The goal now is to collapse the timepoints


RATS$ID<- as.factor(RATS$ID)
RATS$Group<- as.factor(RATS$Group)

#check that ID and Group are now Factor datatype
str(RATS)


# Convert data to long form
RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD, 3,4))) %>%
  arrange(Time)

glimpse(RATSL)

#Let's plot the data
ggplot(RATSL, aes(x = Time, y = Weight, linetype = ID)) +
  geom_line() +
  scale_linetype_manual(values = rep(1:10, times=4)) +
  facet_grid(. ~ Group, labeller = label_both) +
  theme(legend.position = "none") + 
  scale_y_continuous(limits = c(min(RATSL$Weight), max(RATSL$Weight)))

#data is now in its long form with the Time variable only having the integer from the WD variable
# 11 timepoints x 16 rats ) 176 observations

getwd()
setwd("C:/Users/nicol/Downloads/PHD_302/IODS-project")
write_csv(RATSL, file="ratsl.csv")
write_csv(RATS, file="rats.csv")

