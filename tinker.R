library(httr)
library(lubridate)
library(dplyr)
library(jsonlite)

address <- "https://earthquake.usgs.gov/fdsnws/event/1/" 
method <- "query?"
format <- "format=csv"
start_and_end <- "starttime=2014-01-01&endtime=2014-01-02" 
usgs_uri <- paste0(address, method, format, "&", start_and_end)
usgs_res <- GET(usgs_uri)
