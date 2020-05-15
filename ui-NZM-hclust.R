

fluidPage(column(width = 12,
                 tabBox(title = "", width = NULL,
                        tabPanel(title = tagList(icon("dna"), "genes to samples heatmap"),
                                 fluidRow(column(width = 3,
                                                 box(title = tagList(icon("dna"), "Enter Parameters for the plot"),
                                                     width = NULL,
                                                     solidHeader = TRUE,
                                                     status = "primary",
                                                     footer = "press make plot to generate the new figure",
                                                     #uiOutput("NZM_geneheatmap_samples_output"), 
                                                     checkboxInput("NZM_geneheatmap_samples","Select samples instead of showing all samples?", value=FALSE),
                                                     conditionalPanel("input.NZM_geneheatmap_samples==true",
                                                                      selectizeInput(inputId= "NZM_geneheatmap_samplelist", label = "select your samples:",choices = NZM_all_samples, multiple = TRUE)),
                                                     textAreaInput(inputId = "NZM_geneheatmap_genelist", label = "Enter your genes", rows = 5,
                                                                   value = "",
                                                                   placeholder = "Input one gene per line. At least 2 genes are required"),
                                                     selectizeInput(inputId = "NZM_geneheatmap_dist", label = "distance method", choices = c("euclidean", "maximum", "manhattan", "canberra", "binary","minkowski"), selected = "euclidean"),
                                                     selectizeInput(inputId = "NZM_geneheatmap_hclust", label = "hierarchical clustering method", choices =  c("ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid"), selected = "complete"),
                                                     selectizeInput(inputId = "NZM_geneheatmap_color", label = "color", choices =  c("RdYlGn", "GnBu", "cool_warm", "RdBu", "RdYlBu", "OrRd", "Spectral", "RdYlGn"), selected = "GnBu"),
                                                     sliderInput(inputId = "NZM_geneheatmap_colsize", label = "sample name size", min = 0, max = 20, value = 4, step = 1),
                                                     sliderInput(inputId = "NZM_geneheatmap_rowsize", label = "gene name size", min = 0, max = 20, value = 10, step = 1),
                                                     do.call(actionBttn, c(list( inputId = "NZM_make_geneheatmap", label = "make plot", icon = icon("play")), actionBttnParams)),
                                                 )),
                                          column(width = 9,
                                                 box(title = "heatmap",
                                                     status = "primary",
                                                     solidHeader = TRUE,
                                                     width = NULL,
                                                     #This was done to test what kind of output textAreaInput gives
                                                     #textOutput("NZM_geneheatmap_genelist_out"),
                                                     plotly::plotlyOutput("NZM_hclust_heatmap_out", height = "600px") %>% withSpinner(),
                                                 )
                                          )))
                       
                 )
)
)
                        