# get iowa state football game data 

library(rvest)
library(magrittr)

url17 <- "https://www.sports-reference.com/cfb/schools/iowa-state/2017-schedule.html"
url16 <- "https://www.sports-reference.com/cfb/schools/iowa-state/2016-schedule.html"
url15 <- "https://www.sports-reference.com/cfb/schools/iowa-state/2015-schedule.html"
url14 <- "https://www.sports-reference.com/cfb/schools/iowa-state/2014-schedule.html"
url13 <- "https://www.sports-reference.com/cfb/schools/iowa-state/2013-schedule.html"
url12 <- "https://www.sports-reference.com/cfb/schools/iowa-state/2012-schedule.html"

games17 <- read_html(url17) %>% html_children() %>% 
  html_nodes("table") %>% html_table() %>% extract2(2)
names(games17)[c(6,9)] <- c("Home", "Res")
games16 <- read_html(url16) %>% html_children() %>% 
  html_nodes("table") %>% html_table() %>% extract2(1)
names(games16)[c(6,9)] <- c("Home", "Res")
games15 <- read_html(url15) %>% html_children() %>% 
  html_nodes("table") %>% html_table() %>% extract2(1)
names(games15)[c(6,9)] <- c("Home", "Res")
games14 <- read_html(url14) %>% html_children() %>% 
  html_nodes("table") %>% html_table() %>% extract2(1)
names(games14)[c(6,9)] <- c("Home", "Res")
games13 <- read_html(url13) %>% html_children() %>% 
  html_nodes("table") %>% html_table() %>% extract2(1)
names(games13)[c(6,9)] <- c("Home", "Res")

isu_fb <- bind_rows(games13, games14, games15, games16, games17)
isu_fb %>% glimpse

isu_fb$Home[which(isu_fb$Home != "@")] <- "home"
isu_fb$Home[which(isu_fb$Home == "@")] <- "away"

write_csv(isu_fb, "../dc-proj-02/data/isu_football.csv")
