

fluidPage(column(width = 12,
                 tabBox(title = "", width = NULL,
                        tabPanel(title = tagList(icon("dna"), "correlation plot"),
                                 fluidRow(column(width = 3,
                                           box(title = tagList(icon("dna"), "Enter Parameters for the correlation plot"),
                                               width = NULL,
                                               solidHeader = TRUE,
                                               status = "primary",
                                               footer = "press make_boxplot to generate the new figure",
                                               textInput(inputId= "NZM_corplot_gene1", label = "Enter your gene (x-axis):", value = "SOX10"), 
                                               textInput(inputId = "NZM_corplot_gene2", label = "Enter your gene (y-axis):", value = "MITF"),
                                               #tags$hr(),
                                               selectInput(input = "NZM_corplot_optional_gene3", label = "add a third gene or mutation status", choices  = c("none","third_gene", "mutation_status")),
                                               conditionalPanel(condition = "input.NZM_corplot_optional_gene3=='third_gene'",
                                                                textInput(inputId= "NZM_corplot_gene3", label = "Enter your gene", value = "CD274")),
                                               conditionalPanel(condition = "input.NZM_corplot_optional_gene3=='mutation_status'",
                                                                radioButtons(inputId = "NZM_corplot_mutgrp", 
                                                                             label = "select mutation group", 
                                                                             choices = list("BRAF/NRAS/WT" = "mut.subtype", "TERT" = "TERT.subtype"), 
                                                                             selected = "mut.subtype")),
                                               do.call(actionBttn, c(list( inputId = "NZM_make_corplot", label = "make plot", icon = icon("play")), actionBttnParams)),
                                               downloadButton(outputId = "NZM_download_corplot_data",label = "Download data"),
                                               )),
                                           column(width = 9,
                                                  box(title = "correlation plot",
                                                      status = "primary",
                                                      solidHeader = TRUE,
                                                      width = NULL,
                                                      plotly::plotlyOutput("NZM_plotly_corplot_out") %>% withSpinner(),
                                                      textOutput("NZM_corvalues_out"), 
                                                      # div(DT::dataTableOutput("DT_NZM_corplot_df"), style = "width: 75%") %>% withSpinner()
                                                      DT::dataTableOutput("DT_NZM_corplot_df") %>% withSpinner()

                                           )
                                    ))),
                        tabPanel(title = tagList(icon("dna"), "co-expression analysis"),
                                 fluidRow(column(width = 3,
                                                  box(title = tagList(icon("dna"), "co-expression analysis"),
                                                      width = NULL,
                                                      solidHeader = TRUE,
                                                      status = "primary",
                                                      textInput(inputId= "NZM_coexp_gene1", label = "Enter your gene", value = "PAX3"),
                                                      selectInput(inputId= "NZM_coexp_method", label = "correlation coefficient", choices = c("pearson","spearman","kendall"), selected = "pearson"),
                                                      do.call(actionBttn, c(list( inputId = "NZM_make_coexp", label = "make table", icon = icon("play")), actionBttnParams)),
                                                      downloadButton(outputId = "NZM_download_coexp_data",label = "Download data")
                                                  )
                                                  ),
                                           column(width = 9,
                                                  box(title = "coexpression analysis",
                                                      status = "primary",
                                                      solidHeader = TRUE,
                                                      width = NULL,
                                                      DT::DTOutput("DT_NZM_coexp_df") %>% withSpinner()
                                                      )
                                           )
                                 )
                        ), 
                        tabPanel(title = tagList(icon("dna"), "correlation plot (select samples)"),
                                 fluidRow(column(width = 3,
                                                  box(title = tagList(icon("dna"), "Enter Parameters for the correlation plot"),
                                                      width = NULL,
                                                      solidHeader = TRUE,
                                                      status = "primary",
                                                      # checkboxInput("NZM_selectsamples_corplot","Select sample groups?", value=FALSE), #upload a file of gene names
                                                      # conditionalPanel("input.NZM_selectsamples_corplot==true",
                                                      textInput(inputId= "NZM_corplot_samples_gene1", label = "Enter your gene (x-axis):", value = ""), 
                                                      textInput(inputId = "NZM_corplot_samples_gene2", label = "Enter your gene (y-axis):", value = ""),
                                                      selectizeInput(inputId = "NZM_sampleselect_g1_corplot","select samples",choices= NZM_all_samples, multiple=TRUE),
                                                      selectInput(input = "NZM_corplot_optional_samples_gene3", label = "add a third gene or mutation status", choices  = c("none","third_gene", "mutation_status")),
                                                      conditionalPanel(condition = "input.NZM_corplot_optional_samples_gene3=='third_gene'",
                                                                       textInput(inputId= "NZM_corplot_samples_gene3", label = "Enter your gene", value = "")),
                                                      conditionalPanel(condition = "input.NZM_corplot_optional_samples_gene3=='mutation_status'",
                                                                       radioButtons(inputId = "NZM_corplot_samples_mutgrp", 
                                                                                    label = "select mutation group", 
                                                                                    choices = list("BRAF/NRAS/WT" = "mut.subtype", "TERT" = "TERT.subtype"), 
                                                                                    selected = "mut.subtype")),
                                                      do.call(actionBttn, c(list( inputId = "NZM_make_corplot_samples", label = "make plot", icon = icon("play")), actionBttnParams)),
                                                      downloadButton(outputId = "NZM_download_corplot_data_samples", label = "Download data")
                                                      )
                                                 ),
                                          column(width = 9,
                                                 box(title = "correlation plot with selected samples",
                                                     status = "primary",
                                                     solidHeader = TRUE,
                                                     width = NULL,
                                                     plotly::plotlyOutput("NZM_plotly_corplot_samples_out") %>% withSpinner(),
                                                     textOutput("NZM_corvalues_samples_out"), 
                                                     DT::DTOutput("DT_NZM_corplot_samples_df") %>% withSpinner()
                                                 )
                                                 )
                                 )
                        )
                 )
)
)


                                                    
                                                  
                                                  
                   