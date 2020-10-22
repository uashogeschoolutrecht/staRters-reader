--- 
title: "staRters; An introductory workshop for analysis of data with R"
author: "Marc A.T. Teunis, PhD"
date: "2020-10-21 20:50:36"
site: bookdown::bookdown_site
output:
  bookdown::html_book:
    theme: darkly
bibliography: [references.bib]
biblio-style: apalike
link-citations: yes
always_allow_html: yes
github-repo: uashogeschoolutrecht/staRters
description: "HU Ontwikkelfestival, 2-4 November, 2020"
---



# Prerequisites



## Purpose of this website
This website is the accompanying website to the Introductory Workshop on using R called 'staRters' during the HU _ontwikkelfestival_, 2-4 November, 2020.

The material consists of introductory and supplemental ("./extra) materials to get acquainted with using R for data - analysis and statistics. The course content and further structure of the course are explained in the table of contents. 

All methods described in this website and used in the course relate to the Language and Environment for Statistical Computing called [**R**](https://cran.r-project.org/) [@R-base]. To work more efficiently with R we will be using the most commonly used Integrated Development Environment for R: [**RStudio**](https://www.rstudio.com) [@R-rstudio]. Initially, you will be working on a pre-installed version of RStudio on a server for which you will receive login credentials.  

## R Packages
There are many so-called 'packages' to add on to the base-R installation and for this course we use many of them. The code below retrieves the current amount of packages published on the Comprehensive R Archiving Network, which is a main resource for R-packages. 

Usually R-packages can be installed by running this command
```
install.packages("package_name")
```

By using a web scraping approach we can extract the statistics on published packages from the CRAN website. Below, I sho a plot created from this scraped data and a small piece of R-code that retrieves the absolute number of R-packages available on the day that this website was last updated.   

The number of packages has increased enormously over the past 5 years. The graph below shows the progress in the number of packages available from CRAN.

The function that creates the graph is loaded with the `source()` function.


```r
source(here::here("code", "r_packages_graph.R"))
## assigning a plot object 
pkgs_plot <- plot_packages()
## saving plot to disk plot
ggsave(filename = here::here("images", "rpackages_trend.svg"), 
       plot = pkgs_plot,
       width = 5, height = 5)
```


```r
## include plot in document
knitr::include_graphics(path = here::here("images", "rpackages_trend.svg"))
```

![](C:/Users/mteunis/workspaces/staRters/images/rpackages_trend.svg)<!-- -->

How many R-packages are available from CRAN on the date that this website was last updated: 2020-10-21 


```r
library(rvest)

pkgs <- read_html("https://cran.r-project.org/web/packages/available_packages_by_name.html")
mylines <- pkgs %>% 
    html_nodes("tr") %>%
    xml_text()

nb_pkgs <- length(which(sapply(mylines, nchar)>5))

print(paste("There are", nb_pkgs, "packages available in CRAN as of", Sys.Date()))
```

```
## [1] "There are 16445 packages available in CRAN as of 2020-10-21"
```

Other important resources than CRAN for R-packages are:

 - [BIOCONDUCTOR](https://www.bioconductor.org/).
 - [Github](https://github.com)
 - [Bitbucket](https://bitbucket.org/)
 - [ROpenSci](https://ropensci.org/packages/)

A full list of packages that are needed for this course is available in file "./DEPENDECIES.txt" 

## Getting the materials
To compile this website locally, you can clone the website repository from 

```r
urls <- readr::read_csv(
  here::here("urls")
)

urls[1,1]
```

```
## # A tibble: 1 x 1
##   url                                             
##   <chr>                                           
## 1 https://github.com/uashogeschoolutrecht/staRters
```

You will need to install the `{bookdown}` package. Run `bookdown::render(".")` from inside the cloned repo. This repository can also be used to access the course materials directly in RStudio during the workshops.

## Getting R and RStudio
During the course we will be working on a Cloud Computing Environment which provides webaccess to R and RStudio via a Virtual Machine. This machine runs a server edition of RStudio and has the latest R version and all the required packages available. In order to access the server you will need credentials, which you will recieve before the course starts. This is a convenient way to use R in a course and during the course we will only be using this environment. This is to ensure reproducibility and prevents a lot of trouble shooting from your side and the teacher's side.

If you want to use R and RStudio locally on your laptop (the teacher will not support this during the course), this is where you can download the software from:

[RStudio](https://www.rstudio.com/products/rstudio/download/) 

[R](https://cran.r-project.org/)

## The `{bookdown}` package
This website was created using the `{bookdown}` [@R-bookdown] package written by Yihui Xie. The package can be downloaded from CRAN. For more information see the [documentation](https://bookdown.org/yihui/bookdown/).

The `{bookdown}` package can be installed from CRAN or Github:


```r
install.packages("bookdown")
# or the development version
# devtools::install_github("rstudio/bookdown")
```