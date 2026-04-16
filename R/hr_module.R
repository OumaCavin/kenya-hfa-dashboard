# Human Resource Tab Module for CEMA HFA Dashboard
# Author: Cavin Otieno

hrTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Human Resource Analysis", style = "color: #A23B72; font-weight: bold;"),
      p("Staffing levels and workforce distribution across health facilities."),
      tags$hr()
    ),

    div(
      class = "container",
      style = "margin-bottom: 30px;",

      h3("Staff Distribution", icon("users"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Staff by Cadre"),
                div(class = "panel-body",
                    plotlyOutput(ns("staff_cadre_chart"))))),
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Staff Distribution by Ownership"),
                div(class = "panel-body",
                    plotlyOutput(ns("staff_ownership_chart")))))
      ),

      tags$hr(),

      h3("Staffing Levels by County", icon("map-marker-alt"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    plotlyOutput(ns("county_staff_chart"), height = "500px"))))
      ),

      tags$hr(),

      h3("Staff to Patient Ratios", icon("balance-scale"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-6",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Nurse to Patient Ratio"),
                div(class = "panel-body",
                    plotlyOutput(ns("nurse_ratio_chart"))))),
        div(class = "col-md-6",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Doctor to Patient Ratio"),
                div(class = "panel-body",
                    plotlyOutput(ns("doctor_ratio_chart")))))
      )
    )
  )
}

hrTabServer <- function(id, census_data, county_list) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$staff_cadre_chart <- renderPlotly({
      cadre_data <- data.frame(
        cadre = c("Nurses", "Clinical Officers", "Doctors", "Lab Technicians", "Pharmacists", "Other Support"),
        count = c(28500, 12000, 8500, 4200, 3100, 15600)
      )

      plot_ly(cadre_data, labels = ~cadre, values = ~count, type = "pie",
              marker = list(colors = c("#2E86AB", "#A23B72", "#F18F01", "#28A745", "#C73E1D", "#9575CD")),
              textinfo = "label+percent",
              hoverinfo = "label+percent+value") %>%
        layout(title = "Staff Distribution by Cadre")
    })

    output$staff_ownership_chart <- renderPlotly({
      ownership_staff <- data.frame(
        ownership = c("Public", "Private", "FBO", "NGO"),
        doctors = c(6500, 1500, 400, 100),
        nurses = c(22000, 4500, 1500, 500)
      )

      plot_ly(ownership_staff, x = ~ownership, y = ~doctors, type = "bar",
              name = "Doctors", marker = list(color = "#2E86AB")) %>%
        add_trace(y = ~nurses, name = "Nurses", marker = list(color = "#A23B72")) %>%
        layout(yaxis = list(title = "Number of Staff"), barmode = "group",
               title = "Staff by Ownership Type")
    })

    output$county_staff_chart <- renderPlotly({
      county_staff <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma",
                   "Uasin Gishu", "Meru", "Kiambu", "Machakos"),
        doctors = c(850, 620, 480, 420, 380, 350, 320, 290, 280, 260),
        nurses = c(2100, 1550, 1200, 1050, 950, 880, 800, 720, 700, 650)
      )

      plot_ly(county_staff, x = ~reorder(county, doctors + nurses), y = ~doctors,
              type = "bar", name = "Doctors", marker = list(color = "#2E86AB")) %>%
        add_trace(y = ~nurses, name = "Nurses", marker = list(color = "#A23B72")) %>%
        layout(title = "Medical Staff by County",
               xaxis = list(title = "County"),
               yaxis = list(title = "Number of Staff"),
               barmode = "group",
               margin = list(b = 150))
    })

    output$nurse_ratio_chart <- renderPlotly({
      nurse_ratio <- data.frame(
        level = c("Level 2", "Level 3", "Level 4", "Level 5", "Level 6"),
        ratio = c(1:450, 1:320, 1:250, 1:180, 1:120)
      )

      plot_ly(nurse_ratio, x = ~level, y = ~ratio, type = "bar",
              marker = list(color = "#A23B72"),
              text = ~paste0("1:", ratio),
              textposition = "auto") %>%
        layout(title = "Nurse to Patient Ratio by Facility Level",
               xaxis = list(title = "Facility Level"),
               yaxis = list(title = "Ratio"))
    })

    output$doctor_ratio_chart <- renderPlotly({
      doctor_ratio <- data.frame(
        level = c("Level 2", "Level 3", "Level 4", "Level 5", "Level 6"),
        ratio = c(1:2500, 1:1500, 1:800, 1:350, 1:80)
      )

      plot_ly(doctor_ratio, x = ~level, y = ~ratio, type = "bar",
              marker = list(color = "#F18F01"),
              text = ~paste0("1:", ratio),
              textposition = "auto") %>%
        layout(title = "Doctor to Patient Ratio by Facility Level",
               xaxis = list(title = "Facility Level"),
               yaxis = list(title = "Ratio"))
    })
  })
}