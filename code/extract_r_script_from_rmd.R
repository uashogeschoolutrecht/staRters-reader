## extract all R code from the chapter
## demo's into a folder called code_demos:

list_rmd <- list.files(
  path = here::here(),
  pattern = "\\.Rmd"
)

dir.create(
  path = here::here("code_demos")
)

output_folder <- file.path(
  here::here("code_demos")
)

output_names <- file.path(
  output_folder, list_rmd
)

output_names <- str_replace_all(
  string = output_names,
  pattern = "Rmd",
  replacement = "R")


map2(
  .x = list_rmd,
  .y = output_names,
  .f = knitr::purl)
