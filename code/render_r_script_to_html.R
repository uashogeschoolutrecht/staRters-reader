library(knitr)
library(rmarkdown)
library(tidyverse)

## create r script from Rmd
list_rmd <- list.files(pattern = "\\.Rmd", full.names = TRUE)
list_rmd[[1]]


knitr::purl(list_rmd[[1]])

base_names <- basename(list_rmd)
base_names <- str_replace_all(string = base_names, pattern = "\\.Rmd",
                              replacement = "\\.R")


path_out <- here::here("code", "chapters", base_names)

## purl list of files to R scripts
map2(.x = list_rmd,
     .y = path_out,
     .f = knitr::purl)


