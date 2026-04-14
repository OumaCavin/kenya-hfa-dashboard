# Kenya Health Facility Assessment App

A Shiny application for analyzing Kenya Health Facility Census and Quality of Care data.

## Overview

This dashboard contains the analysis of data from the Kenya Health Facility Census Assessment and the Quality of Care conducted by the Ministry of Health in August 2023 and March 2024.

## Features

- **Health Facility Census Analysis**: View comprehensive census data of health facilities
- **Quality of Care Assessment**: Analyze quality of care metrics across facilities
- **Interactive Visualizations**: Charts, tables, and maps for data exploration
- **Data Filtering**: Filter by county, facility type, and ownership
- **Export Capabilities**: Download data in CSV format

## Installation

```r
# Clone the repository
git clone https://github.com/OumaCavin/kenya-hfa-app.git

# Install dependencies
renv::restore()

# Run the application
shiny::runApp()
```

## Project Structure

```
kenya-hfa-app/
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
- dplyr
- tidyr
- DT

## Author

Cavin Otieno - OumaCavin

## License

MIT License