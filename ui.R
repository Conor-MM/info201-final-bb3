library(shiny)
library(dplyr)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("flatly"),

  titlePanel("USGS Earthquake Explorer"),

  tabsetPanel(

    ## This tab gives the viewer information about earthquakes to help them better understand the
    ## 'Explorer' tab, which houses the interactive components
    tabPanel("Home",
      mainPanel(

        h3("What is an earthquake?"),

        p("An earthquake is the shaking of the earth's surface triggered by sudden bursts of energy from the
          earth's lithosphere--also known as", strong("seismic waves."), "They can happen anywhere and range
          from those too small to feel to those violent enough to level houses and cause massive
          infrastructural damage."),

        h3("How are earthquakes measured?"),

        p("Earthquakes are most commonly measured by their magnitude on the",
          strong(a(href="https://en.wikipedia.org/wiki/Richter_magnitude_scale", "Richter Scale.")),
          "The scale was developed by Charles Francis Richter and designed to measure the seismic waves
          produced from earthquakes. In the past, measurements were simply made using the amount of 'shaking'
          detected at the earthquake's epicenter. With the invention of seismographs, Richter could go beyond
          measuring an earthquake's intensity and determine the amount of energy it released."),

        p("The Richter Scale is not like the metric or imperial measurement system, however. Instead of using
          a simple raio scale, it uses an exponential one, measuring earthquakes by degrees of magnitude."),

        p(strong("What does that mean?")),

        p("Let's use an example. Let's say a magnitude-5 earthquake hits the Alaskan coast. Later on that
          day, a magnitude-6 strikes Japan. Japan's earthquake is actually", strong("10 times stronger"),
          "than the one that hit Alaska. If another 7-magnitude quake hits Oregon, that earthquake will be",
          strong("100 times stronger"), "than the one that hit Alaska."),

        p("This is why you can barely feel a magnitude-2, but can be buried under a building by a
          magnitude-8."),

        h3("Helpful visuals:"),

        img(src='earthquake_mag.png', width=800),

        img(src='earthquake_destr.png', width=800),

        h3("To view recent earthquakes in the United States, click the 'Explorer' tab!")
      )
    ),

    ## This is where the app's interactive components are, including a state selection tool and date
    ## selection tool and slider
    tabPanel("Explorer",
      mainPanel(
        plotOutput("graph_m"),
        splitLayout(plotOutput("graph_l"), plotOutput("graph_b"))
      ),
      sidebarPanel(
      h2("Summary"),
        selectInput("states", "Select a State", c("Unspecified", state.name), "Unspecified"),
        checkboxInput("show_county", "Show Counties", TRUE),
        radioButtons("date_options", "Choose Date Range", c("Past Week", "Past Month")),
        uiOutput("date_range"),
        uiOutput("summary")
      )
    ),

    ## This is where we give credit to our sources
    tabPanel("Resources",
      mainPanel(

        h3("Tools:"),

        p("This app was made in RStudio utilizing the Shiny, HTTR, lubridate, dplyr, jsonlite, ggplot2,
          stringr, readr, shinytheme, and maps packages."),

        h3("Sources:"),

        p("All data used in the Explorer tab is courtesy of the",
          a(href= "https://earthquake.usgs.gov/fdsnws/event/1/#parameters", "United States Geological Survey
          api"), "and is openly available to the public. The API we used to access earthquake data did not
          require an API key."),

        p("The USGS is dedicated to gathering useful information about the United States' landscape, natural
          resources, and natural hazards."),"For more information about the USGS and the work it does,",
          a(href="https://earthquake.usgs.gov/", "click here."))

      )
    )
  )
)
