### create Rda from NCTC prevalidation data

library(readxl)
library(tidyverse)

nctc <- read_excel("./exercises/tutorials/NCTC data all participants DTU and UNIMI corrected (2).xlsx",
                   sheet = "Compound NCTC")

head(nctc)
names(nctc)
## cleanup

nctc <- nctc[c(3:nrow(nctc)),] %>%
  select(-c(Dunnett, `Reason for`, X__1))

head(nctc)
names(nctc) <- tolower(names(nctc))

names(nctc) <- gsub(names(nctc), pattern = "\\.", replacement = "")
names(nctc) <- gsub(names(nctc), pattern = "\\-", replacement = "")

names(nctc)


nctc$lab <- as.factor(nctc$lab)
nctc$compound <- as.factor(nctc$compound)
nctc$exp <- as.factor(nctc$exp)
nctc$conc <- as.factor(nctc$conc)
nctc$rep <- as.factor(nctc$rep)
nctc$viability <- as.numeric(nctc$viability)
nctc$il18 <- as.numeric(nctc$il18)
nctc$fold <- as.numeric(nctc$fold)

readr::write_csv(nctc, path = "./exercises/tutorials/nctc.csv")

