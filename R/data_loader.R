# Data loading utilities for Kenya HFA App
# Author: Cavin Otieno

#' Load census data from CSV file
#' @param file_path Path to the census CSV file
#' @return tibble with census data
load_census_data <- function(file_path = "data/sample_census.csv") {
  read.csv(file_path, stringsAsFactors = FALSE)
}

#' Load quality of care data from CSV file
#' @param file_path Path to the QoC CSV file
#' @return tibble with QoC data
load_qoc_data <- function(file_path = "data/sample_qoc.csv") {
  read.csv(file_path, stringsAsFactors = FALSE)
}

#' Get summary statistics for census data
#' @param data Census tibble
#' @return List of summary statistics
get_census_summary <- function(data) {
  list(
    total_facilities = nrow(data),
    total_counties = length(unique(data$county)),
    public_facilities = sum(data$ownership == "Public"),
    private_facilities = sum(data$ownership == "Private"),
    fbo_facilities = sum(data$ownership == "FBO"),
    total_beds = sum(data$beds, na.rm = TRUE),
    total_staff = sum(data$staff_count, na.rm = TRUE)
  )
}

#' Get summary statistics for QoC data
#' @param data QoC tibble
#' @return List of summary statistics
get_qoc_summary <- function(data) {
  list(
    total_assessments = nrow(data),
    total_facilities = length(unique(data$facility_id)),
    avg_score = mean(data$score, na.rm = TRUE),
    facilities_above_80 = sum(data$score >= 80, na.rm = TRUE),
    facilities_below_50 = sum(data$score < 50, na.rm = TRUE)
  )
}

#' Filter census data by county
#' @param data Census tibble
#' @param county County name or "All" for all counties
#' @return Filtered tibble
filter_by_county <- function(data, county = "All") {
  if (county == "All") {
    return(data)
  }
  data %>% filter(county == county)
}

#' Filter census data by facility type
#' @param data Census tibble
#' @param type Facility type or "All" for all types
#' @return Filtered tibble
filter_by_facility_type <- function(data, type = "All") {
  if (type == "All") {
    return(data)
  }
  data %>% filter(facility_type == type)
}

#' Filter census data by ownership
#' @param data Census tibble
#' @param ownership Ownership type or "All" for all types
#' @return Filtered tibble
filter_by_ownership <- function(data, ownership = "All") {
  if (ownership == "All") {
    return(data)
  }
  data %>% filter(ownership == ownership)
}