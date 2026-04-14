# Kenya Health Facility Assessment App - Architecture Document

## System Overview

**Project**: Kenya Health Facility Assessment (HFA) Dashboard
**Type**: R Shiny Web Application
**Target Platform**: shinyapps.io (account: oumacavin)
**Author**: Cavin Otieno

## Architecture Layers

### 1. Presentation Layer
```
www/
├── css/
│   └── custom.css          # Custom styling
├── images/
│   ├── moh_logo.png        # Ministry of Health logo
│   └── cema_logo.png       # CEMA branding logo
└── js/
    └── custom.js           # Custom JavaScript
```

### 2. Application Layer
```
kenya-hfa-app/
├── app.R                   # Main Shiny application entry point
├── global.R                # Global configurations and data loading
├── ui/                     # UI module definitions
│   ├── header.R            # Header component
│   ├── navigation.R        # Navigation tabs
│   ├── census_tab.R        # Census assessment tab
│   └── qoc_tab.R           # Quality of care tab
└── server/                 # Server module definitions
    ├── census_server.R     # Census data processing
    └── qoc_server.R        # Quality of care processing
```

### 3. Data Layer
```
data/
├── census/                 # Health facility census data
│   └── sample_census.csv
├── qoc/                    # Quality of care assessment data
│   └── sample_qoc.csv
└── reference/             # Reference datasets
    └── facility_types.csv
```

### 4. Utility Layer
```
R/
├── data_loader.R           # Data loading utilities
├── chart_helpers.R         # Chart generation functions
├── table_helpers.R         # Table formatting utilities
└── theme.R                 # Custom theme definitions
```

## Key Components

### Header Component
- **Purpose**: Display application branding and title
- **Elements**:
  - MOH logo (left-aligned)
  - Application title
  - Descriptive subtitle about the assessment
- **Technology**: HTML/CSS via Shiny tags

### Navigation Tabs
- **Purpose**: Allow switching between main sections
- **Tabs**:
  1. Kenya Health Facility Census
  2. Kenya Quality of Care Assessment
- **Implementation**: Shiny `navbarPage` or `tabsetPanel`

### Census Assessment Module
- **Purpose**: Display health facility census analysis
- **Features**:
  - Summary statistics cards
  - Interactive charts (bar, pie, line)
  - Filter controls (facility type, county)
  - Data tables with pagination

### Quality of Care Module
- **Purpose**: Display quality of care assessment data
- **Features**:
  - Performance metrics
  - Comparative charts
  - Facility-level drill-down
  - Export functionality

## Technology Stack

| Component | Technology | Version |
|-----------|------------|---------|
| Framework | R Shiny | 4.x |
| Package Manager | renv | Latest |
| Charts | Plotly | Latest |
| Tables | DT | Latest |
| Styling | Bootstrap | 5.x |
| Deployment | shinyapps.io | - |

## Data Flow

```
User Request
     │
     ▼
┌─────────────────┐
│   Shiny App     │
│   (app.R)       │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌───────┐ ┌───────┐
│  UI   │ │Server │
│Module │ │Module │
└───┬───┘ └───┬───┘
    │         │
    ▼         ▼
┌────────┐ ┌────────┐
│  HTML  │ │ R Data │
│Output  │ │Process │
└────────┘ └────┬───┘
                │
                ▼
         ┌──────────┐
         │  Data    │
         │  Source  │
         └──────────┘
```

## Configuration Management

### Environment Variables
- `SHINYAPPS_TOKEN`: Deployment token for shinyapps.io

### Package Dependencies (renv)
- shiny
- plotly
- ggplot2
- dplyr
- tidyr
- DT
- shinythemes

## Deployment Architecture

```
Local Development ──► GitHub Repository ──► shinyapps.io
   (RStudio)           (OumaCavin/          (oumacavin account)
                       kenya-hfa-app)
```

## Error Handling Strategy

1. **Data Loading Errors**: Display user-friendly messages with retry options
2. **Rendering Errors**: Graceful degradation with fallback content
3. **Network Errors**: Caching for offline access to previously loaded data

## Performance Considerations

- Lazy loading of data modules
- Efficient reactive expressions to minimize recalculations
- Caching of expensive computations
- Asynchronous data fetching where applicable

## Security Considerations

- No sensitive data stored in repository
- Environment variables for configuration
- Input validation on all user inputs
- HTTPS for all external resources

## Author

Cavin Otieno
GitHub: OumaCavin
Email: cavin.otieno012@gmail.com