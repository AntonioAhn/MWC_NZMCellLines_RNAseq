
# Correlation plot where all samples are used
### make the reactive dataframe
NZM_RNAseqdata_corplot_df <- eventReactive(input$NZM_make_corplot, {
  NZM_RNAseqdata_corplot %>% 
    filter(symbols %in% c(isolate({input$NZM_corplot_gene1}), isolate({input$NZM_corplot_gene2}), isolate({input$NZM_corplot_gene3}))) %>% 
    data.frame(row.names = 1) %>% 
    t %>% 
    as_tibble(rownames = "samples") %>% 
    mutate(mut.subtype = NZM_mutation_info$mut.subtype[match(samples, NZM_mutation_info$NZM_matched)] %>% factor(levels = c("BRAF", "NRAS", "WT", "UD")),
           TERT.subtype = NZM_mutation_info$TERT[match(samples, NZM_mutation_info$NZM_matched)] %>% factor(levels = c("C228T", "C250T", "C228T/C250T", "WT", "UD"))
           #no.subtype = rep("group", 74)
    ) 
    #mutate(batch = ifelse(samples %in%  NZM_batch1_samples, "batch1", "batch2"))
}, 
ignoreNULL = TRUE,
ignoreInit = FALSE)

## -----------
### make the reactive plotly named _corplot
NZM_plotly_corplot <- eventReactive(input$NZM_make_corplot, {
  if(input$NZM_corplot_optional_gene3 == "none"){
    NZM_RNAseqdata_corplot_df() %>% 
    plot_ly(x = ~get(isolate({input$NZM_corplot_gene1})), y = ~get(isolate({input$NZM_corplot_gene2})), hoverinfo = "text",
            text = ~paste0(isolate({input$NZM_corplot_gene1}), ": ", get(isolate({input$NZM_corplot_gene1})), "<br>",
                           isolate({input$NZM_corplot_gene2}), ": ", get(isolate({input$NZM_corplot_gene2})), "<br>",
                           'sample: ', samples, "<br>")) %>% 
      layout(xaxis = list(title = paste(isolate({input$NZM_corplot_gene1}), "(log2 TPM)")), 
             yaxis = list(title = paste(isolate({input$NZM_corplot_gene2}), "(log2 TPM)"))) %>% 
      add_markers(size = 20)
  } else if(input$NZM_corplot_optional_gene3 == "third_gene"){
    # colors = c("darkblue","red","darkred") 
    # "Bluered"
    # colors = "Blues"
    NZM_RNAseqdata_corplot_df() %>% 
    plot_ly(x = ~get(isolate({input$NZM_corplot_gene1})), y = ~get(isolate({input$NZM_corplot_gene2})), hoverinfo = "text", color = ~get(isolate({input$NZM_corplot_gene3})),
            type = "scatter", mode = "markers", size = 20, 
            text = ~paste0(isolate({input$NZM_corplot_gene1}), ": ", get(isolate({input$NZM_corplot_gene1})), "<br>",
                           isolate({input$NZM_corplot_gene2}), ": ", get(isolate({input$NZM_corplot_gene2})), "<br>",
                           'sample: ', samples, "<br>")) %>%
      colorbar(title = input$NZM_corplot_gene3) %>% 
      layout(xaxis = list(title = paste(isolate({input$NZM_corplot_gene1}), "(log2 TPM)")), 
             yaxis = list(title = paste(isolate({input$NZM_corplot_gene2}), "(log2 TPM)")))
  } else {
    NZM_RNAseqdata_corplot_df() %>% 
    plot_ly(x = ~get(isolate({input$NZM_corplot_gene1})), y = ~get(isolate({input$NZM_corplot_gene2})), hoverinfo = "text", symbol = ~get(isolate({input$NZM_corplot_mutgrp})),
            text = ~paste0(isolate({input$NZM_corplot_gene1}), ": ", get(isolate({input$NZM_corplot_gene1})), "<br>",
                           isolate({input$NZM_corplot_gene2}), ": ", get(isolate({input$NZM_corplot_gene2})), "<br>",
                           'sample: ', samples, "<br>")) %>% 
      layout(xaxis = list(title = paste(isolate({input$NZM_corplot_gene1}), "(log2 TPM)")), 
             yaxis = list(title = paste(isolate({input$NZM_corplot_gene2}), "(log2 TPM)"))) %>% 
      add_markers(size = 20)
  }
}, 
ignoreNULL = FALSE, 
ignoreInit = FALSE)


### render gg_corplot
output$NZM_plotly_corplot_out <- renderPlotly(NZM_plotly_corplot())

## -----------
### generate correlation values 
NZM_corvalues <- eventReactive(input$NZM_make_corplot, {
  df <-  NZM_RNAseqdata_corplot_df()
  corvalue <- cor(df[[input$NZM_corplot_gene1]],  df[[input$NZM_corplot_gene2]])
  corpvalue <- cor.test(df[[input$NZM_corplot_gene1]],  df[[input$NZM_corplot_gene2]])$p.value
  paste("Pearson correlation value =",corvalue ,"pvalue =", corpvalue)
}, 
ignoreNULL = FALSE,
ignoreInit = FALSE)

output$NZM_corvalues_out <- renderText(NZM_corvalues())

## -----------
# output for data table

# div(DT::dataTableOutput("table"), style = "font-size: 75%; width: 75%")

# renderDataTable
# output$DT_NZM_corplot_df <- div(DT::renderDT(NZM_RNAseqdata_corplot_df()),  style = "font-size: 75%; width: 75%")
# output$DT_NZM_corplot_df <- div(DT::renderDataTable(NZM_RNAseqdata_corplot_df()),  style = "font-size: 75%; width: 75%")


output$DT_NZM_corplot_df <- DT::renderDataTable(NZM_RNAseqdata_corplot_df())

# filter(batch %in% input$NZM_corplot_batch))

## -----------
# output for downloading the data

output$NZM_download_corplot_data <- downloadHandler(
  filename = "NZM_corplot_data.csv",
  content = function(file) {
    # Code that creates a file in the path <file>
    write.csv(NZM_RNAseqdata_corplot_df(), file)
  }
)

## --------------------------------------------------------------------------------

# Co-expression analysis

NZM_RNAseqdata_coexp_df <- eventReactive(input$NZM_make_coexp,{
    df <- NZM_RNAseqdata_corplot %>% data.frame(row.names = TRUE) %>% as.matrix
    # taking out the genes (1003 genes, leaving 23610 genes left) with a row variance of 0. These genes cannot have a correlation value therefore warning meassages that comes up seems to slow down this function
    df <- df[(apply(df, 1, var)) != 0,]
    geneexpr <- df[input$NZM_coexp_gene1,]
    cor.df <- apply(df, 1, function(x){cor(geneexpr, x, method = input$NZM_coexp_method) }) %>% 
      sort(decreasing=TRUE) %>% 
      data.frame()
    colnames(cor.df) <- "cor"
    cor.df$p.value <- apply(df[rownames(cor.df),], 1, function(x){cor.test(geneexpr, x, method = input$NZM_coexp_method)$p.value})
    return(cor.df)
    }, 
    ignoreNULL = FALSE,
    ignoreInit = TRUE)


output$DT_NZM_coexp_df <- DT::renderDT({NZM_RNAseqdata_coexp_df()})


## -----------
# output for downloading the data

output$NZM_download_coexp_data <- downloadHandler(
  filename = "NZM_coexp_data.csv",
  content = function(file) {
    # Code that creates a file in the path <file>
    write.csv(NZM_RNAseqdata_coexp_df(), file)
  }
)



## ----------------------------------------------------------------------------------------------------------------------------------------------
## ----------------------------------------------------------------------------------------------------------------------------------------------

# Correlation plot for where only selected samples are looked at 
### make the reactive dataframe
NZM_RNAseqdata_corplot_samples_df <- eventReactive(input$NZM_make_corplot_samples, {
  NZM_RNAseqdata_corplot %>% 
    filter(symbols %in% c(isolate({input$NZM_corplot_samples_gene1}), isolate({input$NZM_corplot_samples_gene2}), isolate({input$NZM_corplot_samples_gene3}))) %>% 
    data.frame(row.names = 1) %>% 
    t %>% 
    as_tibble(rownames = "samples") %>% 
    mutate(mut.subtype = NZM_mutation_info$mut.subtype[match(samples, NZM_mutation_info$NZM_matched)] %>% factor(levels = c("BRAF", "NRAS", "WT", "UD")),
           TERT.subtype = NZM_mutation_info$TERT[match(samples, NZM_mutation_info$NZM_matched)] %>% factor(levels = c("C228T", "C250T", "C228T/C250T", "WT", "UD"))
    )
}, 
ignoreNULL = FALSE,
ignoreInit = TRUE)

## -----------
### make the reactive plotly named _corplot
NZM_plotly_corplot_samples <- eventReactive(input$NZM_make_corplot_samples, {
  if(input$NZM_corplot_optional_samples_gene3 == "none"){
    NZM_RNAseqdata_corplot_samples_df() %>% 
      filter(samples %in% input$NZM_sampleselect_g1_corplot) %>% 
      plot_ly(x = ~get(isolate({input$NZM_corplot_samples_gene1})), y = ~get(isolate({input$NZM_corplot_samples_gene2})), hoverinfo = "text",
              text = ~paste0(input$NZM_corplot_samples_gene1, ": ", get(isolate({input$NZM_corplot_samples_gene1})), "<br>",
                             input$NZM_corplot_samples_gene2, ": ", get(isolate({input$NZM_corplot_samples_gene2})), "<br>",
                             'sample: ', samples)) %>% 
      layout(xaxis = list(title = paste(isolate({input$NZM_corplot_samples_gene1}), "(log2 TPM)")), 
             yaxis = list(title = paste(isolate({input$NZM_corplot_samples_gene2}), "(log2 TPM)"))
      ) %>% 
      add_markers(color = I("dodgerblue4"), size = 20)
  } else if(input$NZM_corplot_optional_samples_gene3 == "third_gene"){
    NZM_RNAseqdata_corplot_samples_df() %>% 
      filter(samples %in% input$NZM_sampleselect_g1_corplot) %>% 
      plot_ly(x = ~get(isolate({input$NZM_corplot_samples_gene1})), y = ~get(isolate({input$NZM_corplot_samples_gene2})), color = ~get(isolate({input$NZM_corplot_samples_gene3})), hoverinfo = "text",
              mode = "markers", type = "scatter", size = 20,
              text = ~paste0(input$NZM_corplot_samples_gene1, ": ", get(isolate({input$NZM_corplot_samples_gene1})), "<br>",
                             input$NZM_corplot_samples_gene2, ": ", get(isolate({input$NZM_corplot_samples_gene2})), "<br>",
                             'sample: ', samples)) %>% 
      colorbar(title = input$NZM_corplot_samples_gene3) %>% 
      layout(xaxis = list(title = paste(isolate({input$NZM_corplot_samples_gene1}), "(log2 TPM)")), 
             yaxis = list(title = paste(isolate({input$NZM_corplot_samples_gene2}), "(log2 TPM)"))
             ) 
  } else {
    NZM_RNAseqdata_corplot_samples_df() %>% 
      filter(samples %in% input$NZM_sampleselect_g1_corplot) %>% 
      plot_ly(x = ~get(isolate({input$NZM_corplot_samples_gene1})), y = ~get(isolate({input$NZM_corplot_samples_gene2})), symbol = ~get(isolate({input$NZM_corplot_samples_mutgrp})), hoverinfo = "text",
              mode = "markers", type = "scatter", size = 20,
              text = ~paste0(input$NZM_corplot_samples_gene1, ": ", get(isolate({input$NZM_corplot_samples_gene1})), "<br>",
                             input$NZM_corplot_samples_gene2, ": ", get(isolate({input$NZM_corplot_samples_gene2})), "<br>",
                             'sample: ', samples)) %>% 
      layout(xaxis = list(title = paste(isolate({input$NZM_corplot_samples_gene1}), "(log2 TPM)")), 
             yaxis = list(title = paste(isolate({input$NZM_corplot_samples_gene2}), "(log2 TPM)"))
      ) 
  }
}, 
ignoreNULL = FALSE, 
ignoreInit = TRUE)


### render gg_corplot
output$NZM_plotly_corplot_samples_out <- plotly::renderPlotly({NZM_plotly_corplot_samples()})
  
  
#  validate(
#    need(isolate({input$corplot_gene3}) != '', 'Please choose the genes for the sample analysis')
#    )
#  plotly_corplot_samples()
#  })


## -----------
### generate correlation values 
NZM_corvalues_samples <- eventReactive(input$NZM_make_corplot_samples, {
  df <-  NZM_RNAseqdata_corplot_samples_df() %>% filter(samples %in% input$NZM_sampleselect_g1_corplot)
  corvalue <- cor(df[[input$NZM_corplot_samples_gene1]],  df[[input$NZM_corplot_samples_gene2]])
  corpvalue <- cor.test(df[[input$NZM_corplot_samples_gene1]],  df[[input$NZM_corplot_samples_gene2]])$p.value
  paste("Pearson correlation value =",corvalue ,"pvalue =", corpvalue)
}, 
ignoreNULL = FALSE,
ignoreInit = TRUE)

output$NZM_corvalues_samples_out <- renderText(NZM_corvalues_samples())

## ------
# datatable for the samples df
output$DT_NZM_corplot_samples_df <- DT::renderDT(NZM_RNAseqdata_corplot_samples_df() %>% 
                                              filter(samples %in% input$NZM_sampleselect_g1_corplot))



###------
# output for downloading the data

output$NZM_download_corplot_data_samples <- downloadHandler(
  filename = "NZM_corplot_data.csv",
  content = function(file) {
    # Code that creates a file in the path <file>
    write.csv(NZM_RNAseqdata_corplot_samples_df(), file)
  }
)

