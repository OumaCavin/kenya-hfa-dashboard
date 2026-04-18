# Kenya Health Facility Assessment App - Shiny Application
# Author: Cavin Otieno

library(shiny)
library(shinythemes)
library(plotly)
library(dplyr)
library(tidyr)
library(DT)

# Source helper functions
source("R/data_loader.R")
source("R/chart_helpers.R")
source("R/theme.R")
source("R/census_module.R")
source("R/census_server.R")
source("R/qoc_module.R")
source("R/qoc_server.R")

# Load data
source("global.R")

# Define UI
ui <- navbarPage(
  title = div(
    img(src = "moh_logo.png", height = "40px", style = "margin-right: 10px;"),
    "Kenya Health Facility Assessment"
  ),
  theme = shinytheme("cerulean"),
  collapsible = TRUE,

  # Census Tab
  tabPanel(
    title = "Kenya Health Facility Census",
    icon = icon("building"),
    censusTabUI("census")
  ),

  # QoC Tab
  tabPanel(
    title = "Kenya Quality of Care Assessment",
    icon = icon("heartbeat"),
    qocTabUI("qoc")
  ),

  # Footer
  footer = div(
    class = "container",
    tags$hr(),
    div(
      class = "row",
      div(
        class = "col-md-6",
        img(src = "cema_logo.png", height = "30px"),
        strong("CEMA Africa")
      ),
      div(
        class = "col-md-6 text-right",
        a(href = "mailto:info@cema.africa", "Contact us: info@cema.africa")
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Census module server
  censusTabServer("census", census_data, county_list, facility_types)

  # QoC module server
  qocTabServer("qoc", qoc_data, county_list, quality_indicators)
}

# Run the application
shinyApp(ui = ui, server = server)