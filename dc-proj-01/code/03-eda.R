# potential project questions

library(tidyverse)
library(lubridate)

ba_data <- read_csv("data/duis_combined_2013-17.csv")
ba_data %>% 
  filter(!is.na(Res1), !is.na(Res2)) %>%  # remove ones where both results are NA 
  select(-Officer) %>% # remove officer name since it will be going wide audience
  filter(Location %in% c("ISU PD", "Ames PD")) -> isu_bas
isu_bas %>% 
  mutate(year = year(Date), month = month(Date), 
         day = day(Date), hour = hour(Time)) %>% 
  select(year, month, day, hour, location = Location, gender = Gender, Res1, Res2, id = InstrumentID) -> isu_bas

write_csv(isu_bas, "data/breath_alcohol_ames.csv")



## Note: these are "Breath Alcohol Tests" not necessarily DUIs

# 1 Highest average recorded by ISU PD? 

isu_bas %>% 
  filter(location == "ISU PD") %>% 
  mutate(meanRes = (Res1 + Res2)/2) %>% 
  arrange(desc(meanRes))

# 2 scatterplot of Res1 v Res 2, colored by gender, facet location. Check for outliers, inconsistencies

ggplot(data = isu_bas) + 
  geom_point(aes(x = Res1, y = Res2, color = gender)) + 
  facet_wrap(~location)

# 3a total number of dui readings by year 

duis %>% group_by(year = year(Date)) %>% count()

# 3b total number of dui readings by month, year 

duis %>% group_by(month = month(Date), year = year(Date)) %>% count() %>% ungroup() -> monthTotal

ggplot(data = monthTotal, aes(x = month, y = n, color = as.factor(year)))  + 
  geom_point() + 
  geom_line() + 
  scale_x_continuous(breaks = 1:12, labels = 1:12)

## Third task. 

isu_bas %>% group_by(gender) %>% count()

isu_bas %>% filter(!is.na(gender)) %>% mutate(meanRes = (Res1+Res2)/2) %>% 
ggplot(aes(x = gender, y = meanRes)) + 
  geom_boxplot(fill = NA)

## https://www.desmoinesregister.com/story/news/2015/08/04/uber-launch-ames-iowa/31110437/

isu_bas %>% filter(location %in% c("Ames PD", "ISU PD")) %>% group_by(year, month) %>% count %>% ungroup() -> monthly_duis
monthly_duis %>% mutate(mdt = ymd(paste(year, month, "01", sep = "-"))) -> monthly_duis
ggplot(data = monthly_duis, aes(x = mdt, y = n)) + 
  geom_line() +
  geom_vline(xintercept = ymd("2015-08-04"), color = 'forestgreen') + 
  geom_vline(xintercept = ymd("2014-04-08"), color = "red") + 
  geom_smooth() + 
  scale_x_date(breaks = ) + 
  labs(x = "Date", y = "Number of Breath Alcohol Tests (by month)", 
       title = "Breath Alcohol Tests by ISU and Ames Police, 2013-2017", 
       subtitle = "red line = Veisha riot 2014, green line = Uber arrives in Ames")
  
duis %>% filter(Location %in% c("Ames PD", "ISU PD")) %>% group_by(Date) %>% count() %>% ungroup() -> daily_duis
ggplot(data = daily_duis, aes(x = Date, y = n)) + 
  geom_line() + 
  facet_wrap(~year(Date), scales="free_x")

duis %>% filter(Location %in% c("Ames PD", "ISU PD")) %>% group_by(wk = week(Date), yr =year(Date)) %>% count() %>% ungroup() -> weekly_duis
ggplot(data = weekly_duis, aes(x = as.numeric(paste(yr,wk, sep = ".")), y = n)) + 
  geom_line() 
  #geom_vline(xintercept = ymd("2015-08-04"), color = 'forestgreen') + 
  #geom_vline(xintercept = ymd("2014-04-08"), color = "red") + 
  #facet_wrap(~yr)

duis %>% filter(Location %in% c("Ames PD", "ISU PD")) %>% group_by(hr=hour(Time), yr = year(Date)) %>% count() %>% ungroup() -> hourly_duis
ggplot(data = hourly_duis, aes(x = hr, weight = n)) + 
  geom_bar() + 
  facet_wrap(~yr)
