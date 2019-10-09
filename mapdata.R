#Load libraries for the data
library(ggmap)
library(tidyverse)
library(readxl)

#Register google maps key
register_google(key = "INSERT KEY")

#Load France and Quebec map
france <- get_googlemap(center = c(lon = 2, lat = 47), zoom = 6, maptype = "terrain", style = "feature:all|element:labels|visibility:off") %>%
  ggmap()
quebec <- get_googlemap(center = c(lon = -72.5, lat = 47), zoom = 6, maptype = "terrain", style = "feature:all|element:labels|visibility:off") %>%
  ggmap()

#Save France and Quebec map
saveRDS(france, file = "france.rds")
saveRDS(quebec, file = "quebec.rds")