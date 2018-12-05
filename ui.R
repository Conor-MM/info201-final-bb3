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
        strong("100 times stronger"), "than the one that hit Alaska.")
      )
    ),

    tabPanel("Explorer",
      mainPanel(
        plotOutput("graph"),
        radioButtons("date_options", "Choose Date Range", c("Past Week", "Past Month")),
        uiOutput("date_range")
      ),
      sidebarPanel(
        selectInput("states", "Select a State to display summary", c("Unspecified", state.name), "Unspecified"),
        uiOutput("summary")
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
