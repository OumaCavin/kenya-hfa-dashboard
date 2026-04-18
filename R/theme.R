# Custom theme definitions for Kenya HFA App
# Author: Cavin Otieno

# Define custom color palette
hfa_colors <- c(
  primary = "#2E86AB",      # Blue
  secondary = "#A23B72",    # Purple
  accent = "#F18F01",       # Orange
  warning = "#C73E1D",      # Red
  success = "#28A745",      # Green
  dark = "#343A40",         # Dark gray
  light = "#F8F9FA"         # Light gray
)

# Custom ggplot2 theme
hfa_theme <- function() {
  theme_minimal() %+replace%
    theme(
      plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 12, hjust = 0.5),
      axis.title = element_text(size = 12, face = "bold"),
      axis.text = element_text(size = 10),
      legend.title = element_text(size = 12, face = "bold"),
      legend.text = element_text(size = 10),
      panel.grid.major = element_line(color = "#E9ECEF"),
      panel.grid.minor = element_line(color = "#F8F9FA")
    )
}

# Shiny dashboard header styling
hfa_header <- function(title) {
  tags$div(
    class = "container-fluid",
    style = "background-color: #2E86AB; padding: 15px; color: white; margin-bottom: 20px;",
    tags$h2(title, style = "margin: 0; font-weight: bold;")
  )
}

# Info card component
hfa_info_card <- function(title, value, icon = NULL, color = "#2E86AB") {
  tags$div(
    class = "col-md-3 col-sm-6",
    style = "padding: 10px;",
    tags$div(
      class = "panel panel-default",
      style = paste0("border-left: 4px solid ", color, ";"),
      tags$div(
        class = "panel-body",
        tags$p(title, style = "color: #6C757D; margin: 0; font-size: 14px;"),
        tags$h3(value, style = "margin: 5px 0; font-weight: bold;")
      )
    )
  )
}

# Section header component
hfa_section_header <- function(title, icon = NULL) {
  tags$div(
    style = "margin: 20px 0; padding-bottom: 10px; border-bottom: 2px solid #2E86AB;",
    if (!is.null(icon)) icon,
    tags$h4(title, style = "display: inline; margin-left: 10px;")
  )
}

# Filter panel component
hfa_filter_panel <- function(id, label, choices, selected = "All") {
  selectInput(inputId = id, label = label, choices = choices, selected = selected)
}