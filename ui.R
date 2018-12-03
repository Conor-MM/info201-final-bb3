library(shiny)
library(dplyr)

# Define UI for application that organizes UFO data from 2016
shinyUI(fluidPage(
  
  titlePanel("USGS Earthquake Explorer"),
  
  tabsetPanel(
  
    tabPanel("Home",
      
      mainPanel(
        
        h3("What is an earthquake?"),
        
        "An earthquake is the shaking of the earth's surface triggered by sudden bursts of energy from the
        earth's lithosphere--also known as", strong("seismic waves."), "They can happen anywhere and range
        from those too small to feel to those violent enough to level houses and cause massive
        infrastructural damage.",

        h3("How are earthquakes measured?"),
      
        "Earthquakes are most commonly measured by their magnitude on the", 
        strong(a(href="https://en.wikipedia.org/wiki/Richter_magnitude_scale", "Richter Scale.")), 
        "The scale was developed by Charles Francis Richter and designed to measure the seismic waves
        produced from earthquakes. In the past, measurements were simply made using the amount of 'shaking'
        detected at the earthquake's epicenter. With the invention of seismographs, Richter could go beyond
        measuring an earthquake's intensity and determine the amount of energy it released.",
        
        "The Richter Scale relies on an exponential "
      )
    ),
    
    tabPanel("Explorer",
      mainPanel(
        ""
      )
    ),
    
    tabPanel("Resources",
             mainPanel(
               ""
             )
    )
  )
)
)
