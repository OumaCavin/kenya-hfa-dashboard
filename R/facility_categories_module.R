# Facility Categories Tab Module for CEMA HFA Dashboard
# Author: Cavin Otieno

facilityCategoriesTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Facility Categories", style = "color: #2E86AB; font-weight: bold;"),
      p("Detailed analysis of health facility types and categories."),
      tags$hr()
    ),

    div(
      class = "container",
      style = "margin-bottom: 30px;",

      h3("Facility Types Overview", icon("hospital"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Facilities by Type"),
                div(class = "panel-body",
                    plotlyOutput(ns("facility_types_chart"))))),
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Bed Capacity Distribution"),
                div(class = "panel-body",
                    plotlyOutput(ns("bed_capacity_chart")))))
      ),

      tags$hr(),

      h3("Level of Care Distribution", icon("layer-group"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Level 2 - Dispensaries"),
                div(class = "panel-body",
                    plotlyOutput(ns("level2_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Level 3 - Health Centers"),
                div(class = "panel-body",
                    plotlyOutput(ns("level3_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Level 4-6 Hospitals"),
                div(class = "panel-body",
                    plotlyOutput(ns("level4_chart")))))
      ),

      tags$hr(),

      h3("Service Capacity Comparison", icon("chart-line"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    plotlyOutput(ns("capacity_comparison_chart"), height = "400px"))))
      ),

      tags$hr(),

      h3("Category Details", icon("info-circle"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    dataTableOutput(ns("category_table")))))
      )
    )
  )
}

facilityCategoriesTabServer <- function(id, census_data, county_list) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$facility_types_chart <- renderPlotly({
      types_data <- data.frame(
        type = c("Dispensary", "Health Center", "Nursing Home", "District Hospital",
                 "Provincial Hospital", "National Hospital"),
        count = c(5500, 4000, 1500, 900, 350, 125)
      )

      plot_ly(types_data, labels = ~type, values = ~count, type = "pie",
              marker = list(colors = c("#E3F2FD", "#F3E5F5", "#FFF3E0", "#E8F5E9", "#FFCDD2", "#D1C4E9")),
              textinfo = "label+percent",
              hoverinfo = "label+percent+value") %>%
        layout(title = "Facilities by Type")
    })

    output$bed_capacity_chart <- renderPlotly({
      capacity_data <- data.frame(
        category = c("0-10 beds", "11-30 beds", "31-50 beds", "51-100 beds", "100+ beds"),
        facilities = c(4200, 3800, 2200, 1500, 675)
      )

      plot_ly(capacity_data, x = ~category, y = ~facilities, type = "bar",
              marker = list(color = "#2E86AB"),
              text = ~facilities,
              textposition = "auto") %>%
        layout(title = "Facilities by Bed Capacity",
               xaxis = list(title = "Bed Capacity"),
               yaxis = list(title = "Number of Facilities"))
    })

    output$level2_chart <- renderPlotly({
      level2_data <- data.frame(
        service = c("Outpatient", "Pharmacy", "MCH", "Lab"),
        availability = c(98, 85, 90, 45)
      )

      plot_ly(level2_data, x = ~service, y = ~availability, type = "bar",
              marker = list(color = "#2E86AB"),
              text = ~paste0(availability, "%"),
              textposition = "auto") %>%
        layout(title = "Level 2 Services",
               xaxis = list(title = ""),
               yaxis = list(title = "Availability (%)"))
    })

    output$level3_chart <- renderPlotly({
      level3_data <- data.frame(
        service = c("Inpatient", "Maternity", "Lab", "Imaging", "Dental"),
        availability = c(92, 78, 72, 35, 28)
      )

      plot_ly(level3_data, x = ~service, y = ~availability, type = "bar",
              marker = list(color = "#A23B72"),
              text = ~paste0(availability, "%"),
              textposition = "auto") %>%
        layout(title = "Level 3 Services",
               xaxis = list(title = ""),
               yaxis = list(title = "Availability (%)"))
    })

    output$level4_chart <- renderPlotly({
      level4_data <- data.frame(
        service = c("Surgery", "ICU", "Emergency", "Blood Bank", "MRI"),
        availability = c(85, 45, 78, 55, 18)
      )

      plot_ly(level4_data, x = ~service, y = ~availability, type = "bar",
              marker = list(color = "#F18F01"),
              text = ~paste0(availability, "%"),
              textposition = "auto") %>%
        layout(title = "Level 4-6 Hospital Services",
               xaxis = list(title = ""),
               yaxis = list(title = "Availability (%)"))
    })

    output$capacity_comparison_chart <- renderPlotly({
      comparison_data <- data.frame(
        level = c("Level 2", "Level 3", "Level 4", "Level 5", "Level 6"),
        avg_beds = c(8, 25, 85, 200, 450),
        avg_staff = c(12, 35, 120, 280, 650),
        avg_services = c(4, 8, 15, 25, 40)
      )

      plot_ly(comparison_data, x = ~level, y = ~avg_beds, type = "bar",
              name = "Average Beds", marker = list(color = "#2E86AB")) %>%
        add_trace(y = ~avg_staff / 2, name = "Avg Staff (x0.5)", marker = list(color = "#A23B72")) %>%
        add_trace(y = ~avg_services * 5, name = "Avg Services (x5)", marker = list(color = "#F18F01")) %>%
        layout(title = "Facility Capacity Comparison by Level",
               xaxis = list(title = "Facility Level"),
               yaxis = list(title = "Value"),
               barmode = "group")
    })

    output$category_table <- renderDataTable({
      category_df <- data.frame(
        Category = c("Dispensary", "Health Center", "Nursing Home", "District Hospital",
                     "Provincial Hospital", "National Hospital", "Specialized Clinic"),
        Level = c("Level 2", "Level 3", "Level 3-4", "Level 4", "Level 5", "Level 6", "Level 3-5"),
        Count = c(5500, 4000, 1500, 900, 350, 125, 800),
        Avg_Beds = c(6, 20, 45, 85, 180, 420, 25),
        Avg_Staff = c(10, 32, 65, 110, 250, 580, 40),
        stringsAsFactors = FALSE
      )
      datatable(category_df, options = list(pageLength = 10, dom = 'tip'))
    })
  })
}