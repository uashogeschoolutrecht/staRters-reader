## extract R code from all chapters

## Packages
library(tidyverse)

pyurl_chapters <- function(){


## Rmd list
files_in <- list.files(
  path = here::here(
    "."
  ),
  pattern = ".Rmd",
  full.names = TRUE
)

paths_out <- files_in %>%
  basename() %>%
  str_replace_all(
    string = .,
    pattern = ".Rmd",
    replacement = ".R")

files_out <- file.path("C:/Users/mteunis/workspaces/staRters/R_chapters", paths_out)

walk2(
  .x = files_in,
  .y = files_out,
  .f = knitr::purl
)

}
