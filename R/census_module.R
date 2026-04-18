# Census Tab UI Module for Kenya HFA App
# Author: Cavin Otieno

censusTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    # Page header
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Kenya Health Facility Census", style = "color: #2E86AB; font-weight: bold;"),
      p("Analysis of health facility census data from August 2023 assessment covering all Public, Private, and Faith-Based-Organization health facilities."),
      tags$hr()
    ),

    # Filters section
    div(
      class = "container",
      style = "background-color: #F8F9FA; padding: 20px; border-radius: 10px; margin-bottom: 20px;",
      h4("Filter Data", icon("filter"), style = "margin-bottom: 15px;"),
      div(
        class = "row",
        div(class = "col-md-4", selectInput(ns("county_filter"), "County", c("All" = "All"), selected = "All")),
        div(class = "col-md-4", selectInput(ns("type_filter"), "Facility Type", c("All" = "All"), selected = "All")),
        div(class = "col-md-4", selectInput(ns("ownership_filter"), "Ownership", c("All" = "All"), selected = "All"))
      )
    ),

    # Summary statistics
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Summary Statistics", icon("chart-bar"), style = "margin-bottom: 15px;"),
      div(
        class = "row",
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E3F2FD;",
                h5("Total Facilities", style = "color: #1565C0;"),
                h3(textOutput(ns("total_facilities")), style = "color: #1565C0;")
            )
        ),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #F3E5F5;",
                h5("Total Counties", style = "color: #7B1FA2;"),
                h3(textOutput(ns("total_counties")), style = "color: #7B1FA2;")
            )
        ),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #FFF3E0;",
                h5("Total Beds", style = "color: #E65100;"),
                h3(textOutput(ns("total_beds")), style = "color: #E65100;")
            )
        ),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E8F5E9;",
                h5("Total Staff", style = "color: #2E7D32;"),
                h3(textOutput(ns("total_staff")), style = "color: #2E7D32;")
            )
        )
      )
    ),

    # Charts section
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Facility Distribution", icon("chart-pie"), style = "margin-bottom: 15px;"),
      div(
        class = "row",
        div(class = "col-md-6", plotlyOutput(ns("facility_type_pie"))),
        div(class = "col-md-6", plotlyOutput(ns("ownership_bar")))
      )
    ),

    # County distribution
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("County Distribution", icon("map-marker-alt"), style = "margin-bottom: 15px;"),
      div(class = "row",
          div(class = "col-12", plotlyOutput(ns("county_bar")))
      )
    ),

    # Data table
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Facility Data", icon("table"), style = "margin-bottom: 15px;"),
      DT::dataTableOutput(ns("facility_table"))
    ),

    # Download button
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      downloadButton(ns("download_data"), "Download Census Data (CSV)",
                     class = "btn btn-primary")
    )
  )
}