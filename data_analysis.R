#This file contains codes for data processing in Chapter 4

#Read in libraries
library(readr)
library(tidyverse)
library(lubridate)

#Import data frame
hashtag_import <- read.csv("hashtag_df.csv")

#Clean data and select variables
hashtag <- hashtag_import %>%
  filter(!is.na(city)) %>%
  mutate(date = ymd_hms(date)) %>% #Transform date formats
  separate(date, c("ymd","hms"), sep = " ") %>%
  separate(ymd, c("year","month","day"), sep = "-") %>%
  mutate(year = as.factor(year),
         month = as.numeric(month)) %>%
  select(borrow_type, year, month, country, city, lon, lat, citysize) %>%
  group_by(borrow_type, year, month, country, city, lon, lat, citysize) %>%
  count() %>% #Count frequency per month
  ungroup() %>%
  spread(borrow_type, n) %>%
  mutate(english = replace_na(english, 0),
         prescribed = replace_na(prescribed, 0),
         englishPERCENT = english / (english + prescribed), #calculate percentage
         prescribedPERCENT = prescribed / (english + prescribed),
         english = englishPERCENT,
         prescribed = prescribedPERCENT) %>%
  unite(date, c(year, month), sep = "-") %>%
  mutate(date = paste(date, "1", sep = "-"),
         date = ymd(date),
         country = recode(country, France="france", Canada="quebec")) %>% #recode country data
  filter(!prescribed == 0) %>%
  select(date, country, city, lon, lat, prescribed, citysize)

#Save data for the shiny app
saveRDS(hashtag, file = "hashtag.rds")