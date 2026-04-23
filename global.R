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
library(cachem)
library(lgr)

# Initialize logging
logger <- lgr::get_logger("hfa_app")
logger$set_level(Sys.getenv("LOG_LEVEL", "INFO"))
logger$info("Starting Kenya HFA Dashboard")

# Application configuration
app_config <- list(
  title = "Kenya Health Facility Assessment",
  version = "1.0.0",
  author = "Cavin Otieno",
  environment = Sys.getenv("APP_ENV", "development")
)

# Theme configuration - Light theme
app_theme <- bslib::bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#2E86AB",
  secondary = "#A23B72",
  success = "#28A745",
  warning = "#F18F01",
  danger = "#C73E1D",
  info = "#00ACC1",
  base_font = font_google("Roboto"),
  heading_font = font_google("Montserrat"),
  enable_webfonts = TRUE
)

# Dark theme variant
dark_theme <- bslib::bs_theme(
  version = 5,
  bootswatch = "darkly",
  primary = "#2E86AB",
  secondary = "#A23B72",
  base_font = font_google("Roboto"),
  heading_font = font_google("Montserrat"),
  enable_webfonts = TRUE
)

# Caching configuration
data_cache <- cache_mem(max_size = 50 * 1024^2, max_age = 10 * 60)

# Error handling function
handle_error <- function(error_msg, severity = "ERROR") {
  logger$log(severity, error_msg)
  shiny::showNotification(
    ui = paste("An error occurred:", error_msg),
    type = "error",
    duration = 10
  )
}

# Try-catch wrapper for reactive expressions
safe_reactive <- function(expr, error_msg = "An error occurred") {
  tryCatch(
    expr,
    error = function(e) {
      logger$error(paste(error_msg, e$message))
      NULL
    }
  )
}

# Data loading with error handling
load_data_safe <- function(data_path) {
  tryCatch({
    if (!file.exists(data_path)) {
      logger$warn(paste("Data file not found:", data_path))
      return(NULL)
    }
    data <- read.csv(data_path, comment.char = "#", stringsAsFactors = FALSE)
    logger$info(paste("Loaded data from", data_path, "-", nrow(data), "rows"))
    data
  }, error = function(e) {
    logger$error(paste("Failed to load", data_path, ":", e$message))
    NULL
  })
}

# Load census data
census_data <- load_data_safe("data/sample_census.csv")

# Load QoC data
qoc_data <- load_data_safe("data/sample_qoc.csv")

# Extract unique values for filters
county_list <- if (!is.null(census_data)) sort(unique(census_data$county)) else character()
facility_types <- if (!is.null(census_data)) sort(unique(census_data$facility_type)) else character()
ownership_types <- if (!is.null(census_data)) sort(unique(census_data$ownership)) else character()
quality_indicators <- if (!is.null(qoc_data)) sort(unique(qoc_data$indicator)) else character()

# Create reference links
reference_links <- list(
  census_url = "http://cema.shinyapps.io/kenya_hfa/",
  qoc_url = "http://cema.shinyapps.io/kenya_qoc/"
)

# Source tracking
source_info <- list(
  census_date = "August 2023",
  qoc_date = "March 2024",
  source = "Ministry of Health Kenya"
)

logger$info("Global configuration complete - Data loaded successfully")