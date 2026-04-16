# Equipment Tab Module for CEMA HFA Dashboard
# Author: Cavin Otieno

equipmentTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Medical Equipment Availability", style = "color: #28A745; font-weight: bold;"),
      p("Analysis of medical equipment availability and functionality across facilities."),
      tags$hr()
    ),

    div(
      class = "container",
      style = "margin-bottom: 30px;",

      h3("Equipment Availability by Category", icon("stethoscope"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-4",
            div(class = "panel panel-success",
                div(class = "panel-heading", "Diagnostic Equipment"),
                div(class = "panel-body",
                    plotlyOutput(ns("diagnostic_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-success",
                div(class = "panel-heading", "Patient Monitoring"),
                div(class = "panel-body",
                    plotlyOutput(ns("monitoring_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-success",
                div(class = "panel-heading", "Surgical Equipment"),
                div(class = "panel-body",
                    plotlyOutput(ns("surgical_chart")))))
      ),

      div(
        class = "row",
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Laboratory Equipment"),
                div(class = "panel-body",
                    plotlyOutput(ns("lab_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Imaging Equipment"),
                div(class = "panel-body",
                    plotlyOutput(ns("imaging_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "IT Infrastructure"),
                div(class = "panel-body",
                    plotlyOutput(ns("it_chart")))))
      ),

      tags$hr(),

      h3("Equipment Functionality Rate", icon("check-circle"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    plotlyOutput(ns("functionality_chart"), height = "400px"))))
      ),

      tags$hr(),

      h3("Equipment Availability by Facility Level", icon("layer-group"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    plotlyOutput(ns("level_equipment_chart"), height = "400px"))))
      )
    )
  )
}

equipmentTabServer <- function(id, census_data, county_list) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$diagnostic_chart <- renderPlotly({
      diagnostic_data <- data.frame(
        equipment = c("Stethoscope", "BP Monitor", "Thermometer", "Weighing Scale", "Height Board"),
        available = c(95, 88, 92, 90, 85),
        functional = c(92, 82, 88, 85, 80)
      )

      plot_ly(diagnostic_data, x = ~equipment, y = ~available, type = "bar",
              name = "Available", marker = list(color = "#28A745")) %>%
        add_trace(y = ~functional, name = "Functional", marker = list(color = "#2E86AB")) %>%
        layout(title = "Diagnostic Equipment",
               yaxis = list(title = "Percentage (%)"),
               barmode = "group")
    })

    output$monitoring_chart <- renderPlotly({
      monitoring_data <- data.frame(
        equipment = c("Pulse Oximeter", "Thermometer", "Glucometer", "BP Apparatus"),
        percentage = c(78, 92, 65, 85)
      )

      plot_ly(monitoring_data, x = ~equipment, y = ~percentage, type = "bar",
              marker = list(color = "#28A745"),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "Patient Monitoring Equipment",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage Available (%)"))
    })

    output$surgical_chart <- renderPlotly({
      surgical_data <- data.frame(
        equipment = c("Operating Table", "Surgical Lights", "Anaesthesia Machine", "Sterilizer"),
        percentage = c(55, 58, 42, 68)
      )

      plot_ly(surgical_data, x = ~equipment, y = ~percentage, type = "bar",
              marker = list(color = "#A23B72"),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "Surgical Equipment",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage Available (%)"))
    })

    output$lab_chart <- renderPlotly({
      lab_data <- data.frame(
        equipment = c("Microscope", "Centrifuge", "Analyzer", "Incubator"),
        percentage = c(72, 58, 45, 35)
      )

      plot_ly(lab_data, x = ~equipment, y = ~percentage, type = "bar",
              marker = list(color = "#F18F01"),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "Laboratory Equipment",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage Available (%)"))
    })

    output$imaging_chart <- renderPlotly({
      imaging_data <- data.frame(
        equipment = c("X-Ray", "Ultrasound", "ECG", "CT Scan"),
        percentage = c(38, 52, 45, 12)
      )

      plot_ly(imaging_data, x = ~equipment, y = ~percentage, type = "bar",
              marker = list(color = "#9575CD"),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "Imaging Equipment",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage Available (%)"))
    })

    output$it_chart <- renderPlotly({
      it_data <- data.frame(
        equipment = c("Computer", "Printer", "Internet", "HIS/EMR"),
        percentage = c(62, 48, 42, 18)
      )

      plot_ly(it_data, x = ~equipment, y = ~percentage, type = "bar",
              marker = list(color = "#00ACC1"),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "IT Infrastructure",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage Available (%)"))
    })

    output$functionality_chart <- renderPlotly({
      functionality_data <- data.frame(
        category = c("Diagnostic", "Monitoring", "Surgical", "Laboratory", "Imaging", "IT"),
        avg_functionality = c(87, 82, 68, 72, 75, 78),
        min_level = c(65, 60, 40, 50, 35, 55),
        max_level = c(98, 95, 90, 92, 88, 92)
      )

      plot_ly(functionality_data, x = ~category, y = ~avg_functionality, type = "scatter",
              mode = "lines+markers",
              error_y = list(type = "array",
                            symmetric = FALSE,
                            array = ~max_level - avg_functionality,
                            arrayminus = ~avg_functionality - min_level,
                            color = "#2E86AB")) %>%
        layout(title = "Equipment Functionality Rate by Category",
               xaxis = list(title = "Equipment Category"),
               yaxis = list(title = "Functionality Rate (%)"))
    })

    output$level_equipment_chart <- renderPlotly({
      level_equipment <- data.frame(
        level = c("Level 2", "Level 3", "Level 4", "Level 5", "Level 6"),
        basic = c(85, 90, 92, 95, 98),
        advanced = c(20, 35, 55, 75, 92)
      )

      plot_ly(level_equipment, x = ~level, y = ~basic, type = "bar",
              name = "Basic Equipment", marker = list(color = "#28A745")) %>%
        add_trace(y = ~advanced, name = "Advanced Equipment", marker = list(color = "#2E86AB")) %>%
        layout(title = "Equipment Availability by Facility Level",
               xaxis = list(title = "Facility Level"),
               yaxis = list(title = "Percentage Available (%)"),
               barmode = "group")
    })
  })
}