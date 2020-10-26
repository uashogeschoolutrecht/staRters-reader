## ---- warning=FALSE, error=FALSE, message=FALSE---------------------------------------------------------
library(tidyverse)
library(haven)


## ---- getting_absolute----------------------------------------------------------------------------------
"C:/Users/mteunis/workspaces/staRters/data/allijn.tsv"


## -------------------------------------------------------------------------------------------------------
## sav example for SPSS files (with {haven})
data_mtcars_spss <- read_sav(
  here::here(
    "data",
    "mtcars.sav"
  )
)



## ---- echo=FALSE, results='hide'------------------------------------------------------------------------
path_to_dp <- here::here("data", "DP_LIVE_06112019150508524.csv")


## ---- echo=FALSE----------------------------------------------------------------------------------------
data_dp <- read_csv(path_to_dp)
data_dp


## ---- message = TRUE, echo=FALSE, results='hide'--------------------------------------------------------
## ?read_csv
path_to_file <- here::here("data", "heights.csv")
heights <- read_csv(file = path_to_file)


## -------------------------------------------------------------------------------------------------------
read_csv("a,b,c
1,2,3
4,5,6")
# each new line results in a new row of observations


## -------------------------------------------------------------------------------------------------------
## no options
read_csv("The first line of metadata
The second line of metadata
x,y,z
1,2,3
4,6,8")

## skip lines
read_csv("The first line of metadata
The second line of metadata
x,y,z
1,2,3
4,6,8", skip = 2)
    
## define comment
read_csv("#The first line of metadata
#The second line of metadata
x,y,z
1,2,3
4,6,8", comment = "#")


## ---- results='hide', include=FALSE---------------------------------------------------------------------
data_allijn <- read_tsv(
  file = here::here(
    "data",
    "allijn.tsv"
  ), comment = c("##")
)

## or
data_allijn <- read_tsv(
  file = here::here(
    "data",
    "allijn.tsv"
  ), skip = 22
)



## ---- eval=FALSE----------------------------------------------------------------------------------------
## system("head -25 data/allijn.tsv")


## -------------------------------------------------------------------------------------------------------
read_csv("1,2,3 \n 4,5,6", col_names = FALSE)


## -------------------------------------------------------------------------------------------------------
read_csv("1,2,3\n4,5,6", col_names = c("var_1", "var_2", "var_3"))


## -------------------------------------------------------------------------------------------------------
read_csv("a,b,c \n 1,2,.", na = ".")


## ---- echo=FALSE, results='hide'------------------------------------------------------------------------
## without setting na = c(...)
data_john <- read_csv(
  file = here::here(
    "data",
    "diet",
    "John.csv"
  )
)

data_john <- read_csv(
  file = here::here(
    "data",
    "diet",
    "John.csv"
  ), na = c("missing", "?", "", " ", "not recorded")
)




## ---- echo=FALSE----------------------------------------------------------------------------------------
## the Weight variable is parsed as a character if NA strings are not correctly set


## ---- include=FALSE-------------------------------------------------------------------------------------
diets <- list.files(
  path = here::here(
    "data",
    "diet"), pattern = "\\.csv", full.names = TRUE
  ) %>%
  map_df(.x = ., read_csv,
         na = c("?", "not recorded", "missing", "", " "),
         col_types = cols(
  `Patient Name` = col_character(),
  Age = col_double(),
  Weight = col_double(),
  Day = col_double()
))


## -------------------------------------------------------------------------------------------------------
parse_double("8.78")
parse_double("8,78", locale = locale(decimal_mark = ","))
# in Some countries "," is used as a decimal place holder


## -------------------------------------------------------------------------------------------------------
parse_number("$8,-")
parse_number("99.9%")


## ---- include=FALSE-------------------------------------------------------------------------------------
# Used in America
parse_number("$123,456,789")
# Used in many parts of Europe
parse_number("123.456.789")
# setting grouping_mark solves the parsing issue
parse_number("123.456.789", locale = locale(grouping_mark = "."))
# Used in Switzerland
parse_number("123'456''789", locale = locale(grouping_mark = "'"))


## -------------------------------------------------------------------------------------------------------
autobots <- c("Optimus Prime", "Perceptor", "Arcee")
parse_factor(c(
  "Optimus Prime", "Perceptor", "Arcee", "Soundwave", "Starscream" 
), levels = autobots)


## -------------------------------------------------------------------------------------------------------
## 7 November 1973 at 10 minutes and zero seconds past eight in the evening 
parse_datetime("1973-11-07T2010")
# If time is omitted, it will be set to midnight
parse_datetime("19731107")


## -------------------------------------------------------------------------------------------------------
parse_date("2010-10-01")


## -------------------------------------------------------------------------------------------------------
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")


## -------------------------------------------------------------------------------------------------------
parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")


## ---- include=FALSE, results='hide'---------------------------------------------------------------------
library(tidyverse)
path_to_file <- here::here("data", "vl5_dummy.csv")
data_class <- read_csv(
  path_to_file,
  col_types = cols(
    Group = col_factor(),
    Surname = col_character(),
    StudentID = col_double(),
    Class = col_factor(),
    Score = col_double(),
    Date = col_character()
  )
)
data_class
## change the Date variable to actual Date type
data_class <- data_class %>%
  mutate(Date_new = parse_date(Date, format = "%y'%m'%d"))


data_class


## -------------------------------------------------------------------------------------------------------
## the dollar sign ($) signifies the end of a string
str_view(pattern = "\\'$", string = "14'05'17'")

# correcting the row 5 faulty date entry
data_class <- data_class %>% 
  mutate(Date_new = 
    str_replace_all(
      pattern = "\\'$", 
      replacement = "", 
      string = Date
      )
)
data_class



## ---- include=FALSE, eval=FALSE-------------------------------------------------------------------------
## library(readr)
## read_delim(file = file, delim = "|")


## ---- include=FALSE-------------------------------------------------------------------------------------
library(readr)
#?read_csv
# read_csv(file, col_names = TRUE, col_types = NULL,
#  locale = default_locale(), na = c("", "NA"), quoted_na = TRUE,
#  quote = "\"", comment = "", trim_ws = TRUE, skip = 0, n_max = Inf,
#  guess_max = min(1000, n_max), progress = show_progress())

#?read_tsv
#read_tsv(file, col_names = TRUE, col_types = NULL,
#  locale = default_locale(), na = c("", "NA"), quoted_na = TRUE,
#  quote = "\"", comment = "", trim_ws = TRUE, skip = 0, n_max = Inf,
#  guess_max = min(1000, n_max), progress = show_progress())

# guess_max
# col_types
# col_names
# n_max
# show_progress
# trim_ws
# quote 
# na
# quoted_na
# locale



## -------------------------------------------------------------------------------------------------------
#?readr::read_fwf


## -------------------------------------------------------------------------------------------------------
x <- "x,y\n1,'a,b'"


## ---- include=FALSE-------------------------------------------------------------------------------------
read_delim(x, quote = "'", escape_backslash = TRUE,
           delim = ",")


## ---- echo=TRUE-----------------------------------------------------------------------------------------
read_csv("a,b\n1,2,3\n4,5,6")


## ---- include=FALSE-------------------------------------------------------------------------------------
# new row is not correctly defined
# correction
read_csv("a,b\n 1,2\n 3,4\n 5,6")


## ---- echo=TRUE-----------------------------------------------------------------------------------------
read_csv("a,b,c\n1,2\n1,2,3,4")


## ---- include=FALSE-------------------------------------------------------------------------------------
# correction:
read_csv("a,b,c\n 1,2,3\n 1,2,3")


## ---- echo=TRUE-----------------------------------------------------------------------------------------
read_csv("a,b\n\"1")


## ---- include=FALSE-------------------------------------------------------------------------------------
# correction:
read_csv("a,b\n\'1', '2'")


## ---- include=FALSE-------------------------------------------------------------------------------------
## 2A) It is proprietary: meaning it is not universal,
## the format can change over time. It is not platform 
## independent

## 2B) readxl:read_excel / readxl::read_xls /
## readxl::read_xlsx / gdata::read.xlsx / 
## xlsx::read.xlsx 
## / xlsx::read.xlsx2

## 2C) commas seperated values: a platform and 
## non-propriatary, universal format for flat-tabular 
## data

## 2D ";" / "," / "TAB" / "SPACE(S)" / "|" or any 
## specific delimiter that does not exist inside the 
## data-entries


## ---- include==FALSE------------------------------------------------------------------------------------
# tidyverse solution
# readxl::readxl solution
library(readxl)
path_to_file <- here::here("data", "Animals.xls")
animals_readxl <- readxl::read_excel(path = path_to_file, sheet = 1,
                              skip = 1, trim_ws = TRUE)

animals_readxl <- na.omit(animals_readxl)
animals_readxl <- animals_readxl[-1,] 



#?readxl
## something went wrong, we need to skip a line 
## the names are not correct, change if neccessary, see 2C


## ---- eval=FALSE, include=FALSE-------------------------------------------------------------------------
## # Other option: {xlsx}
## # install.packages("xlsx")
## library(xlsx)
## #?read.xlsx2
## animals_xlsx <- read.xlsx2(file = path_to_file, startRow = 4,
##                            sheetIndex = 1)


## ---- eval=FALSE, include=FALSE-------------------------------------------------------------------------
## # other option: {gdata}
## library(gdata)
## #?read.xls()
## #?read.csv
## animals_gdata = read.xls(path_to_file, sheet = 1, header = TRUE,
## skip = 1)
## 
## ## OKAY, so obviously, there are good reasons, NOT to use Excel files to store data!!
## 


## ---- include=FALSE-------------------------------------------------------------------------------------
names(animals_readxl) <- c("animal", "body_weight", "brain_weight")

## other solution:
colnames(animals_readxl) <- c("animal", "body_weight", "brain_weight")

pander::pander(head(animals_readxl))


## ---- include=FALSE-------------------------------------------------------------------------------------
library(dplyr)
## dplyr solution:
animals_readxl %>% 
  dplyr::filter(
    body_weight == 6654 & brain_weight == 5712
    )

## base-R solution 
#ind <- animals_readxl[,2] == 6654 & animals_readxl[, 3] == 5712 
#animals_readxl[ind, ]


## ---- include=FALSE-------------------------------------------------------------------------------------
## dplyr solution
head(animals_readxl %>% arrange(brain_weight), 1)

## or
animals_readxl %>% 
  dplyr::filter(
    brain_weight == min(animals_readxl$brain_weight, 
                             na.rm = TRUE)
    )



## ---- include=FALSE-------------------------------------------------------------------------------------
library(ggplot2)
plot <- animals_readxl %>% 
  ggplot(aes(x = body_weight, y = brain_weight)) +
    geom_point() +
    geom_smooth()
plot


## ---- include=FALSE-------------------------------------------------------------------------------------
no_brachio <- animals_readxl %>% 
  dplyr::filter(!animal == "Brachiosaurus") %>%
  ggplot(aes(x = body_weight, y = brain_weight)) +
    geom_point() +
    geom_smooth()
no_brachio


## ---- include=FALSE-------------------------------------------------------------------------------------
library(ggplot2)
plot <- animals_readxl %>% 
## create a new variable (log10 transformed body_weight)
    mutate(log10_bw = log10(body_weight)) %>%
## create a new plot  
  ggplot(aes(x = log10_bw, y = brain_weight)) +
    geom_point() +
    geom_smooth(method = "lm")
## call the plot
plot


## ---- include=FALSE-------------------------------------------------------------------------------------
library(ggplot2)
no_dinos <- animals_readxl %>%
  dplyr::filter(!animal == "Brachiosaurus" & 
         !animal == "Diplodocus" &
         !animal == "Triceratops") %>%
## create a new variable (log10 transformed body_weight)
    mutate(log10_bw = log10(body_weight)) %>%
## create a new plot  
  ggplot(aes(x = log10_bw, y = brain_weight)) +
    geom_point() +
    geom_smooth(method = "lm")
## call the plot
no_dinos


## ## open a new Terminal: Tools -> Terminal -> New Terminal

## ## cd into the right folder /data

## ## execute:

## head -20 storm_data.csv.bz2

## 
## ## you will discover that the delim = ","


## ---- include=FALSE-------------------------------------------------------------------------------------
library(R.utils) 
#bunzip2(here::here(
#  "data", "storm_data.csv.bz2"), 
#  remove = FALSE, overwrite = TRUE) 
storm <- read_csv(here::here("data", "storm_data.csv.bz2"))

## note that you can direcly pass a zipped archive into the readr function, without extracting the archive first


## ---- include=FALSE-------------------------------------------------------------------------------------
names(storm)
lapply(storm, typeof)
na <- map_df(storm, function(x) sum(is.na(x)))


## -------------------------------------------------------------------------------------------------------
types <- unique(storm$EVTYPE) %>% 
  enframe()

## step 1.
names(storm) <- names(storm) %>% 
  tolower() 
names(storm)
## step 2.
storm %>%
  mutate(evtype = str_trim(evtype),                                             
         year = format(strptime(bgn_date,
         format="%m/%d/%Y %T"), format="%Y")) %>%
  select(
    state__,
    bgn_date,
    bgn_time,
    state,
    year,
    evtype,
    f,
    fatalities,
    injuries, 
    mag,
    propdmg,
    propdmgexp,
    cropdmg,
    cropdmgexp) -> storm_cleaned





## ---- include=FALSE-------------------------------------------------------------------------------------

## add 1)

storm_summary <- storm_cleaned %>%
  group_by(year, evtype) %>%
  summarise(mean_fatalities = mean(fatalities, na.rm = TRUE),
            mean_injuries = mean(injuries, na.rm = TRUE),
            total_casualties = sum(fatalities + injuries))

storm_summary %>%
  ggplot(aes(x = evtype,
           y = as.numeric(total_casualties))) +
  geom_point(aes()) +
  toolboxr::rotate_axis_labels("x", 90)

## show only events with over 1000 casualties
storm_summary %>%
  dplyr::filter(total_casualties > 1000) %>%
  ggplot(aes(x = evtype,
           y = as.numeric(total_casualties))) +
  geom_point(aes()) +
  toolboxr::rotate_axis_labels("x", 90)

storm_cleaned %>%
  group_by(evtype) %>%
  summarise(mean_fatalities = mean(fatalities, na.rm = TRUE),
            mean_injuries = mean(injuries, na.rm = TRUE),
            total_casualties = sum(fatalities + injuries)) %>%
  dplyr::filter(total_casualties > 1000) %>%
  ggplot(aes(x = reorder(as_factor(evtype), as.numeric(total_casualties)),
           y = as.numeric(total_casualties))) +
  geom_point(aes()) +
  toolboxr::rotate_axis_labels("x", 90)


## ---- include=FALSE-------------------------------------------------------------------------------------
## add 2)
names(storm_cleaned)
econ <- storm_cleaned %>%
  group_by(evtype) %>%
  summarise(total_damage_crops = sum(cropdmg, na.rm = TRUE),
            total_damage_properties = sum(propdmg, na.rm = TRUE)) %>%
  dplyr::filter(total_damage_crops > 20000) 



econ %>%
  ggplot(aes(x = reorder(as_factor(evtype), total_damage_crops), 
             y = total_damage_crops)) +
  geom_point() +
  toolboxr::rotate_axis_labels("x", 90) +
  geom_point(data = econ, aes(x = evtype, y = total_damage_properties),
             colour = 'red')

storm_cleaned %>%
  group_by(evtype) %>%
  summarise(total_damage = sum(cropdmg + propdmg, na.rm = TRUE)) %>%
  dplyr::filter(total_damage > 20000) %>%
  ggplot(aes(x = reorder(as_factor(evtype), total_damage), 
             y = total_damage)) +
  geom_point() +
  toolboxr::rotate_axis_labels("x", 90)




## ---- include=FALSE-------------------------------------------------------------------------------------
storm_cleaned %>%
  dplyr::filter(evtype == "TORNADO") %>%
  group_by(state) %>%
  tally() %>%
  arrange(desc(n)) %>%
  ggplot(aes(x = reorder(as_factor(state), n), 
             y = n)) +
  geom_point() +
  coord_flip()


## ---- include=FALSE-------------------------------------------------------------------------------------
storm %>%
  group_by(state) %>%
  summarise(total_casualties = sum(injuries + fatalities)) %>%
  ggplot(aes(x = reorder(as_factor(state), total_casualties), 
             y = total_casualties)) +
  geom_point() +
  coord_flip()


## ---- include=FALSE-------------------------------------------------------------------------------------
storm_cleaned %>%
  group_by(year) %>%
  dplyr::filter(evtype == "TORNADO") %>%
  summarise(total_casualties = sum(injuries + fatalities)) %>%
  ggplot(aes(x = reorder(as_factor(year), total_casualties), 
             y = total_casualties)) +
  geom_point() +
  coord_flip() +
  toolboxr::rotate_axis_labels("x", 90)





## ---- clean_up, include=FALSE, eval=FALSE---------------------------------------------------------------
## ## remove the large storm_data.csv file
## file.remove(here::here("data", "storm_data.csv"))

