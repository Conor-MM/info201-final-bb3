library(httr)
library(lubridate)
library(dplyr)
library(jsonlite)
library(readr)

address <- "https://earthquake.usgs.gov/fdsnws/event/1/"
method <- "query?"
format <- "format=csv"
start_and_end <- "starttime=2014-01-01&endtime=2014-01-02"
usgs_uri <- paste0(address, method, format, "&", start_and_end)
usgs_res <- GET(usgs_uri)

usgs_data <- content(usgs_res, "parsed")[, c(1,2,3,5,14)]
filtered_data <- usgs_data %>%
  filter(longitude > -124 & longitude < -67 & latitude > 25 & latitude < 50)

usgs_map <- ggplot() + geom_polygon(data=map_data("state"), aes(x=long, y=lat, group = group),colour="black", fill="white") +
geom_point(filtered_data, mapping = aes(longitude, latitude), color = "red", size = filtered_data$mag) + coord_quickmap()
