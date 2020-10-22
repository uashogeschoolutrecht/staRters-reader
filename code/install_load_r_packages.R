## CRAN packages
if(!require("pacman")){
  install.packages("pacman")
  library(pacman)
} else {
  library(pacman)
}
p_load(
  zoo,
  tidyverse,
  rvest,
  XML,
  plotly,
  tidyverse,
  rprojroot,
  rJava,
  xlsx,
  EBImage,
  jpeg,
  tiff,
  mixtools,
  cowplot,
  gplots,
  gdata, 
  car, 
  pastecs, 
  psych, 
  nlme, 
  pander, 
  xtable, 
  plsdepot, 
  data.table, 
  Rcpp, 
  Matrix,
  parallel, 
  ape, 
  phangorn, 
  stringi,
  downloader, 
  devtools, 
  circlize

)

install.packages("tidyverse")
library(tidyverse)
## Bioconductor packages
source("http://bioconductor.org/workflows.R")
workflowInstall("sequencing")

pacman::p_load(Biostrings,
       XVector,
       BiocGenerics,
       IRanges,
       S4Vectors,
       GenomicRanges,
       BSgenome)



source("https://bioconductor.org/biocLite.R")
biocLite("Glimma")
biocLite("limma")
biocLite("edgeR")

## Other packages
devtools::install_github("dgrtwo/gganimate")

library
packages <- as
