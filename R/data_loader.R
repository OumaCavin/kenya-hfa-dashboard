# Data loading utilities for Kenya HFA App
# Author: Cavin Otieno

#' Load census data from CSV file with error handling
#' @param file_path Path to the census CSV file
#' @param cache Optional cache object for performance
#' @return tibble with census data or NULL on error
load_census_data <- function(file_path = "data/sample_census.csv", cache = NULL) {
  tryCatch({
    # Check cache if provided
    if (!is.null(cache) && !is.null(cache$get(file_path))) {
      logger$debug(paste("Cache hit for", file_path))
      return(cache$get(file_path))
    }

    # Load data
    if (!file.exists(file_path)) {
      logger$warn(paste("Census file not found:", file_path))
      return(NULL)
    }

    data <- read.csv(file_path, comment.char = "#", stringsAsFactors = FALSE)
    logger$info(paste("Loaded census data:", nrow(data), "rows"))

    # Store in cache if provided
    if (!is.null(cache)) {
      cache$set(file_path, data)
    }

    data
  }, error = function(e) {
    logger$error(paste("Failed to load census data:", e$message))
    NULL
  })
}

#' Load quality of care data from CSV file with error handling
#' @param file_path Path to the QoC CSV file
#' @param cache Optional cache object for performance
#' @return tibble with QoC data or NULL on error
load_qoc_data <- function(file_path = "data/sample_qoc.csv", cache = NULL) {
  tryCatch({
    # Check cache if provided
    if (!is.null(cache) && !is.null(cache$get(file_path))) {
      logger$debug(paste("Cache hit for", file_path))
      return(cache$get(file_path))
    }

    # Load data
    if (!file.exists(file_path)) {
      logger$warn(paste("QoC file not found:", file_path))
      return(NULL)
    }

    data <- read.csv(file_path, comment.char = "#", stringsAsFactors = FALSE)
    logger$info(paste("Loaded QoC data:", nrow(data), "rows"))

    # Store in cache if provided
    if (!is.null(cache)) {
      cache$set(file_path, data)
    }

    data
  }, error = function(e) {
    logger$error(paste("Failed to load QoC data:", e$message))
    NULL
  })
}

#' Get summary statistics for census data
#' @param data Census tibble
#' @return List of summary statistics
get_census_summary <- function(data) {
  if (is.null(data) || nrow(data) == 0) {
    return(list(
      total_facilities = 0,
      total_counties = 0,
      public_facilities = 0,
      private_facilities = 0,
      fbo_facilities = 0,
      total_beds = 0,
      total_staff = 0
    ))
  }

  list(
    total_facilities = nrow(data),
    total_counties = length(unique(data$county)),
    public_facilities = sum(data$ownership == "Public", na.rm = TRUE),
    private_facilities = sum(data$ownership == "Private", na.rm = TRUE),
    fbo_facilities = sum(data$ownership == "FBO", na.rm = TRUE),
    total_beds = sum(data$beds, na.rm = TRUE),
    total_staff = sum(data$staff_count, na.rm = TRUE)
  )
}

#' Get summary statistics for QoC data
#' @param data QoC tibble
#' @return List of summary statistics
get_qoc_summary <- function(data) {
  if (is.null(data) || nrow(data) == 0) {
    return(list(
      total_assessments = 0,
      total_facilities = 0,
      avg_score = 0,
      facilities_above_80 = 0,
      facilities_below_50 = 0
    ))
  }

  list(
    total_assessments = nrow(data),
    total_facilities = length(unique(data$facility_id)),
    avg_score = mean(data$score, na.rm = TRUE),
    facilities_above_80 = sum(data$score >= 80, na.rm = TRUE),
    facilities_below_50 = sum(data$score < 50, na.rm = TRUE)
  )
}

#' Filter census data by county with error handling
#' @param data Census tibble
#' @param county County name or "All" for all counties
#' @return Filtered tibble
filter_by_county <- function(data, county = "All") {
  if (is.null(data)) return(NULL)
  if (county == "All" || county == "") {
    return(data)
  }
  tryCatch({
    data %>% filter(county == county)
  }, error = function(e) {
    logger$error(paste("Filter by county failed:", e$message))
    data
  })
}

#' Filter census data by facility type with error handling
#' @param data Census tibble
#' @param type Facility type or "All" for all types
#' @return Filtered tibble
filter_by_facility_type <- function(data, type = "All") {
  if (is.null(data)) return(NULL)
  if (type == "All" || type == "") {
    return(data)
  }
  tryCatch({
    data %>% filter(facility_type == type)
  }, error = function(e) {
    logger$error(paste("Filter by facility type failed:", e$message))
    data
  })
}

#' Filter census data by ownership with error handling
#' @param data Census tibble
#' @param ownership Ownership type or "All" for all types
#' @return Filtered tibble
filter_by_ownership <- function(data, ownership = "All") {
  if (is.null(data)) return(NULL)
  if (ownership == "All" || ownership == "") {
    return(data)
  }
  tryCatch({
    data %>% filter(ownership == ownership)
  }, error = function(e) {
    logger$error(paste("Filter by ownership failed:", e$message))
    data
  })
}

#' Export data to CSV with error handling
#' @param data Data frame to export
#' @param filename Output filename
#' @return TRUE on success, FALSE on failure
export_to_csv <- function(data, filename = "export.csv") {
  tryCatch({
    write.csv(data, filename, row.names = FALSE)
    logger$info(paste("Exported data to", filename))
    TRUE
  }, error = function(e) {
    logger$error(paste("Export failed:", e$message))
    FALSE
  })
}