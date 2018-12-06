library(shiny)
library(httr)
library(lubridate)
library(dplyr)
library(jsonlite)
library(ggplot2)
library(stringr)
library(readr)
library(maps)

server <- function(input, output) {

  values <- reactiveValues()

## This widget lets the user choose a specific time range to display the data from
  output$date_range <- renderUI({
  if(input$date_options == "Past Week"){
    min_date <- Sys.Date() - 7
  } else{
    min_date <- Sys.Date() - 30
  }
  sliderInput("date_range", "Advanced",
  min = min_date, max = Sys.Date(), value = c(min_date, Sys.Date()))
  })

## This widget generates a short summary of the selected region
  output$summary <- renderText({
    shiny::validate(
       need(input$date_range, "Just one sec...")
    )
    result <- sprintf("From %s to %s, there has been a total of %s earthquakes in %s.",
    input$date_range[1], input$date_range[2], values$count, values$region
    )
    if(!values$empty){
      result <- paste(result, sprintf("Averaging %s per day over %s days. The average magnitude is %s and the highest is %s, spotted near %s.",
      round(values$count/as.numeric((input$date_range[2] - input$date_range[1]), units = "days"), 2),
      (input$date_range[2] - input$date_range[1]), values$mean, values$max, values$place))
    }
    return(result)
  })

## This is where most of the data processing is and the graph is made here
  output$graph_m <- renderPlot({
    shiny::validate(
       need(input$date_range, "Just one sec...")
     )
    usgs_uri <- sprintf("https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=%s&endtime=%s",
    input$date_range[1], input$date_range[2])
    usgs_res <- GET(usgs_uri)

    usgs_data <- filter(content(usgs_res, "parsed"), type == "earthquake")[, c(1,2,3,5,14)]
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
        if(input$show_county){
          map_level <- "county"
        } else{
          map_level <- "state"
        }
        geo_data <- filter(map_data(map_level), region == tolower(input$states))
      } else{
        geo_data <- filter(map_data("world"), subregion == input$states & long < 0)
      }
      filtered_data <- usgs_data %>%
        filter(str_detect(paste0("|", selected_state, collapse="|"), paste0("\\|", (word(place, -1)))) & longitude < 0)
        values$region <- input$states
    }

    values$count <- nrow(filtered_data)
    values$mean <- round(mean(filtered_data$mag, na.rm=TRUE), 2)
    values$max <- max(filtered_data$mag, na.rm=TRUE)
    values$empty <- dim(filtered_data)[1] == 0
    values$place <- filter(filtered_data, mag == values$max)$place
    values$data <- filtered_data[order(as.POSIXct(filtered_data$time, "%Y-%m-%d %H:%M:%S")),]

    usgs_map <- ggplot() + geom_polygon(data=geo_data, aes(x=long, y=lat, group=group), colour="black", fill="white") +
    geom_point(filtered_data, mapping = aes(longitude, latitude, color = filtered_data$mag), size = filtered_data$mag) +
    scale_color_gradient("Magnitude", low="yellow", high="red", limits = c(0, 10)) + coord_quickmap()
    return(usgs_map)
  })

  output$graph_l <- renderPlot({
    if(values$count != 0){
      shiny::validate(
         need(input$date_range, "Just one sec...")
       )
      values$data$Index <- seq.int(nrow(values$data))
      chart <- ggplot(values$data, aes(x=as.POSIXct(time, "%Y-%m-%d %H:%M:%S"), y=Index)) + xlab("Date") + ylab("Number of Quakes") +
      stat_smooth(method = "gam", formula = y ~ s(x, bs = "cs"))
      return(chart)
    } else {
      return(paste0("Graph cannot be made"))
    }
  })
  
  output$graph_b <- renderPlot({
    if(values$count != 0){
      shiny::validate(
        need(input$date_range, "Just one sec...")
      )
      values$data$Index <- seq.int(nrow(values$data))
      chart <- ggplot(values$data, aes(x=as.POSIXct(time, "%Y-%m-%d %H:%M:%S"), y=mag, color = round(mag, digits = 0))) + 
        labs(x = "Date", y = "Quake Magnitude") + 
        geom_point(
        )+
        scale_color_gradient("Magnitude", low="orange", high="magenta3", limits = c(0, 10))
      return(chart)
    } else {
      return(paste0("Graph cannot be made"))
    }
  })
}
