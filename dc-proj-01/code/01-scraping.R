# scraping 
library(tidyverse)
library(rvest)
library(magrittr)

# code from https://stackoverflow.com/questions/37868709/using-submit-form-from-rvest-package-returns-a-form-which-is-not-updated
# url <- "http://www.cocorahs.org/ViewData/ListDailyPrecipReports.aspx"
# cocorahs <- html_session(url)
# 
# form.unfilled <- cocorahs %>% html_node("form") %>% html_form()
# form.filled <- form.unfilled %>%
#   set_values("frmPrecipReportSearch:ucStationTextFieldsFilter:tbTextFieldValue" = "840",
#              "frmPrecipReportSearch_ucDateRangeFilter_dcStartDate" = "6/15/2016",
#              "frmPrecipReportSearch_ucDateRangeFilter_dcEndDate" = "6/15/2016")
# 
# # submit the form and save as a new session
# session <- submit_form(cocorahs, form.filled) 
# 
# # look for a table in the nodes
# table <- session %>% html_nodes("table")
# 
# # The table you want
# table[[7]] %>% html_table()


# 2 forms: 1 is the general search function; 2 should be the form

# fields i want to fill out: 
# <select> county (0-100 vals maybe?)
# <input text> 'data[BreathRecord][taken_from]': 
# <input text> 'data[BreathRecord][taken_to]': 
# for above 2 should just be able to enter a start and end date. 


homepg <- "https://breathalcohol.iowa.gov/breath_records"

read_html(homepg) %>% html_form()

duis <- html_session(homepg)

# Grab Initial Form
#  Form is filled in stages. Here, only do country and date
form.unfilled <- duis %>% html_form() %>% extract2(2)
form.filled <- form.unfilled %>% 
  set_values('data[County][id]' = '77',
             'data[BreathRecord][taken_from]' = "01/01/2017",
             'data[BreathRecord][taken_to]' = "12/31/2017")

session2 <- submit_form(duis, form.filled)  # not working yet. 

session2 %>% html_children()
