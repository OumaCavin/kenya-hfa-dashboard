# Kenya Health Facility Assessment App - Global Configuration
# Author: Cavin Otieno

# Load required packages
library(shiny)
library(bslib)
library(plotly)
library(dplyr)
library(tidyr)
library(DT)
library(ggplot2)

# Application configuration
app_config <- list(
  title = "Kenya Health Facility Assessment",
  version = "1.0.0",
  author = "Cavin Otieno",
  environment = "development"
)

# Theme configuration - Light theme using bslib
app_theme <- bslib::bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#2E86AB",
  secondary = "#A23B72",
  success = "#28A745",
  warning = "#F18F01",
  danger = "#C73E1D",
  info = "#00ACC1"
)

# Dark theme variant
dark_theme <- bslib::bs_theme(
  version = 5,
  bootswatch = "darkly",
  primary = "#2E86AB",
  secondary = "#A23B72"
)

# Simple logging function
log_message <- function(level = "INFO", message) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(paste0("[", timestamp, "] ", toupper(level), ": ", message, "\n"))
}

# Error handling function
handle_error <- function(error_msg) {
  log_message("ERROR", error_msg)
  if (interactive()) {
    shiny::showNotification(
      ui = paste("Error:", error_msg),
      type = "error",
      duration = 10
    )
  }
}

# Safe data loading function
load_data_safe <- function(data_path) {
  tryCatch({
    if (!file.exists(data_path)) {
      log_message("WARN", paste("Data file not found:", data_path))
      return(NULL)
    }
    data <- read.csv(data_path, comment.char = "#", stringsAsFactors = FALSE)
    log_message("INFO", paste("Loaded data from", data_path, "-", nrow(data), "rows"))
    data
  }, error = function(e) {
    log_message("ERROR", paste("Failed to load", data_path, ":", e$message))
    NULL
  })
}

# Load census data
log_message("INFO", "Loading census data...")
census_data <- load_data_safe("data/sample_census.csv")

# Load QoC data
log_message("INFO", "Loading QoC data...")
qoc_data <- load_data_safe("data/sample_qoc.csv")

# Extract unique values for filters
if (!is.null(census_data)) {
  county_list <- sort(unique(census_data$county))
  facility_types <- sort(unique(census_data$ownership))
} else {
  county_list <- character()
  facility_types <- character()
}

if (!is.null(qoc_data)) {
  quality_indicators <- sort(unique(qoc_data$indicator))
} else {
  quality_indicators <- character()
}

# Reference links
reference_links <- list(
  census_url = "http://cema.shinyapps.io/kenya_hfa/",
  qoc_url = "http://cema.shinyapps.io/kenya_qoc/"
)

# Source information
source_info <- list(
  census_date = "August 2023",
  qoc_date = "March 2024",
  source = "Ministry of Health Kenya"
)

log_message("INFO", "Global configuration complete")
