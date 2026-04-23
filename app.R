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

# Define UI
ui <- bslib::page_navbar(
  title = div(
    img(src = "moh_logo.png", height = "40px", style = "margin-right: 10px;"),
    "Kenya Health Facility Assessment"
  ),
  theme = app_theme,
  selected = NULL,
  collapsible = TRUE,
  id = "navbar",

  # Census Tab
  bslib::nav_panel(
    title = "Kenya Health Facility Census",
    icon = bsicons::bs_icon("building"),
    censusTabUI("census")
  ),

  # QoC Tab
  bslib::nav_panel(
    title = "Kenya Quality of Care Assessment",
    icon = bsicons::bs_icon("heart-pulse"),
    qocTabUI("qoc")
  ),

  # Settings Panel
  bslib::nav_spacer(),

  # Theme Toggle Button
  bslib::nav_item(
    span(
      class = "theme-toggle",
      style = "cursor: pointer; padding: 8px;",
      onclick = "Shiny.setInputValue('theme_toggle', Math.random())",
      bsicons::bs_icon("moon")
    )
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
        img(src = "cema_logo.png", height = "30px"),
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
  # Handle theme toggle
  current_theme <- reactiveVal("light")

  observeEvent(input$theme_toggle, {
    new_theme <- if (current_theme() == "light") "dark" else "light"
    current_theme(new_theme)

    # Update session theme
    if (new_theme == "dark") {
      bslib::bs_themer(dawn_theme)
    } else {
      bslib::bs_themer(app_theme)
    }
  })

  # Census module server
  censusTabServer("census", census_data, county_list, facility_types)

  # QoC module server
  qocTabServer("qoc", qoc_data, county_list, quality_indicators)

  # Log session info
  logger$info(paste("Session started:", session$token))
}

# Run the application
shinyApp(ui = ui, server = server)