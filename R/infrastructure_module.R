# Infrastructure Tab Module for CEMA HFA Dashboard
# Author: Cavin Otieno

infrastructureTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Health Facility Infrastructure", style = "color: #2E86AB; font-weight: bold;"),
      p("Analysis of infrastructure availability across health facilities in Kenya."),
      tags$hr()
    ),

    div(
      class = "container",
      style = "margin-bottom: 30px;",

      h3("Infrastructure Categories", icon("building"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Buildings and Structures"),
                div(class = "panel-body",
                    plotlyOutput(ns("buildings_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Utilities"),
                div(class = "panel-body",
                    plotlyOutput(ns("utilities_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Power Supply"),
                div(class = "panel-body",
                    plotlyOutput(ns("power_chart")))))
      ),

      div(
        class = "row",
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Water Supply"),
                div(class = "panel-body",
                    plotlyOutput(ns("water_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Communication"),
                div(class = "panel-body",
                    plotlyOutput(ns("communication_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Waste Management"),
                div(class = "panel-body",
                    plotlyOutput(ns("waste_chart")))))
      ),

      tags$hr(),

      h3("Infrastructure Map", icon("map-marker-alt"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    leafletOutput(ns("infrastructure_map"), height = "500px"))))
      )
    )
  )
}

infrastructureTabServer <- function(id, census_data, county_list) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$buildings_chart <- renderPlotly({
      buildings_data <- data.frame(
        category = c("Permanent Buildings", "Semi-Permanent", "Temporary Structures", "Mixed"),
        percentage = c(72, 15, 5, 8)
      )

      plot_ly(buildings_data, x = ~category, y = ~percentage, type = "bar",
              marker = list(color = c("#2E86AB", "#A23B72", "#F18F01", "#28A745"))) %>%
        layout(title = "Building Types",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage (%)"))
    })

    output$utilities_chart <- renderPlotly({
      utilities_data <- data.frame(
        utility = c("Electricity", "Water", "Internet", "Telephone"),
        available = c(89, 85, 42, 65)
      )

      plot_ly(utilities_data, x = ~utility, y = ~available, type = "bar",
              marker = list(color = "#2E86AB"),
              text = ~paste0(available, "%"),
              textposition = "auto") %>%
        layout(title = "Basic Utilities Availability",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage Available (%)"))
    })

    output$power_chart <- renderPlotly({
      power_data <- data.frame(
        source = c("National Grid", "Generator", "Solar", "None"),
        facilities = c(78, 35, 22, 5)
      )

      plot_ly(power_data, labels = ~source, values = ~facilities, type = "pie",
              marker = list(colors = c("#2E86AB", "#F18F01", "#28A745", "#C73E1D"))) %>%
        layout(title = "Power Source Distribution")
    })

    output$water_chart <- renderPlotly({
      water_data <- data.frame(
        source = c("Piped Water", "Borehole", "Rainwater", "Other"),
        percentage = c(65, 20, 8, 7)
      )

      plot_ly(water_data, labels = ~source, values = ~percentage, type = "pie",
              marker = list(colors = c("#2E86AB", "#A23B72", "#F18F01", "#28A745"))) %>%
        layout(title = "Water Source Distribution")
    })

    output$communication_chart <- renderPlotly({
      comm_data <- data.frame(
        type = c("Mobile Phone", "Internet", "Radio", "Computer"),
        percentage = c(95, 42, 55, 38)
      )

      plot_ly(comm_data, x = ~type, y = ~percentage, type = "bar",
              marker = list(color = "#A23B72"),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "Communication Facilities",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage (%)"))
    })

    output$waste_chart <- renderPlotly({
      waste_data <- data.frame(
        method = c("Incineration", "Open Pit", "Contracted", "None"),
        percentage = c(45, 30, 15, 10)
      )

      plot_ly(waste_data, x = ~method, y = ~percentage, type = "bar",
              marker = list(color = "#28A745"),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "Waste Management Methods",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage (%)"))
    })

    output$infrastructure_map <- renderLeaflet({
      facilities <- data.frame(
        name = c("Kenyatta National Hospital", "Mombasa General Hospital", "Kisumu Level 5",
                 "Nakuru Provincial Hospital", "Kakamega County Hospital"),
        lat = c(-1.2839, -4.0435, -0.0600, -0.3031, 0.2828),
        lng = c(36.8172, 39.6685, 34.7676, 36.0724, 34.7523),
        readiness = c(95, 78, 72, 68, 65)
      )

      leaflet(facilities) %>%
        addTiles() %>%
        addCircleMarkers(~lng, ~lat,
                        popup = ~paste0(name, "<br>Readiness: ", readiness, "%"),
                        radius = 10,
                        color = "#2E86AB")
    })
  })
}