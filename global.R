# Global configurations and data loading for Kenya HFA App

# Load required packages
library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(DT)
library(ggplot2)

# Application title
app_title <- "Kenya Health Facility Assessment"

# Application description
app_description <- "This dashboard contains the analysis of data from the Kenya Health Facility Census Assessment and the Quality of Care conducted by the Ministry of Health in the month of August 2023 and March 2024. The assessment covers all Public, Private and Faith-Based-Organization health facilities."

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