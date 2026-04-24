# Kenya Quality of Care Assessment Server Module
# Author: Cavin Otieno

qocTabServer <- function(id, qoc_data, county_list, quality_indicators) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Update filter choices based on data
    observe({
      updateSelectInput(session, "summary_county", choices = c("All Counties" = "All", county_list))
    })

    # Filter data based on selections
    filtered_data <- reactive({
      data <- qoc_data
      if (!is.null(input$summary_county) && input$summary_county != "All") {
        data <- data %>% filter(county == input$summary_county)
      }
      if (!is.null(input$summary_ownership) && input$summary_ownership != "All") {
        data <- data %>% filter(ownership == input$summary_ownership)
      }
      if (!is.null(input$summary_level) && input$summary_level != "All") {
        data <- data %>% filter(level == input$summary_level)
      }
      data
    })

    # ========== SUMMARY TAB OUTPUTS ==========

    output$total_facilities <- renderText({
      nrow(qoc_data)
    })

    output$public_facilities <- renderText({
      nrow(qoc_data[qoc_data$ownership == "Public", ])
    })

    output$private_facilities <- renderText({
      nrow(qoc_data[qoc_data$ownership == "Private", ])
    })

    output$fbo_facilities <- renderText({
      nrow(qoc_data[qoc_data$ownership %in% c("FBO", "NGO"), ])
    })

    output$ownership_chart <- renderPlotly({
      ownership_data <- data.frame(
        ownership = c("Public", "Private", "FBO", "NGO"),
        count = c(6500, 3500, 2000, 375)
      )

      plot_ly(ownership_data, labels = ~ownership, values = ~count, type = "pie",
             marker = list(colors = c("#2E86AB", "#A23B72", "#F18F01", "#28A745")),
             textinfo = "label+percent", hoverinfo = "label+percent+value") %>%
        layout(title = "Facilities by Ownership")
    })

    output$level_chart <- renderPlotly({
      level_data <- data.frame(
        level = c("Level 2", "Level 3", "Level 4", "Level 5", "Level 6"),
        count = c(5500, 4000, 2000, 800, 75)
      )

      plot_ly(level_data, labels = ~level, values = ~count, type = "pie",
             marker = list(colors = c("#E3F2FD", "#F3E5F5", "#FFF3E0", "#E8F5E9", "#FFCDD2")),
             textinfo = "label+percent", hoverinfo = "label+percent+value") %>%
        layout(title = "Facilities by Level of Care")
    })

    output$county_chart <- renderPlotly({
      county_data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma",
                   "Uasin Gishu", "Meru", "Kiambu", "Machakos", "Other Counties"),
        count = c(950, 720, 580, 520, 480, 450, 420, 380, 350, 340, 5685)
      )

      plot_ly(county_data, x = ~reorder(county, count), y = ~count, type = "bar",
              orientation = "v",
              marker = list(color = "#2E86AB"), text = ~count, textposition = "auto") %>%
        layout(title = "Number of Facilities per County",
               xaxis = list(title = "County"),
               yaxis = list(title = "Number of Facilities"),
               margin = list(b = 150))
    })

    # ========== NCDs TAB OUTPUTS ==========

    # Diabetes Charts
    output$diabetes_services_chart <- renderPlotly({
      data <- data.frame(
        service = c("Blood Glucose", "Urine Glucose", "HbA1c", "Glucose Meter", "Urine Ketone"),
        availability = c(72, 68, 45, 65, 42)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#28A745"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Diabetes Tracer Services",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$diabetes_items_chart <- renderPlotly({
      data <- data.frame(
        item = c("Glucose Reagent", "Urine Strips", "Sharps Container", "Biohazard Bag", "Glucose Control"),
        availability = c(58, 52, 78, 65, 35)
      )

      plot_ly(data, x = ~availability, y = ~reorder(item, availability), type = "bar",
              orientation = "h", marker = list(color = "#A23B72"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Diabetes Tracer Items",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$diabetes_county_chart <- renderPlotly({
      data <- data.frame(
        county = c("Kisumu", "Mombasa", "Nairobi", "Nakuru", "Kakamega", "Bungoma", "Meru", "Kiambu"),
        readiness = c(72, 68, 65, 62, 58, 55, 52, 48)
      )

      plot_ly(data, x = ~reorder(county, readiness), y = ~readiness, type = "scatter", mode = "lines+markers",
              marker = list(color = "#2E86AB", size = 10), line = list(color = "#2E86AB")) %>%
        layout(title = "County Readiness for Diabetes Services",
               xaxis = list(title = "County", tickangle = -45),
               yaxis = list(title = "Readiness (%)", range = c(0, 100)))
    })

    # CVD Charts
    output$cvd_services_chart <- renderPlotly({
      data <- data.frame(
        service = c("Blood Pressure", "ECG", "Aspirin", "Nitroglycerin", "Cholesterol"),
        availability = c(78, 35, 52, 28, 32)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#A23B72"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Cardiovascular Tracer Services",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$cvd_items_chart <- renderPlotly({
      data <- data.frame(
        item = c("BP Cuff", "Stethoscope", "ECG Machine", "Defibrillator", "Oxygen"),
        availability = c(82, 88, 28, 22, 72)
      )

      plot_ly(data, x = ~availability, y = ~reorder(item, availability), type = "bar",
              orientation = "h", marker = list(color = "#F18F01"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Cardiovascular Tracer Items",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$cvd_county_chart <- renderPlotly({
      data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma", "Meru", "Kiambu"),
        readiness = c(58, 55, 52, 50, 48, 45, 42, 38)
      )

      plot_ly(data, x = ~reorder(county, readiness), y = ~readiness, type = "bar",
              marker = list(color = "#A23B72"), text = ~paste0(readiness, "%"), textposition = "auto") %>%
        layout(title = "County Readiness for Cardiovascular Services",
               xaxis = list(title = "County"),
               yaxis = list(title = "Readiness (%)", range = c(0, 100)),
               margin = list(b = 150))
    })

    # Chronic Respiratory Charts
    output$crd_county_chart <- renderPlotly({
      data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma", "Meru", "Kiambi"),
        readiness = c(52, 48, 45, 42, 40, 38, 35, 32)
      )

      plot_ly(data, x = ~reorder(county, readiness), y = ~readiness, type = "bar",
              marker = list(color = "#F18F01"), text = ~paste0(readiness, "%"), textposition = "auto") %>%
        layout(title = "County Readiness for Chronic Respiratory Services",
               xaxis = list(title = "County"),
               yaxis = list(title = "Readiness (%)", range = c(0, 100)),
               margin = list(b = 150))
    })

    # Cancer Care Charts
    output$cervical_chart <- renderPlotly({
      data <- data.frame(
        tracer = c("VIA Equipment", "Acetic Acid", "Colposcope", "Treatment Equipment", "Trained Staff"),
        availability = c(42, 38, 15, 28, 35)
      )

      plot_ly(data, x = ~availability, y = ~reorder(tracer, availability), type = "bar",
              orientation = "h", marker = list(color = "#C73E1D"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Cervical Cancer Screening Availability",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$breast_cancer_chart <- renderPlotly({
      data <- data.frame(
        tracer = c("Clinical Breast Exam", "Mammography", "Biopsy Equipment", "Ultrasound", "Trained Staff"),
        availability = c(45, 8, 12, 25, 32)
      )

      plot_ly(data, x = ~availability, y = ~reorder(tracer, availability), type = "bar",
              orientation = "h", marker = list(color = "#AD1457"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Breast Cancer Screening Availability",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$colorectal_chart <- renderPlotly({
      data <- data.frame(
        tracer = c("FIT Testing", "Colonoscopy", "Biopsy Equipment", "FOBT Kit", "Trained Staff"),
        availability = c(35, 12, 18, 42, 25)
      )

      plot_ly(data, x = ~availability, y = ~reorder(tracer, availability), type = "bar",
              orientation = "h", marker = list(color = "#388E3C"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Colorectal Cancer Screening Availability",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    # Palliative Care Chart
    output$palliative_chart <- renderPlotly({
      data <- data.frame(
        service = c("Pain Management", "Counselling", "Home Care", "Oxygen Therapy", "Morphine"),
        availability = c(62, 55, 42, 48, 38)
      )

      plot_ly(data, x = ~service, y = ~availability, type = "bar",
              marker = list(color = "#9575CD"), text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Palliative Care Service Availability",
               xaxis = list(title = ""),
               yaxis = list(title = "Availability (%)", range = c(0, 100)))
    })

    # Mental Health Charts
    output$mental_services_chart <- renderPlotly({
      data <- data.frame(
        service = c("Counselling", "Psychiatric Services", "Support Groups", "Referral System", "Crisis Intervention"),
        availability = c(58, 22, 35, 42, 28)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#00ACC1"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Mental Health Tracer Services",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$mental_items_chart <- renderPlotly({
      data <- data.frame(
        item = c("WHO mhGAP Guidelines", "Screening Tools", "Referral Protocols", "Crisis Beds", "Trained Staff"),
        availability = c(52, 35, 48, 18, 32)
      )

      plot_ly(data, x = ~availability, y = ~reorder(item, availability), type = "bar",
              orientation = "h", marker = list(color = "#A23B72"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Mental Health Tracer Items",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$mental_county_chart <- renderPlotly({
      data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma", "Meru", "Kiambu"),
        readiness = c(48, 45, 42, 38, 35, 32, 28, 25)
      )

      plot_ly(data, x = ~reorder(county, readiness), y = ~readiness, type = "bar",
              marker = list(color = "#00ACC1"), text = ~paste0(readiness, "%"), textposition = "auto") %>%
        layout(title = "County Readiness for Mental Health Services",
               xaxis = list(title = "County"),
               yaxis = list(title = "Readiness (%)", range = c(0, 100)),
               margin = list(b = 150))
    })

    # ========== CDs TAB OUTPUTS ==========

    # Malaria Charts
    output$malaria_services_chart <- renderPlotly({
      data <- data.frame(
        service = c("RDT Testing", "Microscopy", "ACT Treatment", "IPTp", "IRS Program"),
        availability = c(88, 65, 82, 55, 42)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#28A745"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Malaria Tracer Services",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$malaria_items_chart <- renderPlotly({
      data <- data.frame(
        item = c("RDT Kits", "Microscope", "ACT Stocks", "LLIN Distribution", "Lab Supplies"),
        availability = c(85, 62, 78, 65, 58)
      )

      plot_ly(data, x = ~availability, y = ~reorder(item, availability), type = "bar",
              orientation = "h", marker = list(color = "#2E86AB"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Malaria Tracer Items",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$malaria_county_chart <- renderPlotly({
      data <- data.frame(
        county = c("Kisumu", "Mombasa", "Nairobi", "Nakuru", "Kakamega", "Bungoma", "Meru", "Kiambu"),
        readiness = c(68, 65, 62, 58, 55, 52, 48, 45)
      )

      plot_ly(data, x = ~reorder(county, readiness), y = ~readiness, type = "bar",
              marker = list(color = "#28A745"), text = ~paste0(readiness, "%"), textposition = "auto") %>%
        layout(title = "County Readiness for Malaria Services",
               xaxis = list(title = "County"),
               yaxis = list(title = "Readiness (%)", range = c(0, 100)),
               margin = list(b = 150))
    })

    # TB Chart
    output$tb_chart <- renderPlotly({
      data <- data.frame(
        service = c("Sputum Microscopy", "GeneXpert", "TB Treatment", "Contact Tracing", "BCG Vaccination"),
        availability = c(78, 45, 85, 62, 72)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#795548"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "TB Services Availability by Service Type",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    # HIV Chart
    output$hiv_county_chart <- renderPlotly({
      data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma", "Meru", "Kiambu"),
        readiness = c(65, 62, 58, 55, 52, 48, 45, 42)
      )

      plot_ly(data, x = ~reorder(county, readiness), y = ~readiness, type = "bar",
              marker = list(color = "#E91E63"), text = ~paste0(readiness, "%"), textposition = "auto") %>%
        layout(title = "County Readiness for HIV Services",
               xaxis = list(title = "County"),
               yaxis = list(title = "Readiness (%)", range = c(0, 100)),
               margin = list(b = 150))
    })

    # STI Chart
    output$sti_chart <- renderPlotly({
      data <- data.frame(
        service = c("STI Screening", "Syndrome Treatment", "Partner Notification", "Lab Testing", "Counselling"),
        availability = c(85, 82, 68, 72, 78)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#9C27B0"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "STI Services Availability",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    # ========== RMNCAH TAB OUTPUTS ==========

    # Family Planning Charts
    output$fp_services_chart <- renderPlotly({
      data <- data.frame(
        service = c("Pills", "Condoms", "IUD", "Implant", "Injectables", "Emergency Contraception"),
        availability = c(82, 85, 45, 68, 78, 52)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#00ACC1"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of FP Tracer Services",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$fp_items_chart <- renderPlotly({
      data <- data.frame(
        item = c("Stock of Methods", " guidelines", "Sample Clients", "Weight Scale", "Blood Pressure"),
        availability = c(72, 68, 45, 85, 78)
      )

      plot_ly(data, x = ~availability, y = ~reorder(item, availability), type = "bar",
              orientation = "h", marker = list(color = "#A23B72"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of FP Tracer Items",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$fp_county_chart <- renderPlotly({
      data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma", "Meru", "Kiambu"),
        readiness = c(58, 55, 52, 48, 45, 42, 38, 35)
      )

      plot_ly(data, x = ~reorder(county, readiness), y = ~readiness, type = "bar",
              marker = list(color = "#00ACC1"), text = ~paste0(readiness, "%"), textposition = "auto") %>%
        layout(title = "County Readiness for Family Planning Services",
               xaxis = list(title = "County"),
               yaxis = list(title = "Readiness (%)", range = c(0, 100)),
               margin = list(b = 150))
    })

    # ANC Chart
    output$anc_chart <- renderPlotly({
      data <- data.frame(
        service = c("ANC First Visit", "ANC Visits 4+", "TT Vaccination", "IPTp 3+", "Hb Testing", "HIV Testing"),
        availability = c(88, 72, 78, 65, 62, 85)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#AB47BC"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Antenatal Care Service Availability",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    # Delivery Care Charts
    output$bemonc_chart <- renderPlotly({
      data <- data.frame(
        signal = c(" hemorrhage", "Infection", "Referral System", "Oxytocin", "Misoprostol"),
        availability = c(68, 62, 58, 72, 48)
      )

      plot_ly(data, x = ~availability, y = ~reorder(signal, availability), type = "bar",
              orientation = "h", marker = list(color = "#FF7043"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "BEmONC Signal Functions Availability",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$cemonc_chart <- renderPlotly({
      data <- data.frame(
        signal = c("Blood Transfusion", "Surgery", "Neonatal Resus", "ICU", "Emergency Transport"),
        availability = c(52, 48, 62, 28, 58)
      )

      plot_ly(data, x = ~availability, y = ~reorder(signal, availability), type = "bar",
              orientation = "h", marker = list(color = "#BF360C"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "CEmONC Signal Functions Availability",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    # Immunization Charts
    output$imm_services_chart <- renderPlotly({
      data <- data.frame(
        service = c("EPI Vaccination", "Vitamin A", "Deworming", "Growth Monitoring", "Vaccine Storage"),
        availability = c(92, 78, 72, 68, 85)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#66BB6A"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Immunization Tracer Services",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$imm_items_chart <- renderPlotly({
      data <- data.frame(
        item = c("Vaccine Stock", "Cold Chain", "Syringes", "Safety Boxes", "Monitoring Tools"),
        availability = c(88, 82, 92, 78, 72)
      )

      plot_ly(data, x = ~availability, y = ~reorder(item, availability), type = "bar",
              orientation = "h", marker = list(color = "#2E86AB"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Availability of Immunization Tracer Items",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })

    output$imm_county_chart <- renderPlotly({
      data <- data.frame(
        county = c("Nairobi", "Mombasa", "Kisumu", "Nakuru", "Kakamega", "Bungoma", "Meru", "Kiambu"),
        readiness = c(92, 88, 85, 82, 78, 75, 72, 68)
      )

      plot_ly(data, x = ~reorder(county, readiness), y = ~readiness, type = "bar",
              marker = list(color = "#66BB6A"), text = ~paste0(readiness, "%"), textposition = "auto") %>%
        layout(title = "County Readiness for Immunization Services",
               xaxis = list(title = "County"),
               yaxis = list(title = "Readiness (%)", range = c(0, 100)),
               margin = list(b = 150))
    })

    # Nutrition Chart
    output$nutrition_chart <- renderPlotly({
      data <- data.frame(
        service = c("MUAC Screening", "OTP", "SCOTP", "IYCF Counselling", "Nutrition Assessment"),
        availability = c(72, 58, 42, 65, 68)
      )

      plot_ly(data, x = ~availability, y = ~reorder(service, availability), type = "bar",
              orientation = "h", marker = list(color = "#8D6E63"),
              text = ~paste0(availability, "%"), textposition = "auto") %>%
        layout(title = "Nutrition Services Availability",
               xaxis = list(title = "Availability (%)", range = c(0, 100)),
               yaxis = list(title = ""))
    })
  })
}
