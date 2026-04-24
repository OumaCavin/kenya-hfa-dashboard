# Kenya Quality of Care Assessment Module - UI
# Author: Cavin Otieno

qocTabUI <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "container",
      style = "margin-bottom: 30px;",
      h1("Kenya Quality of Care Assessment", style = "color: #A23B72; font-weight: bold;"),
      p("Quality of Care assessment data from March 2024 covering NCDs, Communicable Diseases, and RMNCAH services."),
      tags$hr()
    ),

    # Main tabs for QoC sections
    tabsetPanel(
      id = ns("qoc_main_tabs"),
      type = "tabs",

      # ===== SUMMARY TAB =====
      tabPanel(
        title = "Summary",
        value = "summary",
        icon = icon("home"),

        div(
          class = "container",
          style = "margin-top: 20px;",

          # Summary filters
          div(
            class = "row",
            style = "background-color: #F8F9FA; padding: 15px; border-radius: 10px; margin-bottom: 20px;",
            div(class = "col-md-4",
                selectInput(ns("summary_county"), "County",
                           choices = c("All Counties" = "All"),
                           selected = "All")),
            div(class = "col-md-4",
                selectInput(ns("summary_ownership"), "Ownership",
                           choices = c("All" = "All", "Public", "Private", "FBO", "NGO"),
                           selected = "All")),
            div(class = "col-md-4",
                selectInput(ns("summary_level"), "Level of Care",
                           choices = c("All" = "All", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6"),
                           selected = "All"))
          ),

          # Overview cards
          div(class = "row",
              div(class = "col-md-3",
                  div(class = "stat-card", style = "background-color: #E3F2FD;",
                      h5("Total Facilities Assessed", style = "color: #1565C0;"),
                      h3(textOutput(ns("total_facilities")), style = "color: #1565C0;"),
                      h6("From 47 counties", style = "color: #1565C0;"))),
              div(class = "col-md-3",
                  div(class = "stat-card", style = "background-color: #E8F5E9;",
                      h5("Public Facilities", style = "color: #2E7D32;"),
                      h3(textOutput(ns("public_facilities")), style = "color: #2E7D32;"))),
              div(class = "col-md-3",
                  div(class = "stat-card", style = "background-color: #F3E5F5;",
                      h5("Private Facilities", style = "color: #7B1FA2;"),
                      h3(textOutput(ns("private_facilities")), style = "color: #7B1FA2;"))),
              div(class = "col-md-3",
                  div(class = "stat-card", style = "background-color: #FFF3E0;",
                      h5("FBO/NGO Facilities", style = "color: #E65100;"),
                      h3(textOutput(ns("fbo_facilities")), style = "color: #E65100;")))
          ),

          # Charts row 1
          div(class = "row",
              div(class = "col-md-6",
                  div(class = "panel panel-default",
                      div(class = "panel-heading", "Facilities by Ownership"),
                      div(class = "panel-body",
                          plotlyOutput(ns("ownership_chart"), height = "300px")))),
              div(class = "col-md-6",
                  div(class = "panel panel-default",
                      div(class = "panel-heading", "Facilities by Level of Care"),
                      div(class = "panel-body",
                          plotlyOutput(ns("level_chart"), height = "300px"))))
          ),

          # County distribution chart
          div(class = "row",
              div(class = "col-12",
                  div(class = "panel panel-default",
                      div(class = "panel-heading", "Number of Facilities per County"),
                      div(class = "panel-body",
                          plotlyOutput(ns("county_chart"), height = "400px"))))
          )
        )
      ),

      # ===== NCDs TAB =====
      tabPanel(
        title = "Non-Communicable Diseases",
        value = "ncd",
        icon = icon("heartbeat"),

        div(
          class = "container",
          style = "margin-top: 20px;",

          # NCD Sub-tabs
          tabsetPanel(
            id = ns("ncd_subtabs"),
            type = "tabs",

            # Diabetes
            tabPanel(title = "Diabetes Services",
                div(class = "container",
                    h4("Diabetes Services Assessment", style = "color: #2E86AB;"),

                    # Summary stats
                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Facilities Assessed", style = "color: #2E7D32;"),
                                h3("3,000", style = "color: #2E7D32;"),
                                h6("92% of total", style = "color: #2E7D32;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("64%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #FFF3E0;",
                                h5("Avg Quality Score", style = "color: #E65100;"),
                                h3("72%", style = "color: #E65100;")))
                    ),

                    # Charts
                    div(class = "row",
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Diabetes Tracer Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("diabetes_services_chart"), height = "300px")))),
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Diabetes Tracer Items"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("diabetes_items_chart"), height = "300px"))))
                    ),

                    div(class = "row",
                        div(class = "col-12",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "County Availability of Diabetes Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("diabetes_county_chart"), height = "350px")))))
                )
            ),

            # Cardiovascular
            tabPanel(title = "Cardiovascular Disease",
                div(class = "container",
                    h4("Cardiovascular Disease Care Assessment", style = "color: #A23B72;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #F3E5F5;",
                                h5("Facilities Assessed", style = "color: #7B1FA2;"),
                                h3("3,049", style = "color: #7B1FA2;"),
                                h6("93% of total", style = "color: #7B1FA2;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("52%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #FFF3E0;",
                                h5("Avg Quality Score", style = "color: #E65100;"),
                                h3("65%", style = "color: #E65100;")))
                    ),

                    div(class = "row",
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Cardiovascular Tracer Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("cvd_services_chart"), height = "300px")))),
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Cardiovascular Tracer Items"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("cvd_items_chart"), height = "300px"))))
                    ),

                    div(class = "row",
                        div(class = "col-12",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "County Availability of Cardiovascular Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("cvd_county_chart"), height = "350px")))))
                )
            ),

            # Chronic Respiratory
            tabPanel(title = "Chronic Respiratory Diseases",
                div(class = "container",
                    h4("Chronic Respiratory Diseases Assessment", style = "color: #F18F01;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #FFF3E0;",
                                h5("Facilities Assessed", style = "color: #E65100;"),
                                h3("2,962", style = "color: #E65100;"),
                                h6("91% of total", style = "color: #E65100;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("43%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("58%", style = "color: #2E7D32;")))
                    ),

                    div(class = "row",
                        div(class = "col-12",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "County Availability of Chronic Respiratory Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("crd_county_chart"), height = "350px")))))
                )
            ),

            # Cancer Care
            tabPanel(title = "Cancer Care Services",
                div(class = "container",
                    h4("Cancer Care Services Assessment", style = "color: #C73E1D;"),

                    tabsetPanel(
                      id = ns("cancer_subtabs"),
                      type = "tabs",
                      tabPanel(title = "Cervical Cancer",
                          div(class = "container",
                              div(class = "row",
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #FFCDD2;",
                                          h5("Facilities Assessed", style = "color: #C73E1D;"),
                                          h3("1,606", style = "color: #C73E1D;"),
                                          h6("95% of cancer facilities", style = "color: #C73E1D;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E3F2FD;",
                                          h5("Overall Readiness", style = "color: #1565C0;"),
                                          h3("31%", style = "color: #1565C0;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E8F5E9;",
                                          h5("Avg Quality Score", style = "color: #2E7D32;"),
                                          h3("45%", style = "color: #2E7D32;")))
                              ),
                              plotlyOutput(ns("cervical_chart"), height = "350px")
                          )
                      ),
                      tabPanel(title = "Breast Cancer",
                          div(class = "container",
                              div(class = "row",
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #F8BBD9;",
                                          h5("Facilities Assessed", style = "color: #AD1457;"),
                                          h3("1,461", style = "color: #AD1457;"),
                                          h6("87% of cancer facilities", style = "color: #AD1457;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E3F2FD;",
                                          h5("Overall Readiness", style = "color: #1565C0;"),
                                          h3("15%", style = "color: #1565C0;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E8F5E9;",
                                          h5("Avg Quality Score", style = "color: #2E7D32;"),
                                          h3("38%", style = "color: #2E7D32;")))
                              ),
                              plotlyOutput(ns("breast_cancer_chart"), height = "350px")
                          )
                      ),
                      tabPanel(title = "Colorectal Cancer",
                          div(class = "container",
                              div(class = "row",
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #C8E6C9;",
                                          h5("Facilities Assessed", style = "color: #388E3C;"),
                                          h3("229", style = "color: #388E3C;"),
                                          h6("38% of cancer facilities", style = "color: #388E3C;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E3F2FD;",
                                          h5("Overall Readiness", style = "color: #1565C0;"),
                                          h3("42%", style = "color: #1565C0;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E8F5E9;",
                                          h5("Avg Quality Score", style = "color: #2E7D32;"),
                                          h3("55%", style = "color: #2E7D32;")))
                              ),
                              plotlyOutput(ns("colorectal_chart"), height = "350px")
                          )
                      )
                    )
                )
            ),

            # Palliative Care
            tabPanel(title = "Palliative Care",
                div(class = "container",
                    h4("Palliative Care Assessment", style = "color: #9575CD;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E1BEE7;",
                                h5("Facilities Assessed", style = "color: #7B1FA2;"),
                                h3("663", style = "color: #7B1FA2;"),
                                h6("20% of total", style = "color: #7B1FA2;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("42%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("60%", style = "color: #2E7D32;")))
                    ),

                    plotlyOutput(ns("palliative_chart"), height = "350px")
                )
            ),

            # Mental Health
            tabPanel(title = "Mental Health",
                div(class = "container",
                    h4("Mental Health Services Assessment", style = "color: #00ACC1;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #B2EBF2;",
                                h5("Facilities Assessed", style = "color: #00838F;"),
                                h3("1,857", style = "color: #00838F;"),
                                h6("57% of total", style = "color: #00838F;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("38%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("52%", style = "color: #2E7D32;")))
                    ),

                    div(class = "row",
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Mental Health Tracer Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("mental_services_chart"), height = "300px")))),
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Mental Health Tracer Items"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("mental_items_chart"), height = "300px"))))
                    ),

                    div(class = "row",
                        div(class = "col-12",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "County Availability of Mental Health Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("mental_county_chart"), height = "350px")))))
                )
            )
          )
        )
      ),

      # ===== CDs TAB =====
      tabPanel(
        title = "Communicable Diseases",
        value = "cd",
        icon = icon("bug"),

        div(
          class = "container",
          style = "margin-top: 20px;",

          tabsetPanel(
            id = ns("cd_subtabs"),
            type = "tabs",

            # Malaria
            tabPanel(title = "Malaria Services",
                div(class = "container",
                    h4("Malaria Services Assessment", style = "color: #28A745;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #C8E6C9;",
                                h5("Facilities Assessed", style = "color: #388E3C;"),
                                h3("3,400", style = "color: #388E3C;"),
                                h6("96% of total", style = "color: #388E3C;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("53%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #FFF3E0;",
                                h5("Avg Quality Score", style = "color: #E65100;"),
                                h3("68%", style = "color: #E65100;")))
                    ),

                    div(class = "row",
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Malaria Tracer Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("malaria_services_chart"), height = "300px")))),
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Malaria Tracer Items"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("malaria_items_chart"), height = "300px"))))
                    ),

                    div(class = "row",
                        div(class = "col-12",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "County Availability of Malaria Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("malaria_county_chart"), height = "350px")))))
                )
            ),

            # TB Services
            tabPanel(title = "TB Services",
                div(class = "container",
                    h4("Tuberculosis Services Assessment", style = "color: #795548;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #D7CCC8;",
                                h5("Facilities Assessed", style = "color: #5D4037;"),
                                h3("2,247", style = "color: #5D4037;"),
                                h6("64% of total", style = "color: #5D4037;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("55%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("70%", style = "color: #2E7D32;")))
                    ),

                    plotlyOutput(ns("tb_chart"), height = "350px")
                )
            ),

            # HIV Services
            tabPanel(title = "HIV Services",
                div(class = "container",
                    h4("HIV Services Assessment", style = "color: #E91E63;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #F8BBD9;",
                                h5("Facilities Assessed", style = "color: #AD1457;"),
                                h3("3,020", style = "color: #AD1457;"),
                                h6("86% of total", style = "color: #AD1457;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("54%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("72%", style = "color: #2E7D32;")))
                    ),

                    div(class = "row",
                        div(class = "col-12",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "County Availability of HIV Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("hiv_county_chart"), height = "350px")))))
                )
            ),

            # STI
            tabPanel(title = "Sexually Transmitted Infections",
                div(class = "container",
                    h4("Sexually Transmitted Infection Services Assessment", style = "color: #9C27B0;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E1BEE7;",
                                h5("Facilities Assessed", style = "color: #7B1FA2;"),
                                h3("3,205", style = "color: #7B1FA2;"),
                                h6("91% of total", style = "color: #7B1FA2;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("67%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("78%", style = "color: #2E7D32;")))
                    ),

                    plotlyOutput(ns("sti_chart"), height = "350px")
                )
            )
          )
        )
      ),

      # ===== RMNCAH TAB =====
      tabPanel(
        title = "RMNCAH",
        value = "rmncah",
        icon = icon("baby"),

        div(
          class = "container",
          style = "margin-top: 20px;",

          tabsetPanel(
            id = ns("rmncah_subtabs"),
            type = "tabs",

            # Family Planning
            tabPanel(title = "Family Planning",
                div(class = "container",
                    h4("Family Planning Services Assessment", style = "color: #00ACC1;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #B2EBF2;",
                                h5("Facilities Assessed", style = "color: #00838F;"),
                                h3("3,034", style = "color: #00838F;"),
                                h6("86% of total", style = "color: #00838F;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("48%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("62%", style = "color: #2E7D32;")))
                    ),

                    div(class = "row",
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of FP Tracer Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("fp_services_chart"), height = "300px")))),
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of FP Tracer Items"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("fp_items_chart"), height = "300px"))))
                    ),

                    plotlyOutput(ns("fp_county_chart"), height = "350px")
                )
            ),

            # Antenatal Care
            tabPanel(title = "Antenatal Care",
                div(class = "container",
                    h4("Antenatal Care Services Assessment", style = "color: #AB47BC;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E1BEE7;",
                                h5("Facilities Assessed", style = "color: #7B1FA2;"),
                                h3("2,926", style = "color: #7B1FA2;"),
                                h6("83% of total", style = "color: #7B1FA2;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("61%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("75%", style = "color: #2E7D32;")))
                    ),

                    plotlyOutput(ns("anc_chart"), height = "350px")
                )
            ),

            # Delivery Care
            tabPanel(title = "Delivery Care",
                div(class = "container",
                    h4("Delivery Care Services Assessment", style = "color: #FF7043;"),

                    tabsetPanel(
                      id = ns("delivery_subtabs"),
                      type = "tabs",
                      tabPanel(title = "BEmONC",
                          div(class = "container",
                              div(class = "row",
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #FFCCBC;",
                                          h5("Facilities Assessed", style = "color: #BF360C;"),
                                          h3("1,718", style = "color: #BF360C;"),
                                          h6("80% of delivery facilities", style = "color: #BF360C;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E3F2FD;",
                                          h5("Overall Readiness", style = "color: #1565C0;"),
                                          h3("50%", style = "color: #1565C0;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E8F5E9;",
                                          h5("Avg Quality Score", style = "color: #2E7D32;"),
                                          h3("65%", style = "color: #2E7D32;")))
                              ),
                              plotlyOutput(ns("bemonc_chart"), height = "350px")
                          )
                      ),
                      tabPanel(title = "CEmONC",
                          div(class = "container",
                              div(class = "row",
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #FFCCBC;",
                                          h5("Facilities Assessed", style = "color: #BF360C;"),
                                          h3("677", style = "color: #BF360C;"),
                                          h6("32% of delivery facilities", style = "color: #BF360C;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E3F2FD;",
                                          h5("Overall Readiness", style = "color: #1565C0;"),
                                          h3("50%", style = "color: #1565C0;"))),
                                  div(class = "col-md-4",
                                      div(class = "stat-card", style = "background-color: #E8F5E9;",
                                          h5("Avg Quality Score", style = "color: #2E7D32;"),
                                          h3("68%", style = "color: #2E7D32;")))
                              ),
                              plotlyOutput(ns("cemonc_chart"), height = "350px")
                          )
                      )
                    )
                )
            ),

            # Immunization
            tabPanel(title = "Immunization",
                div(class = "container",
                    h4("Immunization Services Assessment", style = "color: #66BB6A;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #C8E6C9;",
                                h5("Facilities Assessed", style = "color: #388E3C;"),
                                h3("2,560", style = "color: #388E3C;"),
                                h6("73% of total", style = "color: #388E3C;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("85%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #FFF3E0;",
                                h5("Avg Quality Score", style = "color: #E65100;"),
                                h3("88%", style = "color: #E65100;")))
                    ),

                    div(class = "row",
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Immunization Tracer Services"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("imm_services_chart"), height = "300px")))),
                        div(class = "col-md-6",
                            div(class = "panel panel-default",
                                div(class = "panel-heading", "Availability of Immunization Tracer Items"),
                                div(class = "panel-body",
                                    plotlyOutput(ns("imm_items_chart"), height = "300px"))))
                    ),

                    plotlyOutput(ns("imm_county_chart"), height = "350px")
                )
            ),

            # Nutrition
            tabPanel(title = "Nutrition",
                div(class = "container",
                    h4("Nutrition Services Assessment", style = "color: #8D6E63;"),

                    div(class = "row",
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #D7CCC8;",
                                h5("Facilities Assessed", style = "color: #5D4037;"),
                                h3("1,791", style = "color: #5D4037;"),
                                h6("51% of total", style = "color: #5D4037;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E3F2FD;",
                                h5("Overall Readiness", style = "color: #1565C0;"),
                                h3("58%", style = "color: #1565C0;"))),
                        div(class = "col-md-4",
                            div(class = "stat-card", style = "background-color: #E8F5E9;",
                                h5("Avg Quality Score", style = "color: #2E7D32;"),
                                h3("70%", style = "color: #2E7D32;")))
                    ),

                    plotlyOutput(ns("nutrition_chart"), height = "350px")
                )
            )
          )
        )
      )
    ),

    # Legend section
    div(
      class = "container",
      style = "margin-top: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 10px;",
      h5("Legend - Service Categories", style = "font-weight: bold;"),
      div(class = "row",
          div(class = "col-md-2", div(style = "display: inline-block; width: 15px; height: 15px; background: #2E86AB; margin-right: 5px;"), "Diagnostics"),
          div(class = "col-md-2", div(style = "display: inline-block; width: 15px; height: 15px; background: #A23B72; margin-right: 5px;"), "Equipment"),
          div(class = "col-md-2", div(style = "display: inline-block; width: 15px; height: 15px; background: #F18F01; margin-right: 5px;"), "Guidelines"),
          div(class = "col-md-2", div(style = "display: inline-block; width: 15px; height: 15px; background: #28A745; margin-right: 5px;"), "Services"),
          div(class = "col-md-2", div(style = "display: inline-block; width: 15px; height: 15px; background: #C73E1D; margin-right: 5px;"), "Trained Staff"),
          div(class = "col-md-2", div(style = "display: inline-block; width: 15px; height: 15px; background: #9575CD; margin-right: 5px;"), "Commodities")
      )
    )
  )
}