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
      
        "Earthquakes are measured by their magnitude on the", strong("Richter Scale.") 
      )
    ),
    
    tabPanel("Explorer",
      mainPanel(
        ""
      )
    )
  )
)
)
