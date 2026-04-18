# Chart helper functions for Kenya HFA App
# Author: Cavin Otieno

#' Create facility type distribution pie chart
#' @param data Census tibble
#' @return plotly pie chart
create_facility_type_pie <- function(data) {
  type_counts <- data %>%
    count(facility_type) %>%
    filter(!is.na(facility_type))

  plot_ly(type_counts, labels = ~facility_type, values = ~n, type = "pie",
          marker = list(colors = c("#2E86AB", "#A23B72", "#F18F01", "#C73E1D")),
          textinfo = "label+percent",
          hoverinfo = "label+percent+value") %>%
    layout(title = "Facilities by Type",
           margin = list(t = 50, b = 50))
}

#' Create ownership distribution bar chart
#' @param data Census tibble
#' @return plotly bar chart
create_ownership_bar <- function(data) {
  ownership_counts <- data %>%
    count(ownership) %>%
    filter(!is.na(ownership))

  plot_ly(ownership_counts, x = ~ownership, y = ~n, type = "bar",
          color = ~ownership,
          colors = c("#2E86AB", "#A23B72", "#F18F01"),
          text = ~n,
          textposition = "auto") %>%
    layout(title = "Facilities by Ownership",
           xaxis = list(title = "Ownership Type"),
           yaxis = list(title = "Number of Facilities"),
           showlegend = FALSE)
}

#' Create county distribution bar chart
#' @param data Census tibble
#' @param top_n Number of top counties to show
#' @return plotly bar chart
create_county_bar <- function(data, top_n = 10) {
  county_counts <- data %>%
    count(county) %>%
    top_n(top_n, n) %>%
    arrange(desc(n))

  plot_ly(county_counts, x = ~reorder(county, n), y = ~n, type = "bar",
          orientation = "h",
          marker = list(color = "#2E86AB"),
          text = ~n,
          textposition = "auto") %>%
    layout(title = paste0("Top ", top_n, " Counties by Facility Count"),
           xaxis = list(title = "Number of Facilities"),
           yaxis = list(title = "County"),
           margin = list(l = 150))
}

#' Create beds distribution histogram
#' @param data Census tibble
#' @return plotly histogram
create_beds_histogram <- function(data) {
  plot_ly(data, x = ~beds, type = "histogram",
          marker = list(color = "#F18F01"),
          nbinsx = 30) %>%
    layout(title = "Distribution of Bed Capacity",
           xaxis = list(title = "Number of Beds"),
           yaxis = list(title = "Frequency"))
}

#' Create quality score distribution histogram
#' @param data QoC tibble
#' @return plotly histogram
create_qoc_score_histogram <- function(data) {
  plot_ly(data, x = ~score, type = "histogram",
          marker = list(color = "#2E86AB"),
          nbinsx = 20) %>%
    layout(title = "Quality Score Distribution",
           xaxis = list(title = "Quality Score"),
           yaxis = list(title = "Frequency"))
}

#' Create quality indicator comparison bar chart
#' @param data QoC tibble
#' @return plotly bar chart
create_indicator_comparison <- function(data) {
  indicator_avg <- data %>%
    group_by(indicator) %>%
    summarise(avg_score = mean(score, na.rm = TRUE)) %>%
    arrange(desc(avg_score))

  plot_ly(indicator_avg, x = ~avg_score, y = ~reorder(indicator, avg_score),
          type = "bar", orientation = "h",
          marker = list(color = "#A23B72"),
          text = ~round(avg_score, 1),
          textposition = "auto") %>%
    layout(title = "Average Score by Quality Indicator",
           xaxis = list(title = "Average Score"),
           yaxis = list(title = "Indicator"),
           margin = list(l = 200))
}

#' Create facility performance scatter plot
#' @param census_data Census tibble
#' @param qoc_data QoC tibble
#' @return plotly scatter plot
create_performance_scatter <- function(census_data, qoc_data) {
  facility_scores <- qoc_data %>%
    group_by(facility_id) %>%
    summarise(avg_score = mean(score, na.rm = TRUE))

  merged <- merge(census_data, facility_scores, by = "facility_id")

  plot_ly(merged, x = ~beds, y = ~avg_score, color = ~ownership,
          type = "scatter", mode = "markers",
          text = ~paste(facility_name, "<br>Beds:", beds, "<br>Score:", round(avg_score, 1)),
          hoverinfo = "text") %>%
    layout(title = "Facility Size vs Quality Score",
           xaxis = list(title = "Number of Beds"),
           yaxis = list(title = "Average Quality Score"))
}