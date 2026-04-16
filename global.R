# Global configurations and data loading for CEMA HFA Dashboard
# Author: Cavin Otieno

# Load required packages
library(shiny)
library(plotly)
library(leaflet)
library(dplyr)
library(tidyr)
library(DT)
library(ggplot2)

# Application title
app_title <- "CEMA Health Facility Assessment Dashboard"

# Application description
app_description <- "This dashboard provides comprehensive analysis of data from the Kenya Health Facility Census Assessment and the Quality of Care conducted by the Ministry of Health in August 2023 and March 2024. The assessment covers all Public, Private, and Faith-Based-Organization health facilities."

# Load census data
census_data <- read.csv("data/sample_census.csv", stringsAsFactors = FALSE)

# Load QoC data
qoc_data <- read.csv("data/sample_qoc.csv", stringsAsFactors = FALSE)

# Extract unique values for filters
county_list <- sort(unique(census_data$county))
facility_types <- sort(unique(census_data$facility_type))
ownership_types <- sort(unique(census_data$ownership))
quality_indicators <- sort(unique(qoc_data$indicator))

# Create reference links
reference_links <- list(
  census_url = "http://cema.shinyapps.io/kenya_hfa/",
  qoc_url = "http://cema.shinyapps.io/kenya_qoc/"
)

# Kenya county coordinates for map
kenya_counties <- data.frame(
  county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma", "Uasin Gishu", "Meru", "Kiambu", "Machakos"),
  lat = c(-1.2839, -4.0435, -0.0600, -0.3031, 0.2828, 0.5135, 0.5146, 0.0460, -1.0318, -1.5177),
  lng = c(36.8172, 39.6685, 34.7676, 36.0724, 34.7523, 34.5606, 35.2698, 37.6589, 36.0999, 37.2604)
)