
get_dependencies <- function(){

library(tidyverse)

all_rmd <- list.files(path = ".",
                      recursive = TRUE,
                      full.names = TRUE,
                      pattern = ".Rmd")


## dummy:
path = all_rmd

get_rmd_dependencies <- function(path){

  reqlibs = sub(".*library\\(\"(.*?)\"\\).*","\\1",
              grep("library\\(",
                   readLines(path),
                   value=TRUE))

  reqlibs <- stringr::str_replace_all(string = reqlibs,
                             pattern = "library\\(",
                             replacement = "")
  reqlibs <- stringr::str_replace_all(string = reqlibs,
                             pattern = "\\)",
                             replacement = "")

  reqlibs <- stringr::str_replace_all(string = reqlibs,
                                      pattern = "#",
                                      replacement = "")

  reqlibs <- stringr::str_replace_all(string = reqlibs,
                                      pattern = " ",
                                      replacement = "")

  reqlibs <- stringr::str_replace_all(string = reqlibs,
                                      pattern = "`",
                                      replacement = "")
  
  reqlibs <- stringr::str_replace_all(string = reqlibs,
                                      pattern = "'",
                                      replacement = "")
  
  reqlibs <- stringr::str_replace_all(string = reqlibs,
                                      pattern = "suppressWarnings.*",
                                      replacement = "")
  
  reqlibs <- stringr::str_replace_all(string = reqlibs,
                                      pattern = "suppressWarnings.*",
                                      replacement = "")
  
  
  

  reqlibs


}

purrr::map(all_rmd, get_rmd_dependencies)

packages <- map(as.list(all_rmd), get_rmd_dependencies) %>%
  unlist() %>%
  unique() %>%
  trimws()

return(packages)

}



get_dependencies() %>% 
  enframe() %>%
  arrange(value) -> dependencies


write_lines(dependencies$value, path = "DEPENDENCIES.txt")

walk(
  .x = dependencies$value,
  .f = pacman::p_install
)



