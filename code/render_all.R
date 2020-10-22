## renders multiple R-markdown files


## defines the root of the project for later use
require("rprojroot") || utils::install.packages("rprojroot")
library(rprojroot)
root <- find_root_file(criterion = is_rstudio_project)


dir_out <- file.path(root, "presentations", "html")
dir_in <- file.path(root, "presentations")

list_rmd_presentations <- list.files(dir_in, 
                                     pattern = "._(.|..)_.",
                                     full.names = TRUE)
list_rmd_presentations

render_all <- function(x){
  
  rmarkdown::render(input = x, 
                    output_dir = dir_out,
                    output_format = "ioslides_presentation")
}


knitr::knit(list_rmd_presentations[[1]], output = dir_out)

lapply(list_rmd_presentations, knitr::knit)

lapply(list_rmd_presentations[[1]], render_all)      
lapply(list_rmd_presentations[[2]], render_all)      
lapply(list_rmd_presentations[[3]], render_all)      
lapply(list_rmd_presentations[[4]], render_all)      
lapply(list_rmd_presentations[[5]], render_all)      
lapply(list_rmd_presentations[[6]], render_all)      
lapply(list_rmd_presentations[[7]], render_all)      
lapply(list_rmd_presentations[[8]], render_all)      
lapply(list_rmd_presentations[[9]], render_all)      
lapply(list_rmd_presentations[[11]], render_all)      
lapply(list_rmd_presentations[[12]], render_all)      
lapply(list_rmd_presentations[[13]], render_all)      
lapply(list_rmd_presentations[[14]], render_all)      
lapply(list_rmd_presentations[[15]], render_all)      
lapply(list_rmd_presentations[[16]], render_all)      
lapply(list_rmd_presentations[[17]], render_all)      
lapply(list_rmd_presentations[[18]], render_all)      
lapply(list_rmd_presentations[[19]], render_all)      
lapply(list_rmd_presentations[[20]], render_all)      
lapply(list_rmd_presentations[[21]], render_all)      
lapply(list_rmd_presentations[[22]], render_all)      
lapply(list_rmd_presentations[[23]], render_all)      
lapply(list_rmd_presentations[[24]], render_all)      
lapply(list_rmd_presentations[[25]], render_all)      
lapply(list_rmd_presentations[[26], render_all)      
