# CEMA Health Facility Assessment Dashboard - Shiny Application
# Author: Cavin Otieno

library(shiny)
library(shinythemes)
library(plotly)
library(leaflet)
library(dplyr)
library(tidyr)
library(DT)

# Source helper functions
source("R/data_loader.R")
source("R/chart_helpers.R")
source("R/theme.R")
source("R/summary_module.R")
source("R/common_components.R")

# Load data
source("global.R")

# Define UI
ui <- navbarPage(
  title = div(
    img(src = "moh_logo.png", height = "40px", style = "margin-right: 10px;"),
    "CEMA Health Facility Assessment"
  ),
  theme = shinytheme("cerulean"),
  collapsible = TRUE,
  windowTitle = "CEMA Health Facility Assessment Dashboard",

  # Summary Tab
  tabPanel(
    title = "Summary",
    icon = icon("home"),
    summaryTabUI("summary")
  ),

  # Health Services Dropdown Menu
  navbarMenu(
    title = "Health Services",
    icon = icon("heartbeat"),
    "--- Primary Health Care ---" = div(style = "text-align: center; color: #666; padding: 5px;", ""),
    "Outpatient Services" = div(),
    "Basic Maternity Services" = div(),
    "Comprehensive Maternity Services" = div(),
    "Newborn Care Services" = div(),
    "--- Inpatient Services ---" = div(style = "text-align: center; color: #666; padding: 5px;", ""),
    "Medical Ward Services" = div(),
    "Surgical Ward Services" = div(),
    "Pediatric Ward Services" = div(),
    "Obstetrics Ward Services" = div(),
    "--- Specialized Services ---" = div(style = "text-align: center; color: #666; padding: 5px;", ""),
    "Laboratory Services" = div(),
    "Radiology Services" = div(),
    "Pharmacy Services" = div(),
    "Theatre Services" = div()
  ),

  # Infrastructure Tab
  tabPanel(
    title = "Infrastructure",
    icon = icon("building"),
    infrastructureTabUI("infrastructure")
  ),

  # Level of Care Tab
  tabPanel(
    title = "Level of Care",
    icon = icon("layer-group"),
    levelOfCareTabUI("level_of_care")
  ),

  # Human Resource Tab
  tabPanel(
    title = "Human Resource",
    icon = icon("users"),
    hrTabUI("hr")
  ),

  # Equipment Tab
  tabPanel(
    title = "Equipment",
    icon = icon("wrench"),
    equipmentTabUI("equipment")
  ),

  # Location Map Tab
  tabPanel(
    title = "Location",
    icon = icon("map-marker-alt"),
    locationTabUI("location")
  ),

  # Regulatory Tab
  tabPanel(
    title = "Regulatory",
    icon = icon("balance-scale"),
    regulatoryTabUI("regulatory")
  ),

  # Facility Categories Tab
  tabPanel(
    title = "Facility Categories",
    icon = icon("tags"),
    facilityCategoriesTabUI("facility_categories")
  ),

  # Assessment Completion Tab
  tabPanel(
    title = "Assessment Completion",
    icon = icon("check-circle"),
    assessmentTabUI("assessment")
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
  # Summary tab server
  summaryTabServer("summary", census_data, county_list, facility_types, ownership_types)

  # Infrastructure tab server
  infrastructureTabServer("infrastructure", census_data, county_list)

  # Level of Care tab server
  levelOfCareTabServer("level_of_care", census_data)

  # Human Resource tab server
  hrTabServer("hr", census_data, county_list)

  # Equipment tab server
  equipmentTabServer("equipment", census_data, county_list)

  # Location tab server
  locationTabServer("location", census_data, county_list)

  # Regulatory tab server
  regulatoryTabServer("regulatory", census_data, county_list)

  # Facility Categories tab server
  facilityCategoriesTabServer("facility_categories", census_data, county_list)

  # Assessment tab server
  assessmentTabServer("assessment", census_data, county_list)
}

# Run the application
shinyApp(ui = ui, server = server)