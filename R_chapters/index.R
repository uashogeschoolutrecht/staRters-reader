## ----include=FALSE, eval=FALSE--------------------------------------------------------------------------
## # source(here::here("code", "get_rmd_dependencies.R"))
## # automatically create a bib database for R packages
## knitr::write_bib(c(
##   .packages(), 'bookdown', 'knitr', 'rmarkdown'
## ), 'packages.bib')
## 


## ----setup, include=FALSE-------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, fig.width = 6, fig.height = 4,
                      warning = FALSE,
                      error = FALSE, message = FALSE)


image_dir <- here::here(
  "images"
)



## ---- eval=FALSE----------------------------------------------------------------------------------------
## source(here::here("code", "r_packages_graph.R"))
## ## assigning a plot object
## pkgs_plot <- plot_packages()
## ## saving plot to disk plot
## ggsave(filename = here::here("images", "rpackages_trend.svg"),
##        plot = pkgs_plot,
##        width = 5, height = 5)
## 


## -------------------------------------------------------------------------------------------------------
## include plot in document
knitr::include_graphics(path = here::here("images", "rpackages_trend.svg"))


## ---- fig.width=10, fig.height=10-----------------------------------------------------------------------
library(rvest)

pkgs <- read_html("https://cran.r-project.org/web/packages/available_packages_by_name.html")
mylines <- pkgs %>% 
    html_nodes("tr") %>%
    xml_text()

nb_pkgs <- length(which(sapply(mylines, nchar)>5))

print(paste("There are", nb_pkgs, "packages available in CRAN as of", Sys.Date()))


## -------------------------------------------------------------------------------------------------------
urls <- readr::read_csv(
  here::here("urls")
)

urls[1,1]



## ----eval=FALSE-----------------------------------------------------------------------------------------
## install.packages("bookdown")
## # or the development version
## # devtools::install_github("rstudio/bookdown")

