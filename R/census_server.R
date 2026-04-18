# Census Tab Server Module for Kenya HFA App
# Author: Cavin Otieno

censusTabServer <- function(id, census_data, county_list, facility_types) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Update filter choices based on data
    observe({
      updateSelectInput(session, "county_filter", choices = c("All" = "All", county_list))
      updateSelectInput(session, "type_filter", choices = c("All" = "All", facility_types))
    })

    # Filter data based on selections
    filtered_data <- reactive({
      data <- census_data

      if (input$county_filter != "All") {
        data <- data %>% filter(county == input$county_filter)
      }

      if (input$type_filter != "All") {
        data <- data %>% filter(facility_type == input$type_filter)
      }

      data
    })

    # Calculate summary statistics
    output$total_facilities <- renderText({
      nrow(filtered_data())
    })

    output$total_counties <- renderText({
      length(unique(filtered_data()$county))
    })

    output$total_beds <- renderText({
      sum(filtered_data()$beds, na.rm = TRUE)
    })

    output$total_staff <- renderText({
      sum(filtered_data()$staff_count, na.rm = TRUE)
    })

    # Render charts
    output$facility_type_pie <- renderPlotly({
      create_facility_type_pie(filtered_data())
    })

    output$ownership_bar <- renderPlotly({
      create_ownership_bar(filtered_data())
    })

    output$county_bar <- renderPlotly({
      create_county_bar(filtered_data(), top_n = 15)
    })

    # Render data table
    output$facility_table <- DT::renderDataTable({
      DT::datatable(
        filtered_data() %>%
          select(facility_id, facility_name, county, facility_type, ownership, beds, staff_count),
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
    output$download_data <- downloadHandler(
      filename = function() {
        paste0("census_data_", Sys.Date(), ".csv")
      },
      content = function(file) {
        write.csv(filtered_data(), file, row.names = FALSE)
      }
    )
  })
}