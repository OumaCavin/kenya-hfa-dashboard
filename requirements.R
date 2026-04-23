# Kenya HFA Dashboard - R Package Dependencies
# Author: Cavin Otieno

# Core Shiny packages
install.packages("shiny", version = ">=1.8.0")

# Modern theming with bslib
install.packages("bslib", version = ">=0.7.0")

# Data manipulation and visualization
install.packages(c(
  "dplyr",      # Data manipulation
  "tidyr",      # Data tidying
  "ggplot2",    # Visualization
  "plotly",     # Interactive charts
  "leaflet",    # Interactive maps
  "DT"          # Interactive data tables
))

# Performance and caching
install.packages(c(
  "shinyjs",    # JavaScript utilities
  "cachem"     # Caching utilities
))

# UI enhancements
install.packages(c(
  "fontawesome", # Font Awesome icons
  "htmlwidgets"  # HTML widgets
))

# Error handling and logging
install.packages(c(
  "lgr"         # Logging framework
))

# Development tools
install.packages(c(
  "renv"        # Dependency management
))

# If using renv, restore dependencies
if (requireNamespace("renv", quietly = TRUE)) {
  if (file.exists("renv.lock")) {
    renv::restore()
  }
}

# Alternative: Install from requirements
# This file can be sourced: source("requirements.R")