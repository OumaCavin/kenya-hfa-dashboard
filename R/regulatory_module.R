# Regulatory Tab Module for CEMA HFA Dashboard
# Author: Cavin Otieno

regulatoryTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Regulatory Compliance", style = "color: #9575CD; font-weight: bold;"),
      p("Analysis of regulatory compliance and licensing status of health facilities."),
      tags$hr()
    ),

    div(
      class = "container",
      style = "margin-bottom: 30px;",

      h3("Compliance Overview", icon("check-square"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E3F2FD;",
                h5("Licensed Facilities", style = "color: #1565C0;"),
                h3("89%", style = "color: #1565C0;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #F3E5F5;",
                h5("NHIF Accredited", style = "color: #7B1FA2;"),
                h3("72%", style = "color: #7B1FA2;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #FFF3E0;",
                h5("Inspection Current", style = "color: #E65100;"),
                h3("85%", style = "color: #E65100;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E8F5E9;",
                h5("Compliant", style = "color: #2E7D32;"),
                h3("78%", style = "color: #2E7D32;")))
      ),

      tags$hr(),

      h3("Licensing Status", icon("certificate"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Licensing Status Distribution"),
                div(class = "panel-body",
                    plotlyOutput(ns("license_status_chart"))))),
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "License Validity"),
                div(class = "panel-body",
                    plotlyOutput(ns("license_validity_chart")))))
      ),

      tags$hr(),

      h3("Insurance and Accreditation", icon("shield-alt"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-6",
            div(class = "panel panel-info",
                div(class = "panel-heading", "NHIF Accreditation Status"),
                div(class = "panel-body",
                    plotlyOutput(ns("nhif_chart"))))),
        div(class = "col-md-6",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Quality Certifications"),
                div(class = "panel-body",
                    plotlyOutput(ns("certifications_chart")))))
      ),

      tags$hr(),

      h3("Compliance by Ownership", icon("building"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    plotlyOutput(ns("ownership_compliance_chart"), height = "400px"))))
      )
    )
  )
}

regulatoryTabServer <- function(id, census_data, county_list) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$license_status_chart <- renderPlotly({
      license_data <- data.frame(
        status = c("Fully Licensed", "Provisional License", "Pending", "Unlicensed"),
        count = c(8500, 2200, 1200, 475)
      )

      plot_ly(license_data, labels = ~status, values = ~count, type = "pie",
              marker = list(colors = c("#28A745", "#F18F01", "#2E86AB", "#C73E1D")),
              textinfo = "label+percent",
              hoverinfo = "label+percent+value") %>%
        layout(title = "Facility Licensing Status")
    })

    output$license_validity_chart <- renderPlotly({
      validity_data <- data.frame(
        validity = c("Valid >1 year", "Valid <1 year", "Expired <6 months", "Expired >6 months"),
        percentage = c(55, 25, 12, 8)
      )

      plot_ly(validity_data, x = ~validity, y = ~percentage, type = "bar",
              marker = list(color = c("#28A745", "#F18F01", "#E65100", "#C73E1D")),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "License Validity Status",
               xaxis = list(title = ""),
               yaxis = list(title = "Percentage (%)"))
    })

    output$nhif_chart <- renderPlotly({
      nhif_data <- data.frame(
        status = c("Accredited", "Pending", "Not Applied"),
        facilities = c(8900, 2500, 975)
      )

      plot_ly(nhif_data, labels = ~status, values = ~facilities, type = "pie",
              marker = list(colors = c("#2E86AB", "#F18F01", "#9575CD")),
              hole = 0.5) %>%
        layout(title = "NHIF Accreditation Status")
    })

    output$certifications_chart <- renderPlotly({
      cert_data <- data.frame(
        certification = c("ISO 9001", "QIP", "Safe Care", "JCI", "None"),
        percentage = c(12, 35, 8, 3, 42)
      )

      plot_ly(cert_data, x = ~certification, y = ~percentage, type = "bar",
              marker = list(color = "#9575CD"),
              text = ~paste0(percentage, "%"),
              textposition = "auto") %>%
        layout(title = "Quality Certifications",
               xaxis = list(title = "Certification Type"),
               yaxis = list(title = "Percentage (%)"))
    })

    output$ownership_compliance_chart <- renderPlotly({
      compliance_data <- data.frame(
        ownership = c("Public", "Private", "FBO", "NGO"),
        licensed = c(95, 82, 88, 75),
        accredited = c(88, 65, 72, 68),
        inspected = c(92, 78, 85, 70)
      )

      plot_ly(compliance_data, x = ~ownership, y = ~licensed, type = "bar",
              name = "Licensed", marker = list(color = "#28A745")) %>%
        add_trace(y = ~accredited, name = "NHIF Accredited", marker = list(color = "#2E86AB")) %>%
        add_trace(y = ~inspected, name = "Inspected", marker = list(color = "#A23B72")) %>%
        layout(title = "Regulatory Compliance by Ownership",
               xaxis = list(title = "Ownership Type"),
               yaxis = list(title = "Percentage (%)"),
               barmode = "group")
    })
  })
}