# Project Idea 2: based on Charlotte Wickham's Dates & Times course

# Task 1: 

# Read data, Create column for wday and make a bar chart
# load packages 
library(tidyverse)
library(lubridate)

# read the data into your workspace
ba_dates <- read_csv("data/breath_alcohol_datetimes.csv")

# group data by year and obtain counts for each year 
ba_dates <- ba_dates %>% mutate(wday = wday(DateTime, label = T))

# bar chart by day of week

ggplot(data = ba_dates) + 
  geom_bar(aes(x = wday))



# Task 2: 
  # hour of day, weekend data, facet by day and bar chart of hour 

# create hour variable
ba_dates <- ba_dates %>% 
  mutate(hour = hour(DateTime))

# create weekend data
weekend <- ba_dates %>% filter(wday %in% c("Fri", "Sat", "Sun"))


# plot side-by side bar charts of the distribution of hour of the day of tests in each weekend day. 
ggplot(data = weekend ) + 
  geom_bar(aes(x = hour)) + 
  facet_grid(.~wday) + 
  scale_x_continuous(breaks = 0:23)




# Task 3: 

# create a rounded date, then group by and make a time series plot 

ba_dates <- ba_dates %>% 
  mutate(date = round_date(DateTime, unit = "day"))

ba_dates %>% count(date) %>% 
  ggplot() + 
  geom_line(aes(x = as.Date(date), y = n)) + 
  scale_x_date(date_breaks = "6 months")
str(ba_dates)

# hour of the day with ggridges + result 
library(ggridges)
ggplot(data = ba_dates, aes(x = Res1, y = hour, group = hour)) + 
  geom_density_ridges(stat = "binline", bins =40, scale = 0.95, fill = "steelblue") + 
  #geom_density_ridges(alpha = 0.7, fill = "steelblue") + 
  scale_y_continuous(breaks = 0:23)

ggplot(ba_dates, aes(x=Res1, y=hour, height = Res1, group = hour)) + 
  geom_density_ridges(stat = "identity", scale = 1)


# Time series: group by day & count. Then make time series plot grouped by year

alcohol_ts <- alcohol %>% 
  count(year, date)

ggplot(data = alcohol_ts, aes(x = date, y = n, group = year)) + 
  geom_line(stat = "bin") + 
  scale_x_datetime(date_breaks = "4 months")

# Task 4: 

# Hour of day & ggridges 
library(ggridges)

ggplot(data = alcohol, aes(x = Res1, y = hour, group = hour)) + 
  geom_density_ridges(alpha = 0.75, fill = "steelblue") + 
  scale_y_continuous(breaks = 0:23)

# why error???? needed group = hour as well. 

#------------ SCRATCH WORK ----------------#
# Task 9: Example with tsibble

library(tsibble)

ts_alcohol <- alcohol %>%
  mutate(row_id = row_number()) %>% 
  as_tsibble(
    index = DateTime,
    key = id(row_id),
    regular = FALSE
  )

ts_alcohol %>% 
  group_by()

# # Create columns for year, month (labeled), day (labeled), round hour of day
# library(lubridate)
# alcohol <- alcohol %>% 
#   mutate(year = year(DateTime), 
#          month = month(DateTime, label = T), 
#          day = wday(DateTime, label=T), 
#          hour = hour(round_date(DateTime, unit="hour")),
#          date = round_date(DateTime, unit="day"))



