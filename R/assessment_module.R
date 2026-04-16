# Assessment Completion Tab Module for CEMA HFA Dashboard
# Author: Cavin Otieno

assessmentTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Assessment Completion Status", style = "color: #00ACC1; font-weight: bold;"),
      p("Monitoring of data collection progress and assessment completion across facilities."),
      tags$hr()
    ),

    div(
      class = "container",
      style = "margin-bottom: 30px;",

      h3("Overall Progress", icon("tasks"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E3F2FD;",
                h5("Total Target", style = "color: #1565C0;"),
                h3("12,500", style = "color: #1565C0;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E8F5E9;",
                h5("Completed", style = "color: #2E7D32;"),
                h3("11,250", style = "color: #2E7D32;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #FFF3E0;",
                h5("In Progress", style = "color: #E65100;"),
                h3("820", style = "color: #E65100;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #F3E5F5;",
                h5("Not Started", style = "color: #7B1FA2;"),
                h3("430", style = "color: #7B1FA2;")))
      ),

      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-info",
                div(class = "panel-heading", "Overall Completion Rate"),
                div(class = "panel-body",
                    tags$div(class = "progress", style = "height: 30px;",
                             tags$div(class = "progress-bar bg-success", style = "width: 90%;", "90% Complete")))))
      ),

      tags$hr(),

      h3("Completion by County", icon("map-marker"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    plotlyOutput(ns("county_completion_chart"), height = "500px"))))
      ),

      tags$hr(),

      h3("Completion by Facility Level", icon("layer-group"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Completion by Level"),
                div(class = "panel-body",
                    plotlyOutput(ns("level_completion_chart"))))),
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Time to Complete"),
                div(class = "panel-body",
                    plotlyOutput(ns("completion_time_chart")))))
      ),

      tags$hr(),

      h3("Data Quality Metrics", icon("chart-line"), style = "margin: 30px 0 20px;"),

      div(
        class = "row",
        div(class = "col-md-4",
            div(class = "panel panel-success",
                div(class = "panel-heading", "Complete Records"),
                div(class = "panel-body",
                    plotlyOutput(ns("complete_records_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-warning",
                div(class = "panel-heading", "Partial Records"),
                div(class = "panel-body",
                    plotlyOutput(ns("partial_records_chart"))))),
        div(class = "col-md-4",
            div(class = "panel panel-danger",
                div(class = "panel-heading", "Invalid/Missing"),
                div(class = "panel-body",
                    plotlyOutput(ns("invalid_records_chart")))))
      ),

      tags$hr(),

      h3("Assessment Timeline", icon("calendar"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    plotlyOutput(ns("assessment_timeline_chart"), height = "300px"))))
      )
    )
  )
}

assessmentTabServer <- function(id, census_data, county_list) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$county_completion_chart <- renderPlotly({
      county_completion <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma",
                   "Uasin Gishu", "Meru", "Kiambu", "Machakos", "Kericho", "Kajiado"),
        completed = c(920, 695, 560, 505, 468, 438, 408, 370, 340, 330, 295, 280),
        total = c(950, 720, 580, 520, 480, 450, 420, 380, 350, 340, 305, 290)
      )
      county_completion$rate <- round(county_completion$completed / county_completion$total * 100, 1)

      plot_ly(county_completion, x = ~reorder(county, rate), y = ~rate, type = "bar",
              marker = list(color = ifelse(county_completion$rate >= 90, "#28A745",
                                           ifelse(county_completion$rate >= 75, "#F18F01", "#C73E1D"))),
              text = ~paste0(rate, "%"),
              textposition = "auto") %>%
        layout(title = "Assessment Completion Rate by County",
               xaxis = list(title = "County"),
               yaxis = list(title = "Completion Rate (%)", range = c(0, 100)),
               margin = list(b = 150))
    })

    output$level_completion_chart <- renderPlotly({
      level_completion <- data.frame(
        level = c("Level 2", "Level 3", "Level 4", "Level 5", "Level 6"),
        completed = c(5000, 3700, 1850, 620, 80),
        total = c(5500, 4000, 2000, 800, 75)
      )
      level_completion$rate <- round(level_completion$completed / level_completion$total * 100, 1)

      plot_ly(level_completion, x = ~level, y = ~rate, type = "bar",
              marker = list(color = "#00ACC1"),
              text = ~paste0(rate, "%"),
              textposition = "auto") %>%
        layout(title = "Completion by Facility Level",
               xaxis = list(title = "Facility Level"),
               yaxis = list(title = "Completion Rate (%)", range = c(0, 100)))
    })

    output$completion_time_chart <- renderPlotly({
      time_data <- data.frame(
        time_range = c("<1 day", "1-3 days", "3-7 days", "1-2 weeks", ">2 weeks"),
        percentage = c(25, 40, 20, 10, 5)
      )

      plot_ly(time_data, labels = ~time_range, values = ~percentage, type = "pie",
              marker = list(colors = c("#28A745", "#2E86AB", "#F18F01", "#A23B72", "#C73E1D")),
              textinfo = "label+percent") %>%
        layout(title = "Time to Complete Assessment")
    })

    output$complete_records_chart <- renderPlotly({
      complete_data <- data.frame(
        section = c("Demographics", "Services", "Infrastructure", "Staff", "Equipment"),
        rate = c(95, 92, 88, 90, 85)
      )

      plot_ly(complete_data, x = ~section, y = ~rate, type = "bar",
              marker = list(color = "#28A745"),
              text = ~paste0(rate, "%"),
              textposition = "auto") %>%
        layout(title = "Complete Records by Section",
               xaxis = list(title = ""),
               yaxis = list(title = "Complete (%)", range = c(0, 100)))
    })

    output$partial_records_chart <- renderPlotly({
      partial_data <- data.frame(
        section = c("Demographics", "Services", "Infrastructure", "Staff", "Equipment"),
        rate = c(4, 6, 8, 7, 10)
      )

      plot_ly(partial_data, x = ~section, y = ~rate, type = "bar",
              marker = list(color = "#F18F01"),
              text = ~paste0(rate, "%"),
              textposition = "auto") %>%
        layout(title = "Partial Records by Section",
               xaxis = list(title = ""),
               yaxis = list(title = "Partial (%)"))
    })

    output$invalid_records_chart <- renderPlotly({
      invalid_data <- data.frame(
        section = c("Demographics", "Services", "Infrastructure", "Staff", "Equipment"),
        rate = c(1, 2, 4, 3, 5)
      )

      plot_ly(invalid_data, x = ~section, y = ~rate, type = "bar",
              marker = list(color = "#C73E1D"),
              text = ~paste0(rate, "%"),
              textposition = "auto") %>%
        layout(title = "Invalid/Missing Records by Section",
               xaxis = list(title = ""),
               yaxis = list(title = "Invalid (%)"))
    })

    output$assessment_timeline_chart <- renderPlotly({
      timeline_data <- data.frame(
        week = c("Week 1", "Week 2", "Week 3", "Week 4", "Week 5", "Week 6", "Week 7", "Week 8"),
        cumulative = c(1200, 2800, 4500, 6200, 7800, 9100, 10200, 11250),
        weekly = c(1200, 1600, 1700, 1700, 1600, 1300, 1100, 1050)
      )

      plot_ly(timeline_data, x = ~week, y = ~cumulative, type = "scatter", mode = "lines+markers",
              name = "Cumulative", line = list(color = "#2E86AB", width = 3),
              marker = list(color = "#2E86AB", size = 8)) %>%
        add_trace(y = ~weekly * 5, name = "Weekly (x5)", line = list(color = "#A23B72", width = 2),
                  marker = list(color = "#A23B72", size = 6)) %>%
        layout(title = "Assessment Completion Timeline",
               xaxis = list(title = "Week"),
               yaxis = list(title = "Cumulative Completions"),
               legend = list(x = 0.1, y = 0.9))
    })
  })
}