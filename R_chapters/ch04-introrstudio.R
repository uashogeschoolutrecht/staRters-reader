## ---- message=FALSE, error=FALSE, warning=FALSE---------------------------------------------------------
library(tidyverse)


## ---- rstudiointerface, fig.cap="The RStudio IDE interface. You can see the four windows here. They are explained below"----
 knitr::include_graphics(path = here::here("images", "rstudio_interface.png"))


## -------------------------------------------------------------------------------------------------------
beaver_telemetry <- datasets::beaver1 %>% 
        ggplot(aes(x = time, y = temp)) +
        geom_point(aes(colour = as_factor(activ))) +
        ggtitle("Body temperature of beavers")

beaver_telemetry



## ---- eval=FALSE----------------------------------------------------------------------------------------
## 
## ## clear environment
## rm(list=ls())
## 
## ## source R script
## source(
##   here::here(
##     "code",
##     "beavers.R"
##   )
## )
## 


## ---- eval = FALSE--------------------------------------------------------------------------------------
## beaver_telemetry <- datasets::beaver1 %>%
##        ggplot(aes(x = time, y = temp)) +
##        geom_point(aes(colour = as_factor(activ))) +
##        ggtitle("Body temperature of beavers")
## 
## beaver_telemetry


## ---- eval=FALSE----------------------------------------------------------------------------------------
## DiagrammeR::grViz("
## digraph rmarkdown {
##   'RStudio Project' -> 'Commit'
##   'RStudio Project' -> 'Local Git repo'
##   'Local Git repo' -> 'Remote Github repo'}")


## ---- eval=FALSE----------------------------------------------------------------------------------------
## ###
## # Perform traversals with conditions
## # based on node `label` regex matches
## ###
## 
## library(DiagrammeR)
## library(magrittr)
## 
## # Create a graph with fruit, vegetables,
## # and nuts
## df <- data.frame(col1 = c("Cat", "Dog", "Bird"),
##                  col2 = c("Feline", "Canis", "Avis"),
##                  stringsAsFactors = FALSE)
## uniquenodes <- unique(c(df$col1, df$col2))
## 
## uniquenodes
## 
## library(DiagrammeR)
## 
## nodes <- create_node_df(n=length(uniquenodes),
##                         type="number",
##                         label=uniquenodes)
## edges <- create_edge_df(from=match(df$col1, uniquenodes),
##                         to=match(df$col2, uniquenodes),
##                         rel="related")
## g <- create_graph(nodes_df=nodes,
##                   edges_df=edges)
## render_graph(g)

