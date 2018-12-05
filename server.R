library(shiny)
library(httr)
library(lubridate)
library(dplyr)
library(jsonlite)
library(ggplot2)

server <- function(input, output) {
  output$date_range <- renderUI({
  if(input$date_options == "Past Week"){
    min_date <- Sys.Date() - 7
  } else{
    min_date <- Sys.Date() - 30
  }
  sliderInput("date_range", "Advanced",
  min = min_date, max = Sys.Date(), value = c(min_date, Sys.Date()))
  })

  output$graph <- renderPlot({
    shiny::validate(
       need(input$date_range, "Just one sec...")
     )
    usgs_uri <- sprintf("https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=%s&endtime=%s", input$date_range[1], input$date_range[2])
    usgs_res <- GET(usgs_uri)

    usgs_data <- content(usgs_res, "parsed")[, c(1,2,3,5,14)]
    filtered_data <- usgs_data %>%
      filter(longitude > -124 & longitude < -67 & latitude > 25 & latitude < 50)

    usgs_map <- ggplot() + geom_polygon(data=map_data("state"), aes(x=long, y=lat, group = group),colour="black", fill="white") +
    geom_point(filtered_data, mapping = aes(longitude, latitude), color = "red", size = filtered_data$mag) + coord_quickmap()
    return(usgs_map)
  })
}
