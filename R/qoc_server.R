# QoC Tab Server Module for Kenya HFA App
# Author: Cavin Otieno

qocTabServer <- function(id, qoc_data, county_list, quality_indicators) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Update filter choices based on data
    observe({
      updateSelectInput(session, "county_filter", choices = c("All" = "All", county_list))
      updateSelectInput(session, "indicator_filter", choices = c("All" = "All", quality_indicators))
    })

    # Filter data based on selections
    filtered_data <- reactive({
      data <- qoc_data

      if (input$county_filter != "All") {
        # Join with census data to filter by county
        data <- data %>% filter(census_data$county[match(facility_id, census_data$facility_id)] == input$county_filter)
      }

      if (input$indicator_filter != "All") {
        data <- data %>% filter(indicator == input$indicator_filter)
      }

      data
    })

    # Calculate summary statistics
    output$total_assessments <- renderText({
      nrow(filtered_data())
    })

    output$facilities_count <- renderText({
      length(unique(filtered_data()$facility_id))
    })

    output$avg_score <- renderText({
      round(mean(filtered_data()$score, na.rm = TRUE), 1)
    })

    output$high_performers <- renderText({
      sum(filtered_data()$score >= 80, na.rm = TRUE)
    })

    # Render charts
    output$score_histogram <- renderPlotly({
      create_qoc_score_histogram(filtered_data())
    })

    output$indicator_chart <- renderPlotly({
      create_indicator_comparison(filtered_data())
    })

    output$performance_scatter <- renderPlotly({
      create_performance_scatter(census_data, filtered_data())
    })

    # Render data table
    output$qoc_table <- DT::renderDataTable({
      DT::datatable(
        filtered_data() %>%
          select(assessment_id, facility_id, indicator, score, date_assessed),
        options = list(
          pageLength = 20,
          lengthMenu = c(10, 20, 50, 100),
          scrollX = TRUE,
          dom = "Bfrtip",
          buttons = list("copy", "csv", "pdf")
        ),
        rownames = FALSE,
        class = "stripe hover"
      )
    })

    # Download handler
    output$download_qoc <- downloadHandler(
      filename = function() {
        paste0("qoc_data_", Sys.Date(), ".csv")
      },
      content = function(file) {
        write.csv(filtered_data(), file, row.names = FALSE)
      }
    )
  })
}