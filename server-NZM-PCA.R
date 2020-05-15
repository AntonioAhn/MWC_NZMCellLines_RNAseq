
### make the reactive prcomp dataframe
NZM_prcomp_df <- eventReactive(input$NZM_make_PCAplot, {
  PCA.df <- data.frame(NZM_RNAseqdata_corplot, row.names = 1)[,c(input$NZM_PCAplot_samples_g1,input$NZM_PCAplot_samples_g2,input$NZM_PCAplot_samples_g3,input$NZM_PCAplot_samples_g4)]
  high_var_genes <- PCA.df %>% apply(1, var) %>% sort(decreasing = TRUE) %>% head(n = input$NZM_PCAplot_topgenes) %>% names
  prcomp.df <- prcomp(t(PCA.df[high_var_genes,]), center = input$NZM_PCAplot_centre, scale = input$NZM_PCAplot_scale)
  prcomp.df
},
ignoreNULL = TRUE,
ignoreInit = FALSE
)

### get summary prcomp percentage for x and y chosen PC's
NZM_prcomp_summary <- eventReactive(input$NZM_make_PCAplot, {
  c(summary(NZM_prcomp_df())$importance[2,input$NZM_PCAplot_PCx] * 100, summary(NZM_prcomp_df())$importance[2,input$NZM_PCAplot_PCy] * 100)
},
ignoreNULL = TRUE,
ignoreInit = FALSE
)


### Generate the plot_ly marker plot
NZM_plotly_PCAplot <- eventReactive(input$NZM_make_PCAplot, {
  (NZM_prcomp_df()$x)[,1:((NZM_prcomp_df()$x) %>% colnames %>% length())] %>% as_tibble(rownames = "samples") %>% 
    mutate(groups = ifelse(samples %in% input$NZM_PCAplot_samples_g1, "group1", 
                           ifelse(samples %in% input$NZM_PCAplot_samples_g2, "group2", 
                                  ifelse(samples %in% input$NZM_PCAplot_samples_g3,  "group3", "group4")))) %>%  
    plot_ly(symbol = ~groups) %>% 
    add_markers(x = ~get(isolate({input$NZM_PCAplot_PCx})), y = ~get(isolate({input$NZM_PCAplot_PCy})), size = 20, hoverinfo = "text", colors = fut_color[1:4],
              text = ~paste0(input$NZM_PCAplot_PCx, ": ", get(isolate({input$NZM_PCAplot_PCx})), "<br>",
                             input$NZM_PCAplot_PCy, ": ", get(isolate({input$NZM_PCAplot_PCy})), "<br>",
                             'sample: ', samples)) %>% 
    layout(xaxis = list(title = paste0(input$NZM_PCAplot_PCx, " (",NZM_prcomp_summary()[1], "%)")), 
         yaxis = list(title = paste0(input$NZM_PCAplot_PCy, " (",NZM_prcomp_summary()[2], "%)")))
},
ignoreNULL = FALSE,
ignoreInit = TRUE
)

### render gg_corplot
output$NZM_plotly_PCAplot_out <- renderPlotly(NZM_plotly_PCAplot())



