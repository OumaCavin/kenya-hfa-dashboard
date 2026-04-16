# Location Tab Module for CEMA HFA Dashboard
# Author: Cavin Otieno

locationTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Geographic Distribution", style = "color: #C73E1D; font-weight: bold;"),
      p("Spatial analysis of health facility distribution across Kenya."),
      tags$hr()
    ),

    div(
      class = "container",
      style = "margin-bottom: 30px;",

      h3("Health Facility Map", icon("map"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    leafletOutput(ns("facility_map"), height = "600px"))))
      ),

      tags$hr(),

      h3("County Distribution Analysis", icon("chart-bar"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Facilities by County"),
                div(class = "panel-body",
                    plotlyOutput(ns("county_facilities_chart"))))),
        div(class = "col-md-6",
            div(class = "panel panel-default",
                div(class = "panel-heading", "Population per Facility"),
                div(class = "panel-body",
                    plotlyOutput(ns("population_chart")))))
      ),

      tags$hr(),

      h3("Spatial Distribution Metrics", icon("globe"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E3F2FD;",
                h5("Avg Distance to Nearest Facility", style = "color: #1565C0;"),
                h3("4.2 km", style = "color: #1565C0;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #F3E5F5;",
                h5("Coverage Rate", style = "color: #7B1FA2;"),
                h3("78%", style = "color: #7B1FA2;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #FFF3E0;",
                h5("Urban Facilities", style = "color: #E65100;"),
                h3("35%", style = "color: #E65100;"))),
        div(class = "col-md-3 col-sm-6",
            div(class = "stat-card", style = "background-color: #E8F5E9;",
                h5("Rural Facilities", style = "color: #2E7D32;"),
                h3("65%", style = "color: #2E7D32;")))
      ),

      tags$hr(),

      h3("Regional Comparison", icon("map-marker"), style = "margin: 30px 0 20px;"),
      div(
        class = "row",
        div(class = "col-md-12",
            div(class = "panel panel-default",
                div(class = "panel-body",
                    plotlyOutput(ns("region_chart"), height = "400px"))))
      )
    )
  )
}

locationTabServer <- function(id, census_data, county_list) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$facility_map <- renderLeaflet({
      # Sample facility locations
      facilities <- data.frame(
        name = c("Kenyatta National Hospital", "Mombasa General Hospital", "Kisumu Level 5",
                 "Nakuru Provincial Hospital", "Kakamega County Hospital", "Eldoret Referral",
                 "Garissa Provincial Hospital", "Kisii Level 5", "Nyeri Provincial Hospital",
                 "Thika Level 5"),
        lat = c(-1.2839, -4.0435, -0.0600, -0.3031, 0.2828, 0.5146, 0.4527, -0.6817, -0.4197, -1.0334),
        lng = c(36.8172, 39.6685, 34.7676, 36.0724, 34.7523, 35.2696, 40.1209, 34.7660, 36.9553, 37.0692),
        level = c("Level 6", "Level 5", "Level 5", "Level 5", "Level 4", "Level 5", "Level 5", "Level 5", "Level 5", "Level 4"),
        ownership = c("Public", "Public", "Public", "Public", "Public", "Public", "Public", "Public", "Public", "Public")
      )

      leaflet(facilities) %>%
        addTiles() %>%
        addCircleMarkers(~lng, ~lat,
                        popup = ~paste0("<b>", name, "</b><br>",
                                       "Level: ", level, "<br>",
                                       "Ownership: ", ownership),
                        radius = 12,
                        color = ~case_when(level == "Level 6" ~ "#C73E1D",
                                          level == "Level 5" ~ "#F18F01",
                                          TRUE ~ "#2E86AB"),
                        fillOpacity = 0.8) %>%
        addLegend("bottomright",
                  colors = c("#C73E1D", "#F18F01", "#2E86AB"),
                  labels = c("Level 6", "Level 5", "Level 4"),
                  title = "Facility Level")
    })

    output$county_facilities_chart <- renderPlotly({
      county_data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma",
                   "Uasin Gishu", "Meru", "Kiambu", "Machakos"),
        facilities = c(950, 720, 580, 520, 480, 450, 420, 380, 350, 340)
      )

      plot_ly(county_data, x = ~reorder(county, facilities), y = ~facilities, type = "bar",
              orientation = "h",
              marker = list(color = "#C73E1D"),
              text = ~facilities,
              textposition = "auto") %>%
        layout(title = "Number of Facilities by County",
               xaxis = list(title = "Number of Facilities"),
               yaxis = list(title = "County"),
               margin = list(l = 150))
    })

    output$population_chart <- renderPlotly({
      population_data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma",
                   "Uasin Gishu", "Meru", "Kiambu", "Machakos"),
        pop_per_facility = c(4800, 5200, 4100, 4500, 3800, 4200, 3900, 3600, 4800, 4100)
      )

      plot_ly(population_data, x = ~county, y = ~pop_per_facility, type = "bar",
              marker = list(color = "#F18F01"),
              text = ~paste0(pop_per_facility),
              textposition = "auto") %>%
        layout(title = "Population per Health Facility by County",
               xaxis = list(title = "County"),
               yaxis = list(title = "Population per Facility"))
    })

    output$region_chart <- renderPlotly({
      region_data <- data.frame(
        region = c("Nairobi", "Central", "Coast", "Western", "Rift Valley", "Eastern", "North Eastern"),
        facilities = c(1250, 1800, 1200, 1650, 2100, 1500, 875),
        beds_per_1000 = c(3.2, 2.8, 2.5, 2.1, 1.8, 1.5, 0.8)
      )

      plot_ly(region_data, x = ~region, y = ~facilities, type = "bar",
              name = "Facilities", marker = list(color = "#2E86AB")) %>%
        add_trace(y = ~beds_per_1000 * 500, name = "Beds per 1000 (x500)", marker = list(color = "#A23B72")) %>%
        layout(title = "Regional Health Facility Distribution",
               xaxis = list(title = "Region"),
               yaxis = list(title = "Number of Facilities"),
               barmode = "group")
    })
  })
}