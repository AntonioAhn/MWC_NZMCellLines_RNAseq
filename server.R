source(file = "global.R",
       local = TRUE,
       encoding = "UTF-8")


shinyServer(function(input, output, session){
  # NZM RNAseq data
    ## make boxplot
    source(file = "server-NZM-boxplot.R",
           local = TRUE,
           encoding = "UTF-8")
    ## make corplot
   source(file = "server-NZM-corplot.R",
         local = TRUE,
         encoding = "UTF-8")
  ## make PCAplot
 source(file = "server-NZM-PCA.R",
        local = TRUE,
        encoding = "UTF-8")
  ## make hclust 
  source(file = "server-NZM-hclust.R",
         local = TRUE,
         encoding = "UTF-8")
})

