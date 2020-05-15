library(shiny)
library(shinydashboard)
library(DT)
library(shinyWidgets)

tagList(dashboardPage(skin = "blue",
    dashboardHeader(
    title = "NZM cell lines analysis",
    titleWidth = 500,
    dropdownMenu(
        type = "messages",
        messageItem(
            from = "Cancer Hub",
            message = "Go to CancerHub",
            icon = icon("book"),
            time = "Published 2019-07-09",
            href = "https://cancerhub.net/"
        ),
        messageItem(
            from = "Source Code",
            message = "Available on Github",
            time = "Update at 2020-04-13",
            href = "https://github.com/AntonioAhn/MWC_NZMCellLines_RNAseq"
        ),
        messageItem(
            from = "About Us",
            message = "Go to the Eccles Homepage",
            icon = icon("users"),
            href = "https://www.otago.ac.nz/dsm-pathology/research/otago114692.html"
        ),
        icon = icon("info-circle"),
        headerText = "INFORMATIONS"
    )
    ),
    dashboardSidebar(
      sidebarMenu(id = "side_bar",
                    menuItem(text = "Information",
                             tabName = "Info"),
                    menuItem(text = "RNAseq data",
                             tabName = "RNAseq_NZM", 
                             badgeLabel = "NZM cell lines",
                             badgeColor = "blue"),
                    menuItem(text = "DNA methylation Data (RRBS)",
                             tabName = "RRBS")
        )
    ),
    dashboardBody(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
      tabItems(
        tabItem(tabName = "Info", tabBox(title = "", width = NULL,
                                         tabPanel(title = "Welcome to CanerHub",
                                                  icon = icon("info"),
                                                  fluidRow(column(includeMarkdown("document/Information.md"), width = 12, offset = 0))),
                                         tabPanel(title = "NZM cell lines information",
                                                  icon = icon("info"),
                                                  fluidRow(column(includeMarkdown("document/NZMcellLines.md"), width = 12, offset = 0)))
                                         )),
        tabItem(tabName = "RRBS"),
        tabItem(tabName = "RNAseq_NZM",
                tabBox(title = "", width = NULL, 
                       tabPanel(title = "Boxplot all samples",
                                source(
                                  file = "ui-NZM-boxplot.R",
                                  local = TRUE,
                                  encoding = "UTF-8"
                                  )
                           ),
                       tabPanel(title = "correlation plot",
                                source(
                                  file = "ui-NZM-corplot.R",
                                  local = TRUE,
                                  encoding = "UTF-8"
                                  )
                                ),
                       tabPanel(title = "PCA plot",
                                source(
                                  file = "ui-NZM-PCA.R",
                                  local = TRUE,
                                  encoding = "UTF-8"
                                  )
                                ),
                       tabPanel(title = "heatmap (sample and gene hclustering)",
                                source(
                                  file = "ui-NZM-hclust.R",
                                  local = TRUE,
                                  encoding = "UTF-8"
                                )
                       )
                    
                    )
            )
      )
    )
),
tags$footer(
    tags$p("Copyright © 2019"), 
    tags$a(" Cancer Hub", href = "https://cancerhub.net/"),
#    tags$a(" Eccles Lab ", href = "https://www.otago.ac.nz/dsm-pathology/research/otago114692.html"), 
#   tags$a(" Chatterjee Lab ", href = "https://www.otago.ac.nz/chatterjee-lab/index.html"),
#    tags$a(" University of Otago ", href = "https://www.otago.ac.nz/"), 
    tags$p("Version 13/04/20"),
    style = "
  bottom:0;
  width:100%;
  color: #B8C7CE;
  padding: 10px;
  background-color: #222D32;
  z-index: 1000;"
    )
)
                         