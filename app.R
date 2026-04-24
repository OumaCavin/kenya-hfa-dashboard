# Kenya Health Facility Assessment App - Shiny Application
# Author: Cavin Otieno

library(shiny)
library(bslib)
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

# Load data and configuration
source("global.R")

# Define UI using bslib navbar page
ui <- bslib::page_navbar(
  title = div(
    "Kenya Health Facility Assessment"
  ),
  theme = app_theme,
  collapsible = TRUE,

  # Census Tab
  bslib::nav_panel(
    title = "Kenya Health Facility Census",
    censusTabUI("census")
  ),

  # QoC Tab
  bslib::nav_panel(
    title = "Kenya Quality of Care Assessment",
    qocTabUI("qoc")
  ),

  # Footer
  footer = div(
    class = "container",
    style = "padding: 20px; background-color: #f8f9fa; margin-top: 20px;",
    tags$hr(),
    div(
      class = "row",
      div(
        class = "col-md-6",
        strong("CEMA Africa")
      ),
      div(
        class = "col-md-6 text-right",
        a(href = "mailto:info@cema.africa", "Contact us: info@cema.africa")
      )
    ),
    div(
      class = "row",
      style = "margin-top: 10px; color: #6c757d; font-size: 12px;",
      div(class = "col-md-12 text-center",
          "Version 1.0.0 | Author: Cavin Otieno"
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

  # Log session info
  log_message("INFO", paste("Session started:", session$token))
}

# Run the application
shinyApp(ui = ui, server = server)
