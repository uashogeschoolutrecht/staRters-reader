## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ------------------------------------------------------------------------
library(tidyverse)


## ------------------------------------------------------------------------
named_vector_ages <- c("Sofie" = 38, "Marc" = 45, "Marie" = 1.5)
named_vector_ages
names(named_vector_ages)
attributes(named_vector_ages)


## ------------------------------------------------------------------------
numbers <- c(1:10)

## get the 1st 
numbers[1]

## get the 1st and 3rd element
numbers[c(1,3)]

## get the second element three times
numbers[c(2,2,2)] #or
numbers[rep(2, times = 3)]

## remove the 5th element
numbers[-5]

## you can go crazy - but expect the unexpected
numbers[c(1:3, c(1,2,(c(3))))]


## ---- eval=FALSE---------------------------------------------------------
## ## you can't mix positive and negative indices
## numbers[c(-5,5)]


## ------------------------------------------------------------------------

## indivual vectors
age = c(24, 27, 19, 34)
sex = c("F","F","M", "M")
weight = c(64, 55, 80, 70)
given_names = c("Christa", "Suzan", "Matt", "John")

people_df <- data.frame(
  age,
  sex,
  weight,
  given_names
)

head(people_df)


## ------------------------------------------------------------------------
people_tbl <- tibble::tibble(
  age,
  sex,
  weight,
  given_names
)
people_tbl


## ---- eval=FALSE---------------------------------------------------------
## summary(people_df)
## table(people_df)
## 
## ## gives the content of the data frame
## head(people_df) 			
## names(people_df)
## str(people_df)
## 
## ## gives the content of the variable "age" from the data frame
## people_df$age
## tibble::glimpse(people_tbl)
## 


## ---- eval=FALSE---------------------------------------------------------
## ## first element of this vector
## people_df$age[1] 	
## 
## ## content of 2nd variable (column)
## people_df[,2]
## 
## ## content of the 1st row
## people_df[1,] 	
##                   # multiple indices
## people_df[2:3, c(1,3)] # remember to use c (2nd and 3rd row, 1st and 3rd column)
## 


## ------------------------------------------------------------------------
lst <- list(
  first_names = c(male = "Fred", 
                  female = "Mary"), 
                  no.children = 3, 
                  child_ages=c(4,7,16),
  child_names = c("Suzy", 
                  "Marvin", 
                  "Jane"), 
  address = c("Pandamonium Alley 114, Chaosville"),
  marital_status = TRUE)

lst


## ------------------------------------------------------------------------
# number of elements in the list
length(lst) 

lst[1] %>% class # 1st element of list as a list
lst[[1]] # 1st element of List
lst[[3]][2] # second item of third element
names(lst) # named elements in this list
lst$child_names # pull "named" elements from a list using 
lst$address

#`$` operator


## ------------------------------------------------------------------------
str(lst) # display structure of lst


## ------------------------------------------------------------------------
lst$child_ages[3] 
lst[[6]][2] # returns the value of the second element for your variable


## ------------------------------------------------------------------------
purrr::map(lst, is.na)


## ------------------------------------------------------------------------
matrix_num <- matrix(data = rnorm(n = 100),
                 nrow = 20,
                 ncol = 5) %>%
  print()


## ------------------------------------------------------------------------
matrix_chr <- matrix(data = (c(LETTERS, LETTERS)[1:30]),
                     nrow = 5,
                     ncol = 6) %>%
  print()
                     


## ------------------------------------------------------------------------
matrix_lgl <- matrix(data = rep(c(TRUE, FALSE, TRUE), times = 20),
                     ncol = 5) %>%
  print()


## ------------------------------------------------------------------------
matrix_num[1:10]
attributes(matrix_num)


## ------------------------------------------------------------------------
library(tidyverse)
path_to_gender_age_data <- here::here("data", "gender.txt")
gender_age <- read_delim(path_to_gender_age_data,
                         delim = "/")


## ------------------------------------------------------------------------
library(readr)
skin <- read_csv(here::here("data", "skincolumns.csv")) 
skin %>% head(3)


## ---- eval=FALSE---------------------------------------------------------
## head(skin)	 # content of the data frame
## dim(skin)
## attributes(skin)
## summary(skin)
## ## ?read_csv 	 # help on the function


## ------------------------------------------------------------------------
mean(skin$`Genotype A`)
mean(skin$`Genotype B`)

# to remove the NA, take care: consider leaving NAs in and use arguments like na.rm = TRUE
skin_noNA <- na.omit(skin)
mean(skin_noNA$`Genotype B`)


## ---- eval = FALSE-------------------------------------------------------
## rm(list=ls())
## root <- find_root_file(criterion = is_rstudio_project)
## ## Note: never use this in code that is meant for others!!!


## ------------------------------------------------------------------------
big_numbers <- rnorm(10, mean = 10000000, sd = 2000000)
big_numbers %>% formatC(format = "e", digits = 5)

many_digits <- c(2.55858868688584848)
round(many_digits, digits = 3)
sqrt(many_digits * 1000 /200 * 2^6)  



## ------------------------------------------------------------------------
small_numbers <- runif(10, min = 0.001, max = 0.1) %>% print()
small_numbers %>% round(digits = 2)


## ---- eval=FALSE---------------------------------------------------------
## knitr::purl("hands_ons/part1_intro_to_rstudio_and_r.Rmd", output = "./hands_ons/part1_intro_to_rstudio_and_r.R")


## ------------------------------------------------------------------------
options_exercises <- knitr::opts_chunk$set(echo = FALSE,
                                           warning = FALSE,
                                           error = FALSE,
                                           message = FALSE,
                                           results = 'hide',
                                           fig.show = 'hide')


## ---- exercise_chunks, include = FALSE-----------------------------------
## use other example

library(readr)
simple_IO <- read_csv(here::here(
"data",
"simple-IO.csv"
))


## ---- answer_to_1--------------------------------------------------------
dim(simple_IO)
ncol(simple_IO)
nrow(simple_IO)


## ---- echo=TRUE----------------------------------------------------------
a <- c("a", "b", "c", NA)
b <- c(1:4)
c <- c(6:8, NA)
d <- c(1.3, 1.6, 6.7)
e <- as.integer(d)
f <- as.integer(a)
g <- as.numeric(a)

(z <- paste(a, b, c))
(zz <- paste0(a, b, c))


