## ----include=FALSE, eval=FALSE-------------------------------------------
## # source(here::here("code", "get_rmd_dependencies.R"))
## # automatically create a bib database for R packages
## knitr::write_bib(c(
##   .packages(), 'bookdown', 'knitr', 'rmarkdown'
## ), 'packages.bib')
## 


## ---- eval=FALSE---------------------------------------------------------
## source(here::here("code", "r_packages_graph.R"))
## ## assigning a plot object
## pkgs_plot <- plot_packages()
## ## saving plot to disk plot
## ggsave(filename = here::here("images", "rpackages_trend.svg"), plot = pkgs_plot)
## 


## ------------------------------------------------------------------------
## include plot in document
knitr::include_graphics(path = here::here("images", "rpackages_trend.svg"))


## ------------------------------------------------------------------------
library(rvest)

pkgs <- read_html("https://cran.r-project.org/web/packages/available_packages_by_name.html")
mylines <- pkgs %>% 
    html_nodes("tr") %>%
    xml_text()

nb_pkgs <- length(which(sapply(mylines, nchar)>5))

print(paste("There are", nb_pkgs, "packages available in CRAN as of", Sys.Date()))


## ----eval=FALSE----------------------------------------------------------
## install.packages("bookdown")
## # or the development version
## # devtools::install_github("rstudio/bookdown")

