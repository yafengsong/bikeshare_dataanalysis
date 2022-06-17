# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# lubridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #  

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
getwd() #displays your working directory
setwd("/Users/songyafeng/Programming/Google_BA/CASE_1/Trip_Data") #sets your working directory to simplify calls to data ... make sure to use your OWN username instead of mine ;)

#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload Divvy datasets (csv files) 
aggregated_202105_202204 <- read_csv("aggregated_clean.csv")

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Transform 'start_at' and 'end_at' from chr to datetime datatype.
aggregated_202105_202204 <- mutate(aggregated_202105_202204, 
                                   started_at = as_datetime(started_at),
                                   ended_at = as_datetime(ended_at))

#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(aggregated_202105_202204)  #List of column names
nrow(aggregated_202105_202204)  #How many rows are in data frame?
dim(aggregated_202105_202204)  #Dimensions of the data frame?
head(aggregated_202105_202204)  #See the first 6 rows of data frame.  Also tail(all_trips)
str(aggregated_202105_202204)  #See list of columns and data types (numeric, character, etc)
summary(aggregated_202105_202204)  #Statistical summary of data. Mainly for numerics
unique(aggregated_202105_202204$rideable_type) # Check unique values
unique(aggregated_202105_202204$member_casual)
unique(aggregated_202105_202204$day_of_week)

#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Compare members and casual users
# aggregate(aggregated_202105_202204$ride_length ~ aggregated_202105_202204$member_casual, FUN = mean)
# aggregate(aggregated_202105_202204$ride_length ~ aggregated_202105_202204$member_casual, FUN = median)
# aggregate(aggregated_202105_202204$ride_length ~ aggregated_202105_202204$member_casual, FUN = max)
# aggregate(aggregated_202105_202204$ride_length ~ aggregated_202105_202204$member_casual, FUN = min)

aggregated_202105_202204 %>% 
  group_by(member_casual) %>% 
  summarise(mean_ride = mean(ride_length),
            median_ride = median(ride_length),
            max_ride = max(ride_length),
            min_ride = min(ride_length))


# Change day of week to its real meaning
aggregated_202105_202204$day_of_week[aggregated_202105_202204$day_of_week == 1] <- 'Sunday'
aggregated_202105_202204$day_of_week[aggregated_202105_202204$day_of_week == 2] <- 'Monday'
aggregated_202105_202204$day_of_week[aggregated_202105_202204$day_of_week == 3] <- 'Tuesday'
aggregated_202105_202204$day_of_week[aggregated_202105_202204$day_of_week == 4] <- 'Wednesday'
aggregated_202105_202204$day_of_week[aggregated_202105_202204$day_of_week == 5] <- 'Thursday'
aggregated_202105_202204$day_of_week[aggregated_202105_202204$day_of_week == 6] <- 'Friday'
aggregated_202105_202204$day_of_week[aggregated_202105_202204$day_of_week == 7] <- 'Saturday'

# Create order to the day of week
aggregated_202105_202204$day_of_week <- factor(aggregated_202105_202204$day_of_week, ordered = TRUE, 
                                               levels = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# See the average ride time by each day for members vs casual users
aggregated_202105_202204 %>% 
  group_by(day_of_week, member_casual) %>% 
  summarise(mean_ride = mean(ride_length))

# aggregate(aggregated_202105_202204$ride_length ~ aggregated_202105_202204$member_casual + aggregated_202105_202204$day_of_week, FUN = mean)


# analyze ridership data by type and weekday
ridership <- aggregated_202105_202204 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%      #creates weekday field using wday()
  group_by(member_casual, weekday) %>%                      #groups by usertype and weekday
  summarise(number_of_rides = n()							              #calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		  # calculates the average duration
  arrange(member_casual, weekday) 								          # sorts

# Visualize the number of rides by rider type
ggplot(ridership, aes(x = weekday, y = number_of_rides, fill = member_casual)) + geom_col(position = "dodge")
                                                         

# Visualize the average ride length by rider type
ggplot(ridership, aes(x = weekday, y = average_duration, fill = member_casual)) + geom_col(position = "dodge")

#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation software
counts <- aggregate(aggregated_202105_202204$ride_length ~ 
                      aggregated_202105_202204$member_casual + 
                      aggregated_202105_202204$day_of_week, FUN = mean)
write.csv(ridership, file = '/Users/songyafeng/Programming/Google_BA/CASE_1/ridership.csv')
