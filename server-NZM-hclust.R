# Code line below was done to test what kind of output textAreaInput gives
# output$NZM_geneheatmap_genelist_out <- renderText(input$NZM_geneheatmap_genelist)

# batch1 heatmap 


NZM_hclust_df  <- eventReactive(input$NZM_make_geneheatmap, {
  df <- filter(NZM_RNAseqdata_corplot, symbols %in% unlist(strsplit(x = input$NZM_geneheatmap_genelist, split = '[\r\n]'))) %>% 
    data.frame
  genenames <- df$symbols
  df <- df[,colnames(df) != "symbols"]
  rownames(df) <- genenames
  df %>% 
    t %>% 
    scale(center = TRUE, scale = TRUE) %>% 
    t %>% 
    data.frame()
},
ignoreNULL = TRUE,
ignoreInit = FALSE
)


NZM_hclust_df_filtered <- reactive({
  if (input$NZM_geneheatmap_samples) {
    dplyr::select(NZM_hclust_df(), input$NZM_geneheatmap_samplelist)
  } else {
  NZM_hclust_df()
  }
})


NZM_hclust_heatmap <- eventReactive(input$NZM_make_geneheatmap,{
  heatmaply(
  NZM_hclust_df_filtered(),
  labRow = rownames(NZM_hclust_df_filtered()),
  labCol = colnames(NZM_hclust_df_filtered()),
  fontsize_col = input$NZM_geneheatmap_colsize,
  fontsize_row = input$NZM_geneheatmap_rowsize,
  dist_method = input$NZM_geneheatmap_dist, 
  hclust_method = input$NZM_geneheatmap_hclust,
  colors = get(input$NZM_geneheatmap_color)
  ) %>% 
    config(
      toImageButtonOptions = list(
        format = "PNG",
        filename = "heatmap",
        width = 1500,
        height = 1800
      )
    )
},
ignoreNULL = TRUE,
ignoreInit = TRUE
)



### render plot
output$NZM_hclust_heatmap_out <- renderPlotly(NZM_hclust_heatmap())


