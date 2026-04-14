# Kenya Health Facility Assessment App - User Guide

## Introduction

The Kenya Health Facility Assessment (HFA) dashboard provides a comprehensive view of health facility data from the Kenya Health Facility Census and Quality of Care Assessment.

## Getting Started

### Prerequisites
- R (version 4.0 or higher)
- RStudio (recommended)
- Internet connection

### Installation

1. Clone the repository:
```bash
git clone https://github.com/OumaCavin/kenya-hfa-app.git
```

2. Install R dependencies:
```R
renv::restore()
```

3. Launch the application:
```R
shiny::runApp()
```

## Application Features

### 1. Health Facility Census Tab

The census tab provides analysis of health facility census data covering:

- **Facility Overview**: Summary statistics of all facilities
- **Geographic Distribution**: Map showing facility locations by county
- **Facility Types**: Breakdown by public, private, and FBO categories
- **Services Offered**: Analysis of services provided by facilities

### 2. Quality of Care Assessment Tab

The quality of care tab displays assessment results including:

- **Performance Metrics**: Key quality indicators
- **Comparative Analysis**: Performance comparison across facilities
- **Trend Analysis**: Changes over the assessment period
- **Detailed Reports**: Facility-level quality reports

## Navigation

Use the top navigation tabs to switch between:
- Kenya Health Facility Census
- Kenya Quality of Care Assessment

## Data Filters

Each tab includes filter controls:
- **County**: Filter by specific county
- **Facility Type**: Filter by public/private/FBO
- **Date Range**: Select data collection period

## Data Export

Export functionality allows downloading:
- Data tables as CSV
- Charts as PNG images
- Full reports as PDF

## Troubleshooting

### Application Won't Start
1. Verify R version: `R --version`
2. Check package installation: `renv::restore()`
3. Review error messages in console

### Data Not Loading
1. Check internet connection
2. Verify data files exist in `data/` directory
3. Clear R session and re-run

### Display Issues
1. Clear browser cache
2. Try different browser (Chrome recommended)
3. Check JavaScript console for errors

## Contact

For support or feedback:
- Email: info@cema.africa
- GitHub Issues: https://github.com/OumaCavin/kenya-hfa-app/issues

## Author

Cavin Otieno
GitHub: OumaCavin
Email: cavin.otieno012@gmail.com