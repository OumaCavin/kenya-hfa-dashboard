# Kenya Health Facility Assessment App - API Documentation

## Overview

This document describes the data structures and internal APIs used in the Kenya HFA Shiny application.

## Data Structures

### Facility Census Data

```csv
facility_id,facility_name,county,facility_type,ownership,beds,staff_count,date_collected
```

| Field | Type | Description |
|-------|------|-------------|
| facility_id | string | Unique identifier |
| facility_name | string | Name of health facility |
| county | string | County location |
| facility_type | enum | Hospital, Health Center, Dispensary, Clinic |
| ownership | enum | Public, Private, FBO |
| beds | integer | Number of beds |
| staff_count | integer | Number of staff |
| date_collected | date | Assessment date |

### Quality of Care Data

```csv
assessment_id,facility_id,quality_indicator,score,date_assessed
```

| Field | Type | Description |
|-------|------|-------------|
| assessment_id | string | Unique assessment ID |
| facility_id | string | Facility reference |
| quality_indicator | string | Indicator name |
| score | numeric | Quality score (0-100) |
| date_assessed | date | Assessment date |

## R Functions API

### Data Loading

#### `load_census_data(file_path)`
- **Purpose**: Load census data from CSV
- **Parameters**: `file_path` - path to CSV file
- **Returns**: tibble with census data

#### `load_qoc_data(file_path)`
- **Purpose**: Load quality of care data
- **Parameters**: `file_path` - path to CSV file
- **Returns**: tibble with QoC data

### Chart Generation

#### `create_facility_summary_chart(data)`
- **Purpose**: Generate facility summary visualization
- **Parameters**: `data` - census tibble
- **Returns**: plotly object

#### `create_quality_heatmap(data)`
- **Purpose**: Create quality indicator heatmap
- **Parameters**: `data` - QoC tibble
- **Returns**: plotly heatmap object

### Table Rendering

#### `render_facility_table(data, filters)`
- **Purpose**: Create interactive data table
- **Parameters**:
  - `data` - facility tibble
  - `filters` - list of filter conditions
- **Returns**: DT::datatable object

## Shiny Module API

### censusTabUI(id)
- **Purpose**: Create census tab UI elements
- **Parameters**: `id` - module namespace ID
- **Returns**: Shiny tagList

### censusTabServer(id, data)
- **Purpose**: Census tab server logic
- **Parameters**:
  - `id` - module namespace ID
  - `data` - reactive census data
- **Returns**: list of reactive values

### qocTabUI(id)
- **Purpose**: Create QoC tab UI elements
- **Parameters**: `id` - module namespace ID
- **Returns**: Shiny tagList

### qocTabServer(id, data)
- **Purpose**: QoC tab server logic
- **Parameters**:
  - `id` - module namespace ID
  - `data` - reactive QoC data
- **Returns**: list of reactive values

## Configuration

### App Configuration (config.yml)
```yaml
app:
  title: "Kenya Health Facility Assessment"
  version: "1.0.0"

data:
  census_file: "data/sample_census.csv"
  qoc_file: "data/sample_qoc.csv"

display:
  default_county: "All"
  chart_height: 500
```

## Author

Cavin Otieno
GitHub: OumaCavin
Email: cavin.otieno012@gmail.com