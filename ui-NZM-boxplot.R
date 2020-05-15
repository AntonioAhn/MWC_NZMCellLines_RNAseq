


fluidPage(column(width = 12,
                 tabBox(title = "", width = NULL,
                        tabPanel(title = tagList(icon("dna"), "Boxplot (all samples)"),
                                 fluidPage(column(width = 3,
                                                  box(title = tagList(icon("dna"), "Enter Parameters"),
                                                      width = NULL,
                                                      solidHeader = TRUE,
                                                      status = "primary",
                                                      footer = "press make plot to generate the new figure",
                                                      textInput(inputId= "NZM_boxplot_gene1", label = h3("Enter your gene:"), value = "CD274"),
                                                      radioButtons(inputId = "NZM_boxplot_mutgrp", 
                                                                   label = "select mutation group", 
                                                                   choices = list("all samples" = "symbols","BRAF/NRAS/WT" = "mut.subtype", "TERT" = "TERT.subtype"), 
                                                                   selected = "symbols"),
                                                      do.call(actionBttn, c(list( inputId = "NZM_make_boxplot_all", label = "make plot", icon = icon("play")), actionBttnParams)),
                                                      downloadButton(outputId = "NZM_download_boxplot_data_all", label = "Download data")
                                                      )
                                                  ),
                                           column(width = 9,
                                                  box(title = "Boxplot all",
                                                      status = "primary",
                                                      solidHeader = TRUE,
                                                      width = NULL,
                                                      plotly::plotlyOutput("plotly_NZM_boxplot_all") %>% withSpinner(),
                                                      DT::DTOutput("DT_NZM_boxplot") %>% withSpinner()
                                                  )
                                           )
                                 )
                        ),
                        tabPanel(title = tagList(icon("dna"), "Boxplot (groups)"),
                                 fluidPage(column(width = 3,
                                                  box(title = tagList(icon("dna"), "Enter Parameters for the group boxplot"),
                                                      width = NULL,
                                                      solidHeader = TRUE,
                                                      status = "primary",
                                                      textInput(inputId= "NZM_boxplot_gene2", label = h3("Enter your gene:"), value = ""),
                                                      selectizeInput(inputId = "NZM_sampleselect_g1_boxplot","Select group 1",choices= NZM_all_samples, multiple=TRUE),
                                                      selectizeInput(inputId = "NZM_sampleselect_g2_boxplot","Select group 2",choices= NZM_all_samples, multiple=TRUE),
                                                      selectizeInput(inputId = "NZM_sampleselect_g3_boxplot","Select group 3",choices= NZM_all_samples, multiple=TRUE),
                                                      selectizeInput(inputId = "NZM_sampleselect_g4_boxplot","Select group 4",choices= NZM_all_samples, multiple=TRUE),
                                                      do.call(actionBttn, c(list( inputId = "NZM_make_boxplot_groups", label = "make plot", icon = icon("play")), actionBttnParams)),
                                                      downloadButton(outputId = "NZM_download_boxplot_data_groups", label = "Download data")
                                                  )),
                                           column(width = 9,
                                                  box(title = "Boxplot groups",
                                                      status = "primary",
                                                      solidHeader = TRUE,
                                                      width = NULL,
                                                      plotly::plotlyOutput("NZM_boxplot_groups") %>% withSpinner(),
                                                      DT::DTOutput("DT_NZM_boxplot_groups") %>% withSpinner(),
                                                  )
                                           )
                                 )
                        )
                 )
)
)
                                                  