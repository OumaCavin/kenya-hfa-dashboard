# CEMA Health Facility Assessment Dashboard

A comprehensive Shiny application for analyzing Kenya Health Facility Census and Quality of Care data.

## Overview

This dashboard provides comprehensive analysis of health facility data from the Kenya Health Facility Census Assessment and the Quality of Care conducted by the Ministry of Health in August 2023 and March 2024.

## Features

- **Summary Dashboard**: Overview statistics and key metrics across all health facilities
- **Health Services Analysis**: Detailed analysis of 13+ service categories including Primary Health Care, Inpatient, Laboratory, and more
- **Infrastructure Assessment**: Equipment and infrastructure availability analysis
- **Human Resource Metrics**: Staffing levels and competency analysis
- **Interactive Visualizations**: Charts, maps, and tables for data exploration
- **County-level Analysis**: Filter and analyze data by all 47 Kenyan counties
- **Export Capabilities**: Download data in CSV format

## Installation

```r
# Clone the repository
git clone https://github.com/OumaCavin/cema-hfa-dashboard.git

# Install dependencies
renv::restore()

# Run the application
shiny::runApp()
```

## Project Structure

```
cema-hfa-dashboard/
├── app.R                 # Main application
├── global.R              # Global configurations
├── R/                    # Helper functions
├── data/                 # Sample data files
└── www/                  # Static assets
```

## Requirements

- R 4.0+
- shiny
- plotly
- ggplot2
- leaflet (for maps)
- dplyr
- tidyr
- DT

## Author

Cavin Otieno - OumaCavin

## License

MIT License