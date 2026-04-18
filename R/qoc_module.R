# QoC Tab UI Module for Kenya HFA App
# Author: Cavin Otieno

qocTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    # Page header
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Kenya Quality of Care Assessment", style = "color: #A23B72; font-weight: bold;"),
      p("Analysis of quality of care assessment data from March 2024 assessment covering health facility quality metrics."),
      tags$hr()
    ),

    # Filters section
    div(
      class = "container",
      style = "background-color: #F8F9FA; padding: 20px; border-radius: 10px; margin-bottom: 20px;",
      h4("Filter Data", icon("filter"), style = "margin-bottom: 15px;"),
      div(
        class = "row",
        div(class = "col-md-6", selectInput(ns("county_filter"), "County", c("All" = "All"), selected = "All")),
        div(class = "col-md-6", selectInput(ns("indicator_filter"), "Quality Indicator", c("All" = "All"), selected = "All"))
      )
    ),

    # Summary statistics
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Quality Summary", icon("heartbeat"), style = "margin-bottom: 15px;"),
      div(
        class = "row",
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E8F5E9;",
                h5("Total Assessments", style = "color: #2E7D32;"),
                h3(textOutput(ns("total_assessments")), style = "color: #2E7D32;")
            )
        ),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E3F2FD;",
                h5("Facilities Assessed", style = "color: #1565C0;"),
                h3(textOutput(ns("facilities_count")), style = "color: #1565C0;")
            )
        ),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #FFF3E0;",
                h5("Average Score", style = "color: #E65100;"),
                h3(textOutput(ns("avg_score")), style = "color: #E65100;")
            )
        ),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #FCE4EC;",
                h5("Facilities >80%", style = "color: #C2185B;"),
                h3(textOutput(ns("high_performers")), style = "color: #C2185B;")
            )
        )
      )
    ),

    # Score distribution
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Score Distribution", icon("chart-bar"), style = "margin-bottom: 15px;"),
      div(class = "row",
          div(class = "col-12", plotlyOutput(ns("score_histogram")))
      )
    ),

    # Indicator comparison
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Indicator Performance", icon("trophy"), style = "margin-bottom: 15px;"),
      div(class = "row",
          div(class = "col-12", plotlyOutput(ns("indicator_chart")))
      )
    ),

    # Performance by facility
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Facility Performance", icon("hospital"), style = "margin-bottom: 15px;"),
      div(class = "row",
          div(class = "col-12", plotlyOutput(ns("performance_scatter")))
      )
    ),

    # Data table
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h4("Assessment Data", icon("table"), style = "margin-bottom: 15px;"),
      DT::dataTableOutput(ns("qoc_table"))
    ),

    # Download button
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      downloadButton(ns("download_qoc"), "Download QoC Data (CSV)",
                    class = "btn btn-success")
    )
  )
}