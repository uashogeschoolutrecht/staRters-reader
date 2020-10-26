## ---- message=FALSE, error=FALSE, warning=FALSE---------------------------------------------------------
library(tidyverse)


## ---- echo=FALSE----------------------------------------------------------------------------------------
path_to_tidyr_sticker <- file.path(
  here::here(
  "images", 
  "tidyr_sticker.png"))
knitr::include_graphics(path_to_tidyr_sticker, dpi = 80)


## ----tidy-structure, echo = FALSE-----------------------------------------------------------------------
path_to_tidydata_image <- file.path(
  here::here(
  "images",
  "tidy-1.png"))
knitr::include_graphics(path_to_tidydata_image, dpi = 250)


## -------------------------------------------------------------------------------------------------------
head(table1, 6)


## -------------------------------------------------------------------------------------------------------
head(table2, 6)


## -------------------------------------------------------------------------------------------------------
head(table3, 6)


## -------------------------------------------------------------------------------------------------------
head(table4a, 3)  # cases
head(table4b, 3)  # population


## -------------------------------------------------------------------------------------------------------
head(table1)


## -------------------------------------------------------------------------------------------------------
# Compute rate per 10,000
table1 %>% 
  mutate(rate = cases / population * 10000)


## -------------------------------------------------------------------------------------------------------
table1 %>% 
  count(year, wt = cases)


## ---- include=FALSE-------------------------------------------------------------------------------------
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))


## -------------------------------------------------------------------------------------------------------
table4a


## -------------------------------------------------------------------------------------------------------
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")


## ----tidy-gather, echo = FALSE, out.width = "100%", fig.cap = "Gathering `table4` into a tidy form."----
knitr::include_graphics(file.path(
  here::here(
  "images", 
  "tidy-9.png")
  ))


## -------------------------------------------------------------------------------------------------------
table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")


## ---- include=FALSE-------------------------------------------------------------------------------------
## see demo "readxl"


## ---- message=FALSE-------------------------------------------------------------------------------------
tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
joined_4a_4b <- left_join(tidy4a, tidy4b)
joined_4a_4b


## -------------------------------------------------------------------------------------------------------
table2


## -------------------------------------------------------------------------------------------------------
spread(table2, key = type, value = count)


## ----tidy-spread, echo = FALSE, out.width = "100%", fig.cap = "Spreading `table2` makes it tidy"--------
knitr::include_graphics(file.path(
  here::here(
  "images", 
  "tidy-8.png")
  ))


## -------------------------------------------------------------------------------------------------------
table3


## -------------------------------------------------------------------------------------------------------
table3 %>% 
  separate(rate, into = c("cases", "population"))


## ----tidy-separate, echo = FALSE, out.width = "75%", fig.cap = "Separating `table3` makes it tidy"------
knitr::include_graphics(file.path(
  here::here(
   "images", "tidy-17.png")))


## -------------------------------------------------------------------------------------------------------
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)


## -------------------------------------------------------------------------------------------------------
stocks


## -------------------------------------------------------------------------------------------------------
stocks %>% 
  spread(year, return)


## -------------------------------------------------------------------------------------------------------
stocks %>% 
  spread(year, return) %>% 
  gather(year, return, `2015`:`2016`, na.rm = TRUE)


## -------------------------------------------------------------------------------------------------------
stocks %>% 
  complete(year, qtr)


## -------------------------------------------------------------------------------------------------------
(treatment <- tribble(
  ~ person,            ~ treatment, ~response,
  "Hans Anders",       1,           7,
  NA,                  2,           10,
  NA,                  3,           9,
  "Alber Heijn",       1,           4,
  NA,                  2,           8,
  NA,                  3,           12
))


## -------------------------------------------------------------------------------------------------------
treatment %>% 
  fill(person)


## ---- include=FALSE-------------------------------------------------------------------------------------

library(tidyr)
library(dplyr)
table2 <- table2
table2_tidy <- table2 %>%
  spread(key = "type", value = "count") %>%
  mutate(rate = (cases/population)*1000) %>%
  arrange(year)
table2_tidy


## ---- include=FALSE-------------------------------------------------------------------------------------
## ANSWER 4a + 4b
table4a <- tidyr::table4a
table4b <- tidyr::table4b
table4a
table4b

table4a_tidy <- table4a %>%
  gather(`1999`:`2000`, key = "year", value = "cases")

table4b_tidy <- table4b %>%
  gather(`1999`:`2000`, key = "year", value = "population")

table4_union <- left_join(table4a_tidy, 
                          table4b_tidy, 
                          by = c("country", "year")) %>%
  mutate(rate = (cases/population)*1000) %>%
  arrange(year)

table4_union


## ---- include=FALSE-------------------------------------------------------------------------------------
## answer 2a
library(ggplot2)

cases_over_time <- table2 %>%
  spread(key = "type", value = "count") %>%
  mutate(rate = (cases/population)*1000) %>%
  arrange(year) %>%
  ggplot(aes(x = as.factor(year), y = cases)) +
  geom_point(aes(colour = country)) +
  geom_text(aes(label = country), hjust = -0.2, vjust = -0.7) +
  geom_line(aes(group = country, colour = country)) +
  theme(legend.position="none") +
  expand_limits(y = c(0, 250000)) +
  xlab("Year") +
  ylab("Number of Cases")
                 
cases_over_time



## ---- error = TRUE, echo=TRUE---------------------------------------------------------------------------
    table4a %>% 
      gather(1999, 2000, key = "year", value = "cases")


## ---- echo=TRUE, include=FALSE--------------------------------------------------------------------------

    preg <- tribble(
      ~pregnant, ~male_count, ~female_count,
      "yes",      NA,        18,
      "no",       20,        12,
      "no",       34,        78,
      "yes",      NA,        23
)



## ---- include=FALSE-------------------------------------------------------------------------------------
## answer 3a
preg_tidy <- preg %>%
   gather(male_count:female_count, 
          key = "count", 
          value = number)
preg_tidy


## ---- include=FALSE-------------------------------------------------------------------------------------
## answer 3b
names(preg_tidy)

preg_females <- preg_tidy %>%
  dplyr::filter(pregnant == "yes" & count == "female_count") %>%
  summarise(females = sum(number)) 
preg_females

females <- preg_tidy %>%
  dplyr::filter(count == "female_count") %>%
  summarise(females = sum(number)) 
females

((preg_females/females)*100)



## ---- include=FALSE-------------------------------------------------------------------------------------
## answer 3c
names(preg_tidy)

males <- preg_tidy %>% na.omit() %>%
  dplyr::filter(count == "male_count") %>%
  summarise(males = sum(number)) 
males

preg_males <- preg_tidy %>% na.omit() %>%
  dplyr::filter(pregnant == "yes" & count == "male_count") %>%
  summarise(females = sum(number)) 
preg_males

## of course there are nog pregnant males



## ---- eval = FALSE--------------------------------------------------------------------------------------
## tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
## separate(x, c("one", "two", "three"))
## 
## tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
## separate(x, c("one", "two", "three"))


## ---- echo=TRUE-----------------------------------------------------------------------------------------
library(readxl)

# path to data file
path_to_messy_mariages <- file.path(
  here::here(
    "data", 
    "messydata_5a.xlsx"))

# load messy data in empty list with loop and read_excel
messy_mariages <- list()

for(i in 1:7){
  messy_mariages[[i]] <- read_excel(path = path_to_messy_mariages, 
                                    sheet = i)
  messy_mariages[[i]]$timestamp <- i
}




## ---- include=FALSE-------------------------------------------------------------------------------------
# loading required packages
library(tidyverse)
library(readxl)
library(stringr)
library(forcats)

# path to data file
path_to_messy_mariages <- file.path(
  here::here(
    "data", 
    "messydata_5a.xlsx"))

# load messy data in empty list with loop and read_excel
messy_mariages <- list()

for(i in 1:7){
  messy_mariages[[i]] <- read_excel(path_to_messy_mariages, 
                                    sheet = i)
  messy_mariages[[i]]$timestamp <- i
}

messy_mariages
messy_sheet_1 <- messy_mariages[[1]]
messy_sheet_1 <- messy_sheet_1[c(2:17), c(4:9)]
## change names of first sheet to match others
names(messy_sheet_1) <- c(names(messy_mariages[[3]]))                     
## overwrite old sheet with new, with correct names
messy_mariages[[1]] <- messy_sheet_1 


# bind list to data frame
messy_mariages_df <- do.call(rbind.data.frame, messy_mariages)

# load the state information from "./data/germany_states.txt"
# Does the file contain headers?
germany_states <- readr::read_tsv(
  file = 
    here::here(
    "data",
    "germany_states.txt"),
  col_names = FALSE)
# restructuring data
## gathering variables into columns
restructured_mariages <- messy_mariages_df %>% 
  tidyr::gather(spring:winter, 
                key = "season", 
                value = "number_mariages")
  
restructured_mariages$timestamp <- as.factor(
  restructured_mariages$timestamp)

levels(restructured_mariages$timestamp)

tidy_mariages <- restructured_mariages %>%
# change timestamps to actual Years
## use forcats::recode
mutate(year = forcats::fct_recode(timestamp,
                                  "1990" = "1",
                                  "2003" = "2",
                                  "2010" = "3",
                                  "2011" = "4",
                                  "2012" = "5",
                                  "2013" = "6",
                                  "2014" = "7"))
  
# look at the restructed data
tidy_mariages

# set 'names' tolower
names(tidy_mariages) <- tolower(names(tidy_mariages))
names(tidy_mariages)

# have a closer look at the Statenames (convert to factor)
tidy_mariages$state <- as_factor(tidy_mariages$state)
levels(tidy_mariages$state)

# relabel factor levels
tidy_mariages <- tidy_mariages %>%
  mutate(state = fct_recode(state,
                      "Baden-Württemberg" = "BaWü",
                      "Hessen" = "Hesssen",
                      "Hessen" = "Hesse"))
                      
levels(tidy_mariages$state)


# save tidy data as csv
path <- file.path(
  here::here(
  "data", "tidy_mariages.csv"))

write_csv(tidy_mariages, path = path)



## ---- include=FALSE-------------------------------------------------------------------------------------
marriageperyear <- tidy_mariages %>% 
  group_by(year) %>% # groups data by year
  dplyr::summarise(total = sum(as.numeric(number_mariages))) # adds up the values per year

marriageperyear %>%
  ggplot(aes(x = year,
             y = total)) +
  geom_point() +
  geom_line(aes(group = 1))



## ---- include=FALSE, eval=FALSE-------------------------------------------------------------------------
## marriageperyearnseason <- tidy_mariages %>%
##   dplyr::filter(year %in% c("1990", "2003", "2014")) %>%
##   group_by(year, season) %>%
##   mutate(number_mariages = as.numeric(number_mariages)) %>%
##   dplyr::summarise(value = sum(number_mariages))
## 
## # ggplot the filtered data
## ggplot(data = marriageperyearnseason,
##        aes(x = year, y = value)) +
## geom_bar(stat = "identity") +
## theme_minimal() +
## xlab("Year") +
## scale_y_continuous(name="Marriages",
##                    # specify aesthetics of y-axis labels
##                    labels=function(x) format(x, big.mark = "'", scientific = FALSE)) +
## guides(fill=guide_legend(title="season", reverse = T)) +
## ggtitle("Marriages per Year and season")
## 
## # Compare the number of marriages in 2014 per state and colour them by season
## # filter data by the year 2014 and group it by season and state, add up the values
## marriageperstate14 <- tidy_mariages %>%
##   dplyr::filter(timestamp %in% c(2014)) %>%
##   group_by(number_mariages, state) %>%
##   dplyr::summarise(total = sum(as.numeric(number_mariages)))
## 
## # stacked barplot with ggplot (incl. dashed meanline)
## meanlabel <- (sum(marriageperstate14$number_mariages)/16)-2000 # y-coordinate of label for meanline
## 
## ggplot(data = marriageperstate14, aes(x = State, y = value,
##                                       fill = factor(variable), order = variable)) +
##   geom_bar(stat = "identity") +
##   theme_minimal() +
##   xlab("State") +
##   scale_y_continuous(breaks = seq(0,85000, 10000), name="Marriages",
##                      labels=function(x) format(abs(seq(0,85000,10000)),
##                                                big.mark = "'", scientific = FALSE)) +
##   scale_x_discrete(labels=c("BaWü","Bay","Ber","Bra","Bre","Ham","Hes","Meck","Nie","Nor",
##                             "Rhe","Saa","Sac","SaAn","Sch","Thü")) + # change x-axis labels
##   theme(axis.text.x = element_text(angle = - 50, vjust = 0.9, hjust = 0.1)) +
##   guides(fill=guide_legend(title="season", reverse = T)) +
##   ggtitle("Marriages per state and season \n 2014") +
##   geom_hline(aes(yintercept = (sum(value)/16)), color = "black", linetype = "dashed",
##              size = 0.5) + # add meanline
##   annotate("text", x = 10, y = meanlabel, label="Mean", color="black",
## size = 4, hjust = 1) # add text to mean line
## 
## 

