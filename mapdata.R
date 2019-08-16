#Load libraries for the data
library(ggmap)
library(tidyverse)
library(readxl)

#Register google maps key
register_google(key = "AIzaSyDl1GQTJa_0SZsnEaWICNxinF5bQlt7G54")

#Load France and Quebec map
france <- get_googlemap(center = c(lon = 2, lat = 47), zoom = 6, maptype = "terrain", style = "feature:all|element:labels|visibility:off") %>%
  ggmap()
quebec <- get_googlemap(center = c(lon = -72.5, lat = 47), zoom = 6, maptype = "terrain", style = "feature:all|element:labels|visibility:off") %>%
  ggmap()

#Save France and Quebec map
saveRDS(france, file = "france.rds")
saveRDS(quebec, file = "quebec.rds")

#Load and save cities data with longitude, latitude and population size
cities <- read_excel("./cities.xlsx") %>%
  mutate(city = as.factor(city),
         country = as.factor(country))
saveRDS(cities, file = "cities.rds")
