## Multinomial logistic regression
## https://stats.idre.ucla.edu/r/dae/multinomial-logistic-regression/

#' Packages
library(foreign)
library(nnet)
library(tidyverse)
library(reshape)



#' Data
ml <- read.dta("https://stats.idre.ucla.edu/stat/data/hsbdemo.dta")

#' Summary statitics
table(ml[, c("ses", "prog")])

ml_summary <- ml %>%
  group_by(prog) %>%
  summarise(mean_write = mean(write),
            sd_write = sd(write)) %>%
  print()

## .SAV read ()
library(haven)
data_edwin <- haven::read_sav(
  file =
    here::here(
  "data", "Cursus R databse.sav"),
  user_na = TRUE
  )

data_edwin
