# Common UI Components for CEMA HFA Dashboard
# Author: Cavin Otieno

#' Create common filter panel used across all tabs
createFilterPanel <- function(ns, show_level_filter = TRUE, show_county_filter = TRUE,
                              show_ownership_filter = TRUE, show_scope_filter = FALSE) {
  tagList(
    div(
      class = "container",
      style = "background-color: #F8F9FA; padding: 20px; border-radius: 10px; margin-bottom: 20px;",
      h4("Filter Data", icon("filter"), style = "margin-bottom: 15px;"),
      div(
        class = "row",
        if (show_level_filter) {
          div(class = "col-md-3",
              selectInput(ns("level_filter"), "Facility Level",
                          choices = c("All Levels" = "All", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6")))
        },
        if (show_county_filter) {
          div(class = "col-md-3",
              selectInput(ns("county_filter"), "County",
                          choices = c("All Counties" = "All")))
        },
        if (show_ownership_filter) {
          div(class = "col-md-3",
              selectInput(ns("ownership_filter"), "Ownership",
                          choices = c("All" = "All", "Government/Public" = "Public", "Private" = "Private", "Faith Based" = "FBO", "NGO" = "NGO")))
        },
        if (show_scope_filter) {
          div(class = "col-md-3",
              radioButtons(ns("scope_filter"), "Scope",
                          choices = c("National" = "national", "County" = "county"),
                          selected = "national", inline = TRUE))
        }
      )
    )
  )
}

#' Create summary statistics cards row
createSummaryStatsCards <- function(ns) {
  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Key Statistics", icon("chart-bar"), style = "margin-bottom: 15px;"),
      div(
        class = "row",
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E3F2FD;",
                h5("Total Facilities", style = "color: #1565C0;"),
                h3(textOutput(ns("total_facilities")), style = "color: #1565C0;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #F3E5F5;",
                h5("Total Counties", style = "color: #7B1FA2;"),
                h3(textOutput(ns("total_counties")), style = "color: #7B1FA2;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #FFF3E0;",
                h5("Total Beds", style = "color: #E65100;"),
                h3(textOutput(ns("total_beds")), style = "color: #E65100;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E8F5E9;",
                h5("Total Staff", style = "color: #2E7D32;"),
                h3(textOutput(ns("total_staff")), style = "color: #2E7D32;")))
      )
    )
  )
}

#' Create chart container
createChartContainer <- function(chart_output, title = NULL) {
  tagList(
    if (!is.null(title)) {
      h4(title, style = "margin-bottom: 15px;")
    },
    div(
      class = "chart-container",
      chart_output
    )
  )
}

#' Section header with icon
createSectionHeader <- function(title, icon_name = "chart-bar") {
  tags$div(
    style = "margin: 20px 0; padding-bottom: 10px; border-bottom: 2px solid #2E86AB;",
    h4(icon(icon_name), title, style = "display: inline; margin-left: 10px;")
  )
}