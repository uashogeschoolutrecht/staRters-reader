## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, 
                      warning = FALSE, 
                      error = FALSE, 
                      message = FALSE, fig.width = 8, fig.height = 6, units = "cm")


## ------------------------------------------------------------------------
library(tidyverse)
library(DiagrammeR)
library(magrittr)
library(ggplot2)
library(ggpubr)
library(ggExtra)
library(captioner)



## ---- echo = FALSE, fig.cap="The PPDAC cycle of Exploratory Data Analysis in a diagram. Please note that sometimes shortcuts are possible and even feasible. [@spiegelhalter2019, @mackay2000]"----

DiagrammeR::grViz("
digraph rmarkdown {
  Problem -> Plan
  Plan -> Data
  Data -> Analysis
  Analysis -> Conclusion 
  Conclusion -> Problem
}
")


## ------------------------------------------------------------------------
shipman_murders <- read_csv(
  here::here(
    "data", "00-1-shipman-confirmed-victims-x.csv"
    )
  )


## ---- eval=FALSE---------------------------------------------------------
## DT::datatable(shipman_murders)


## ---- echo=FALSE---------------------------------------------------------
shipman_murders


## ------------------------------------------------------------------------
names(shipman_murders) <- names(shipman_murders) %>%
  tolower()

shipman_murders <- shipman_murders %>%
  mutate(name = tolower(name),
         name = str_replace_all(string = name, pattern = " ", replacement = ""),
         names = trimws(name))

## show first five names
shipman_murders$name[1:5]

## now look at duplicates
duplicated(shipman_murders$name) %>% which(arr.ind = TRUE) %>% length()



## ------------------------------------------------------------------------
shipman_murders$gender[1:5]
shipman_murders$age[1:5]


## ------------------------------------------------------------------------
fct_recode(as_factor(shipman_murders$gender), 
           male = "1",
           female = "0"
           )

## Writing this in a dplyr pipe:
shipman_murders <- shipman_murders %>%
  mutate(
    gender_recoded = fct_recode(as_factor(gender), 
           male = "1",
           female = "0"
           )

  )

## check recoded factor
shipman_murders$gender_recoded[1:5]



## ------------------------------------------------------------------------
names(shipman_murders)
gender_table <- shipman_murders %>%
  group_by(gender_recoded) %>%
  select(gender_recoded) %>%
  tally()

knitr::kable(gender_table)
 


## ------------------------------------------------------------------------
shipman_murders %>%
  group_by(gender_recoded) %>%
  select(gender_recoded) %>%
  tally %>%
  ggplot(aes(x = reorder(gender_recoded, n), y = n)) +
  geom_col() +
  xlab(NULL) +
  ylab("Number of victims") +
  theme_bw()



## ------------------------------------------------------------------------
shipman_murders

age_descriptors <- shipman_murders %>%
  group_by(gender_recoded) %>%
  dplyr::select(age, gender_recoded) %>%
  summarise(mean_age = mean(age),
            median_age = median(age),
            sd_age = sd(age))

age_descriptors
  
shipman_murders %>%
  dplyr::filter(gender_recoded == "female") %>%
  ggplot(aes(x = age)) +
#  geom_freqpoly(colour = "darkred", size = 1.5) +
  geom_histogram(alpha = 0.5, fill = "black", colour = "darkgreen") +
  geom_vline(aes(xintercept = age_descriptors$median_age[1]), 
             linetype = "dashed", 
             colour = "red", 
             size = 1) +
  geom_vline(aes(xintercept = age_descriptors$mean_age[1]), 
             linetype = "solid", 
             colour = "red", 
             size = 1) +
  theme_bw() +
  ggtitle("Age distributions in femals, \n dashed line is the median, solid line the mean age")


## ------------------------------------------------------------------------
shipman_murders %>%
#  dplyr::filter(gender_recoded == "female") %>%
  ggplot(aes(x = age, y = ..scaled..)) +
#  geom_freqpoly(colour = "darkred", size = 1.5) +
  geom_density(aes(colour = gender_recoded)) +
  geom_vline(aes(xintercept = age_descriptors$median_age[1]), 
             linetype = "dashed", 
             colour = "red", 
             size = 1) +
  geom_vline(aes(xintercept = age_descriptors$mean_age[1]), 
             linetype = "solid", 
             colour = "red", 
             size = 1) +
  geom_vline(aes(xintercept = age_descriptors$median_age[2]), 
             linetype = "dashed", 
             colour = "blue", 
             size = 1) +
  geom_vline(aes(xintercept = age_descriptors$mean_age[2]), 
             linetype = "solid", 
             colour = "blue", 
             size = 1) +
  theme_bw()



## ------------------------------------------------------------------------
shipman_murders %>%
  ggplot(aes(y = age, x = gender_recoded)) +
  geom_boxplot(aes(group = gender_recoded, colour = gender_recoded)) +
  xlab(NULL) +
  theme_bw()
  
  


## ------------------------------------------------------------------------
plot <- shipman_murders %>%
ggplot(aes(
  x = fractionaldeathyear,
  y = age,
  colour = reorder(gender2, gender)
  )) +      
  geom_point(size = 2) +
  labs(x = "Year", y = "Age of victim") +
  scale_x_continuous(breaks = seq(1975, 1995, 5),
    limits = c(1974, 1998)) +
  scale_y_continuous(breaks = seq(40, 90, 10), limits = c(39, 95)) +
  scale_size_continuous(name = "Size", guide = FALSE) +
  scale_colour_brewer(palette = "Set1")  + 
  theme_bw() +
  theme(
    legend.position = c(0.125, 1.12),
    legend.background = element_rect(colour = "black"),
    legend.title = element_blank()
  ) 

  ggMarginal(plot, type="histogram")

