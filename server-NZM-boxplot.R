
## first boxplot (all samples)

NZM_boxplot_all_df <- eventReactive(input$NZM_make_boxplot_all, {filter(NZM_RNAseqdata_boxplot, symbols == input$NZM_boxplot_gene1)}, 
                              ignoreNULL = FALSE, 
                              ignoreInit = FALSE)


NZM_boxplot_all <- eventReactive(input$NZM_make_boxplot_all, {NZM_boxplot_all_df() %>% 
    plot_ly(y = ~values,  type = "box", boxpoints = "all", jitter = 1, hoverinfo = "text", symbol = ~get(isolate({input$NZM_boxplot_mutgrp})), pointpos = 0,
            text = ~paste0(input$NZM_boxplot_gene1, ": ",values, "<br>",
                           'sample: ', samples)) %>% 
    layout(yaxis = list(title = paste(isolate({input$NZM_boxplot_gene1}), "(log2 TPM)")), xaxis = list(showticklabels = TRUE, title = ""), showlegend = FALSE)
},
ignoreNULL = FALSE, 
ignoreInit = FALSE)


# render boxplot
output$plotly_NZM_boxplot_all <- plotly::renderPlotly(NZM_boxplot_all())

## --------

# output for downloading the data
output$NZM_download_boxplot_data_all <- downloadHandler(
  filename = "NZM_boxplot_data.csv",
  content = function(file) {
    # Code that creates a file in the path <file>
    write.csv(NZM_boxplot_all_df(), file)
  }
)

## ------
# output for the DT table

output$DT_NZM_boxplot <- DT::renderDT(NZM_boxplot_all_df())

## -------------------------------------------------------------------------



## second boxplot (with selected samples)

NZM_boxplot_groups_df <- eventReactive(input$NZM_make_boxplot_groups, {
  filter(NZM_RNAseqdata_boxplot, symbols == input$NZM_boxplot_gene2) %>% 
    mutate(newgroup = ifelse(samples %in% input$NZM_sampleselect_g1_boxplot, "group1",
                             ifelse(samples %in% input$NZM_sampleselect_g2_boxplot, "group2",
                                    ifelse(samples %in% input$NZM_sampleselect_g3_boxplot, "group3",
                                           ifelse(samples %in% input$NZM_sampleselect_g4_boxplot, "group4", "rest"))))) %>% 
    filter(newgroup %in% c("group1", "group2", "group3","group4"))
}, 
ignoreNULL = FALSE, 
ignoreInit = FALSE
)


NZM_boxplot_groups <- eventReactive(input$NZM_make_boxplot_groups, {NZM_boxplot_groups_df() %>% 
    plot_ly(color = ~newgroup) %>% 
    add_trace(x = ~as.numeric(factor(newgroup)), y = ~values, type = "box",  hoverinfo = 'name+y', colors =
                fut_color[1:4]) %>% 
    add_markers(x = ~jitter(as.numeric(factor(newgroup))), y = ~as.numeric(values), colors = fut_color[1:4],
                marker = list(size = 6),
                hoverinfo = "text",
                showlegend = FALSE,
                text = ~paste0(input$NZM_boxplot_gene2, ": ",values, "<br>",
                               'sample: ', samples)) %>% 
    layout(yaxis = list(title = paste(input$NZM_boxplot_gene2, "(log2 TPM)")),
           legend = list(orientation = "h", x =0.5, xanchor = "center", y = 1, yanchor = "bottom"),
           xaxis = list(title = "", showticklabels = FALSE))
})



# render boxplot
output$NZM_boxplot_groups <- plotly::renderPlotly({
  validate(
    need(input$NZM_boxplot_gene2 != '', 'Please choose a gene for the group analysis')
  )
  NZM_boxplot_groups()
})

## --------

# output for downloading the data
output$NZM_download_boxplot_data_groups <- downloadHandler(
  filename = "NZM_boxplot_groups_data.csv",
  content = function(file) {
    # Code that creates a file in the path <file>
    write.csv(NZM_boxplot_groups_df(), file)
  }
)


## -------------------------------------------------------------------------

output$DT_NZM_boxplot_groups <- DT::renderDT(NZM_boxplot_groups_df())



