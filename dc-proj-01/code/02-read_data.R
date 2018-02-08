# scraping failed. copy-paste from website by hand all of story county for 5 years (2013-17)

library(tidyverse)
library(readxl)
library(purrr)
library(lubridate)

years <- excel_sheets("data/duidatastorycounty.xlsx")
years

duis <- tibble(year = years)

test <- read_excel("data/duidatastorycounty.xlsx", sheet = years[1])
test2 <- read_csv("data/duidatastorycounty2017.csv")
head(test2)

dui2017 <- read_csv("data/duidatastorycounty2017.csv")
dui2016 <- read_csv("data/duidatastorycounty2016.csv")
dui2015 <- read_csv("data/duidatastorycounty2015.csv")
dui2014 <- read_csv("data/duidatastorycounty2014.csv")
dui2013 <- read_csv("data/duidatastorycounty2013.csv")

duis <- do.call(rbind, list(dui2017, dui2016, dui2015, dui2014, dui2013))

head(duis)

duis %>% mutate(Date = mdy(Date),  
                DateTime = ymd_hms(paste(Date, Time))) -> duis2 

duis2 %>% 
  select(Date, Time, DateTime, InstrumentID, Location, Gender, Res1:Officer) %>% 
  mutate(nonresp_reason = ifelse(Res1 %in% c("Incomplete","Interference","Invalid", "Refused"), Res1, NA), 
         Res1 = parse_number(Res1), Res2 = parse_number(Res2)) -> duis_all

unique(duis$Location) %>% sort

locs <- duis$Location

locs[str_detect(locs,"ISU")] <- "ISU PD"
locs[str_detect(locs,"IOWA")] <- "ISU PD"
locs[str_detect(locs,"ARMORY")] <- "ISU PD"
locs <- str_replace(locs, "P.D.", "PD")
locs[str_detect(locs,"AMES")] <- "Ames PD"
locs[str_detect(locs,"HUXLEY")] <- "Huxley PD"
locs[locs == "515 CLARK AVE."] <- "Ames PD"
locs[str_detect(locs,"SHER")] <- "Story Cnty SO"
locs[str_detect(locs,"SO")] <- "Story Cnty SO"
locs[str_detect(locs,"HPD")] <- "Huxley PD"
locs[str_detect(locs,"JAIL")] <- "Story Cnty Jail"
locs[str_detect(locs,"SU - POLICE DIVISION")] <- "ISU PD"
locs[str_detect(locs,"STORY CITY")] <- "Story City PD"
locs[str_detect(locs,"LEC")] <- "Story Cnty SO"
locs[str_detect(locs,"STORY CO")] <- "Story Cnty SO"


duis$Location <- locs
#write_csv(duis, "data/duis_combined_2013-17.csv")


#write_csv(duis_all, "duis_combined_2013-17.csv")

#duis <- duis %>% 
#  mutate(data = map(year, function(x){read_excel("data/duidatastorycounty.xlsx", sheet = x)}))
#duis <- duis %>% unnest()
#glimpse(duis)

# duis %>% mutate(year = parse_integer(year),  
#                 hr = hour(Time), min = minute(Time), sec = second(Time),
#                 datetime = ymd_hms(paste(Date, paste(hr, min, sec, sep = ":")))) -> duis

#duis %>% 
#  select(year, Date, datetime, InstrumentID, Location, Gender, Res1:Officer) %>%
#  mutate(nonresp_reason = ifelse(Res1 %in% c("Incomplete","Interference","Invalid", "Refused"), Res1, NA), 
#         Res1 = parse_number(Res1), Res2 = parse_number(Res2)) -> duis

#head(duis)
  
#write_csv("data/duis_.csv")
