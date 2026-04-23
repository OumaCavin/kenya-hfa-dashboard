# Summary Tab UI Module for CEMA HFA Dashboard
# Author: Cavin Otieno

summaryTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Kenya Health Facility Census - Summary", style = "color: #2E86AB; font-weight: bold;"),
      p("This dashboard contains the analysis of data from the Kenya Health Facility Census Assessment conducted by the Ministry of Health in August 2023. The assessment covers all Public, Private and Faith-Based-Organization health facilities."),
      tags$hr()
    ),

    div(
      class = "container",
      style = "margin-bottom: 30px;",

      div(
        class = "row",
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E3F2FD;",
                h5("Total Facilities", style = "color: #1565C0;"),
                h3("12,375", style = "color: #1565C0;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #F3E5F5;",
                h5("Outpatient Services", style = "color: #7B1FA2;"),
                h3("91%", style = "color: #7B1FA2;"),
                h6("(11,213 facilities)", style = "color: #7B1FA2;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #FFF3E0;",
                h5("Basic Maternity", style = "color: #E65100;"),
                h3("40%", style = "color: #E65100;"),
                h6("(4,960 facilities)", style = "color: #E65100;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E8F5E9;",
                h5("Counties Covered", style = "color: #2E7D32;"),
                h3("47", style = "color: #2E7D32;")))
      ),

      tags$hr(),

      h3("Service Readiness Overview", style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-4",
            div(class = "panel panel-default",
                h5("Outpatient Services"),
                tags$div(class = "progress", style = "height: 20px;",
                         tags$div(class = "progress-bar bg-primary", style = "width: 91%;", "91%"),
                         tags$div(class = "progress-bar bg-success", style = "width: 7%;", "7%")))),
        div(class = "col-md-4",
            div(class = "panel panel-default",
                h5("Basic Maternity Services"),
                tags$div(class = "progress", style = "height: 20px;",
                         tags$div(class = "progress-bar bg-primary", style = "width: 40%;", "40%"),
                         tags$div(class = "progress-bar bg-success", style = "width: 18%;", "18%")))),
        div(class = "col-md-4",
            div(class = "panel panel-default",
                h5("Comprehensive Maternity"),
                tags$div(class = "progress", style = "height: 20px;",
                         tags$div(class = "progress-bar bg-primary", style = "width: 7%;", "7%"),
                         tags$div(class = "progress-bar bg-success", style = "width: 28%;", "28%"))))
      ),

      tags$hr(),

      h3("Facility Distribution", style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Facilities by Ownership"),
                div(class = "panel-body",
                    plotlyOutput(ns("ownership_chart"))))),
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Facilities by Level of Care"),
                div(class = "panel-body",
                    plotlyOutput(ns("level_chart")))))
      ),

      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Number of Facilities per County"),
                div(class = "panel-body",
                    plotlyOutput(ns("county_chart"), height = "500px"))))
      )
    )
  )
}

# Summary Tab Server Module
summaryTabServer <- function(id, census_data, county_list, facility_types, ownership_types) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$ownership_chart <- renderPlotly({
      ownership_data <- data.frame(
        ownership = c("Government/Public", "Private", "Faith Based", "NGO"),
        count = c(6500, 3500, 2000, 375)
      )

      plot_ly(ownership_data, labels = ~ownership, values = ~count, type = "pie",
              marker = list(colors = c("#2E86AB", "#A23B72", "#F18F01", "#28A745")),
              textinfo = "label+percent",
              hoverinfo = "label+percent+value") %>%
        layout(title = "Facility Ownership Distribution")
    })

    output$level_chart <- renderPlotly({
      level_data <- data.frame(
        level = c("Level 2", "Level 3", "Level 4", "Level 5", "Level 6"),
        count = c(5500, 4000, 2000, 800, 75)
      )

      plot_ly(level_data, labels = ~level, values = ~count, type = "pie",
              marker = list(colors = c("#E3F2FD", "#F3E5F5", "#FFF3E0", "#E8F5E9", "#FFCDD2")),
              textinfo = "label+percent",
              hoverinfo = "label+percent+value") %>%
        layout(title = "Facility Level Distribution")
    })

    output$county_chart <- renderPlotly({
      county_data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma",
                   "Uasin Gishu", "Meru", "Kiambu", "Machakos", "Other Counties"),
        count = c(950, 720, 580, 520, 480, 450, 420, 380, 350, 340, 5685)
      )

      plot_ly(county_data, x = ~reorder(county, count), y = ~count, type = "bar",
              orientation = "h",
              marker = list(color = "#2E86AB"),
              text = ~count,
              textposition = "auto") %>%
        layout(title = "Number of Health Facilities per County",
               xaxis = list(title = "Number of Facilities"),
               yaxis = list(title = "County"),
               margin = list(l = 150))
    })
  })
}
