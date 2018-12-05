library(shiny)
library(httr)
library(lubridate)
library(dplyr)
library(jsonlite)
library(ggplot2)
library(stringr)

server <- function(input, output) {

  values <- reactiveValues()

  output$date_range <- renderUI({
  if(input$date_options == "Past Week"){
    min_date <- Sys.Date() - 7
  } else{
    min_date <- Sys.Date() - 30
  }
  sliderInput("date_range", "Advanced",
  min = min_date, max = Sys.Date(), value = c(min_date, Sys.Date()))
  })

  output$summary <- renderText({
    shiny::validate(
       need(input$date_range, "Just one sec...")
    )
    result <- sprintf("From %s to %s, there has been a total of %s earthquakes in %s.",
    input$date_range[1], input$date_range[2], values$count, values$region
    )
    if(!values$empty){
      result <- paste(result, sprintf("Averaging %s per day over %s days. The average magnitude is %s and the highest is %s.",
      round(values$count/as.numeric((input$date_range[2] - input$date_range[1]), units = "days"), 2), (input$date_range[2] - input$date_range[1]),
      values$mean, values$max))
    }
    return(result)
  })


  output$graph <- renderPlot({
    shiny::validate(
       need(input$date_range, "Just one sec...")
     )
    usgs_uri <- sprintf("https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=%s&endtime=%s", input$date_range[1], input$date_range[2])
    usgs_res <- GET(usgs_uri)

    usgs_data <- content(usgs_res, "parsed")[, c(1,2,3,5,14)]
    if(input$states == "Unspecified"){
      geo_data <- map_data("state")
      us_states <- c(state.name, state.abb)
      filtered_data <- usgs_data %>%
        filter(str_detect(paste(us_states, collapse="|"), (word(place, -1)))) %>%
        filter(longitude > -124 & longitude < -67 & latitude > 25 & latitude < 50)
      values$region <- "United States(Excluding Alaska and Hawaii)"
    } else{
    selected_state <- c(input$states, state.abb[match(input$states, state.name)])
    if(input$states != "Alaska" & input$states != "Hawaii"){
      geo_data <- filter(map_data("state"), region == tolower(input$states))
    } else{
      geo_data <- filter(map_data("world"), subregion == input$states & long < 0)
    }
    filtered_data <- usgs_data %>%
      filter(str_detect(paste(selected_state, collapse="|"), (word(place, -1))))
      values$region <- input$states
    }

    values$count <- nrow(filtered_data)
    values$mean <- round(mean(filtered_data$mag, na.rm=TRUE), 2)
    values$max <- max(filtered_data$mag, na.rm=TRUE)
    values$empty <- dim(filtered_data)[1] == 0

    usgs_map <- ggplot() + geom_polygon(data=geo_data, aes(x=long, y=lat, group = group),colour="black", fill="white") +
    geom_point(filtered_data, mapping = aes(longitude, latitude), color = "red", size = filtered_data$mag) + coord_quickmap()
    return(usgs_map)
  })
}
