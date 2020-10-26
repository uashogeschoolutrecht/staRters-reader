## ---- message=FALSE, error=FALSE, warning=FALSE---------------------------------------------------------
library(tidyverse)
library(dslabs)


## ---- eval=FALSE----------------------------------------------------------------------------------------
## citation(package = "tidyverse")
## citation(package = "dplyr")


## ---- read_data-----------------------------------------------------------------------------------------
pertussis_data <- read_csv(
  file = here::here( 
                  "data", 
                  "CISID_pertussis_10082018.csv"),
                           comment = "#", 
                           na = c("", " ")
  )



## ---- inspect_data--------------------------------------------------------------------------------------
pertussis_data
names(pertussis_data)


## -------------------------------------------------------------------------------------------------------
pertussis_data


## ---- eval=FALSE, error_variable_reference--------------------------------------------------------------
## ## try the code below, why does it fail?
## pertussis_data_tidy <- pertussis_data %>%
##   gather(1980:2018, key = "year", value = "annual_pertussis_cases")


## ---- good_variable_reference---------------------------------------------------------------------------
pertussis_data_tidy <- pertussis_data %>% 
  gather(`1980`:`2018`, key = "year", 
                        value = "annual_pertussis_cases") %>%
  mutate(annual_pertussis_cases = as.numeric(annual_pertussis_cases
                                             ))
pertussis_data_tidy


## ---- fig.align='right', echo=FALSE---------------------------------------------------------------------
knitr::include_graphics(path = here::here("images", "pipe.png"), dpi = 50)


## ----magrittr, message = FALSE--------------------------------------------------------------------------
library(magrittr)


## -------------------------------------------------------------------------------------------------------
names(pertussis_data_tidy)
## we can `rename()` a variable and `select()` variables
pertussis_data_tidy <- pertussis_data_tidy %>%
  dplyr::rename(some_strange_index = X1,
       country = X2)

pertussis_data_tidy %>% head(2)


## -------------------------------------------------------------------------------------------------------
pertussis_data_tidy <- pertussis_data_tidy %>%
  dplyr::select(country,
          year,
          annual_pertussis_cases)

pertussis_data_tidy %>% head(2)


## ---- eval=FALSE----------------------------------------------------------------------------------------
## only_cases <- pertussis_data_tidy %>%
##   dplyr::select(-c(country, year))
## 
## pertussis_data_tidy %>% head(2)
## 
## 
## 
## 
## 
## ## When selecting multiple columns, construct a vector with `c()`
## ## like select(-c(columns_1, columns_2, column_3))
## 


## -------------------------------------------------------------------------------------------------------
data("gapminder", package = "dslabs")
gapminder <- gapminder %>% as_tibble()


## -------------------------------------------------------------------------------------------------------
# pertussis_data_tidy
# gapminder
gapminder$year <- as.character(gapminder$year)

join <-   dplyr::inner_join (gapminder, pertussis_data_tidy, by = c("country", "year")) %>%
  na.omit()
join


## -------------------------------------------------------------------------------------------------------
# join$year %>% as_factor %>% levels()
# join$country %>% as_factor() %>% levels()
netherlands <- join %>%
  dplyr::filter(country == "Netherlands")
netherlands


## -------------------------------------------------------------------------------------------------------
#join$year %>% as_factor %>% levels()
#join$country %>% as_factor() %>% levels()

booleans_demo <- join %>%
  dplyr::filter(country == "Netherlands" |
         country == "Belarus" &
         year == "1990" |                 ## | is OR in R
         year == "1995" &                 ## & is AND in R   
         !annual_pertussis_cases < 100)   ## ! is NOT in R (not smaller                                                             than 100)
booleans_demo


## -------------------------------------------------------------------------------------------------------
numbers <- tribble(
  ~number_1, ~number_2,
  1,          2,
  3,          4,
  5,          6
)  

match_vector <- c(1,3)

## 
numbers %>% dplyr::filter(!number_1 %in% match_vector)


## ---- using_match, options_exercises--------------------------------------------------------------------
## first define the values to match against
years <- c(1990:2010) %>% as.character()
## than do the filtering using %in%
join_filtered <- join %>%
  dplyr::filter(annual_pertussis_cases > 3000 &
         year %in% years) %>%
  dplyr::select(year,
         country,
         annual_pertussis_cases)

join_filtered %>%
  ggplot(aes(x = year,
             y = annual_pertussis_cases)) +
  geom_point(aes(colour = country)) +
  geom_line(aes(group = country, colour = country)) +
  theme(axis.text.x = element_text(angle = -90, hjust = 1))


## -------------------------------------------------------------------------------------------------------
## ascending
join_filtered %>%
  arrange(annual_pertussis_cases)

## descending
join_filtered %>%
  arrange(desc(annual_pertussis_cases))



## -------------------------------------------------------------------------------------------------------
join_new <- join %>% 
  dplyr::mutate(incidence = 
                  (annual_pertussis_cases/population)*100000) %>%
  dplyr::select(incidence, 
         annual_pertussis_cases, 
         country, year) %>%
  arrange(desc(incidence))
join_new 


## -------------------------------------------------------------------------------------------------------
pop_size_corrected <- join_new %>%
  dplyr::filter(country == "Netherlands" | country == "Norway") %>%
  ggplot(aes(x = year, 
             y = incidence)) +
  geom_line(aes(group = country, colour = country)) +
  theme(axis.text.x = element_text(angle = -90, hjust = 1))



## -------------------------------------------------------------------------------------------------------
pop_size_uncorrected <- join %>%
  dplyr::filter(country == "Netherlands" | country == "Norway") %>%
  ggplot(aes(x = year, 
             y = annual_pertussis_cases)) +
  geom_line(aes(group = country, colour = country)) +
  theme(axis.text.x = element_text(angle = -90, hjust = 1))


## ---- fig.width=10--------------------------------------------------------------------------------------
cowplot::plot_grid(pop_size_uncorrected,
                   pop_size_corrected, labels = c("A", "B"))


## ---- correct_population, options_exercises-------------------------------------------------------------
join %>% 
  dplyr::mutate(log10_pop = log10(population)) %>%
  ggplot(aes(x = gdp,
             y = log10_pop)) +
  geom_point(aes(colour = continent)) 
#+
 # facet_wrap(~year)



## ---- fig.width=8, fig.height=8-------------------------------------------------------------------------
summary_plot <- join %>%
  group_by(country) %>%
  summarise(total_pertussis_cases = sum(annual_pertussis_cases)) %>%
  ggplot(aes(x = reorder(as_factor(country), total_pertussis_cases),
             y = total_pertussis_cases)) +
  geom_point() +
  coord_flip() +
  ylab("Total pertussis cases from 1990 - 2013") +
  xlab("Country")
summary_plot


## ---- eval=FALSE----------------------------------------------------------------------------------------
## ## your answer goes here --->


## ---- options_exercises---------------------------------------------------------------------------------
plot <- gapminder %>%
  group_by(year, continent) %>%
  summarise(total_population = sum(population),
            total_gdp = sum(gdp), na.rm = TRUE) %>%
    ggplot(aes(x = year,
               y = total_gdp)) +
  geom_point(aes(colour = continent, size = total_population)) +
  coord_flip()
plot


## -------------------------------------------------------------------------------------------------------
names(join)
join %>%
  dplyr::filter(country == "Netherlands" |
         country == "Belarus") %>%
      ggplot(aes(x = annual_pertussis_cases,
               y = infant_mortality)) +
      geom_point(aes(colour = year)) +
  geom_smooth(method = "lm") +
  facet_wrap(~ country, scales = "free")


## ---- include=FALSE-------------------------------------------------------------------------------------
options_exercises <- knitr::opts_chunk$set(echo = FALSE,
                          warning = FALSE,
                          error = FALSE,
                          message = FALSE,
                          results = 'hide',
                          fig.show = 'hide')


## ---- echo=TRUE-----------------------------------------------------------------------------------------
library(tidyverse)

heights_file <- here::here("data", "heights.RDS")
heights <- read_rds(file = heights_file)
head(heights)
heights
heights_tib <- as_tibble(heights)



## ---- 1a, options_exercises-----------------------------------------------------------------------------
head(heights)
tail(heights)


## ---- 1b, options_exercises-----------------------------------------------------------------------------
library(pander)
pander(summary(heights))


## ---- 1c, options_exercises-----------------------------------------------------------------------------
sum(is.na(heights))
naniar::vis_miss(heights)
naniar::gg_miss_var(heights)


## ---- answer_2a, options_exercises----------------------------------------------------------------------
heights_selected <- heights %>%
  select(id, income, height, weight, sex, race)


## ---- answer_2b, options_exercises----------------------------------------------------------------------
sum(is.na(heights_selected))


## ---- 2c, options_exercises-----------------------------------------------------------------------------
library(stats)
complete_cases <- complete.cases(heights_selected) 
heights_complete <- heights_selected[complete_cases,] 

## viz
naniar::gg_miss_upset(heights_selected)




## ---- 2d, options_exercises-----------------------------------------------------------------------------
sum(is.na(heights_complete))


## ---- 3A,options_exercises------------------------------------------------------------------------------
heights_complete <- as_tibble(heights_complete)
names(heights_complete)

over_200 <- heights_complete %>% 
  dplyr::filter(weight > 200)

over_200 <- dplyr::filter(heights_complete, weight > 200)



## ---- 3b, options_exercises-----------------------------------------------------------------------------

haviest_race <- over_200 %>%
  group_by(race) %>%
  summarise(frequency = n()) %>%
  arrange(desc(frequency))
haviest_race

summary <- summary(over_200)
summary
str(summary)
table(summary[, 6])


# so the answer is "other", which is not surprising


## ---- 3c, options_exercises-----------------------------------------------------------------------------
# filter for 'hispanic' 'males'
tallest_hispanic_men <- heights_complete %>%
  dplyr::filter(race == "hispanic" & sex == "male") %>%
# now sort the rows in descending order
  arrange(desc(height))
# select only the first five rows
five_tallest_hispanic_men <- tallest_hispanic_men[c(1:5), ]

# all weights: 
five_tallest_hispanic_men$weight

# mean height
  mean(five_tallest_hispanic_men$height)




## ---- 3d, options_exercises-----------------------------------------------------------------------------
rank_women <- heights_complete %>%
  dplyr::filter(sex == "female") %>%
  arrange(desc(height))

(two_tallest_women <- rank_women[c(1,2), ])


match_1 <- heights_complete %>%
  dplyr::filter(sex == "male" & 
         weight == two_tallest_women$weight[1] & 
         height == two_tallest_women$height[1])

match_1

match_2 <- heights_complete %>%
  dplyr::filter(sex == "male" & 
         weight == two_tallest_women$weight[2] &
         height == two_tallest_women$height[2])
match_2


## ---- 4a, options_exercises-----------------------------------------------------------------------------
heights_complete <- heights_complete %>%
  mutate(height_m = (height*2.54/100),  
         weight_kg = weight*0.45359237)

heights_complete


heights_complete$height_m <- round(heights_complete$height_m, 2)
heights_complete$weight_kg <- round(heights_complete$weight_kg, 1)

head(heights_complete) 


## ---- 4c, options_exercises-----------------------------------------------------------------------------
heights_complete <- heights_complete %>%
  mutate(bmi = (weight_kg / height_m^2))
head(heights_complete)
 


## ---- 5a, options_exercises-----------------------------------------------------------------------------
names(heights_complete)
heights_summary <- heights_complete %>%
  dplyr::select(income:bmi) %>%
  group_by(race, sex) %>%
  summarise(mean_height_in = mean(height),
            mean_height_m = mean(height_m),
            mean_weight_lbs = mean(weight),
            mean_weight_kg = mean(weight_kg),
            mean_bmi = mean(bmi),
            mean_income = mean(income)) %>%
  arrange(desc(mean_income))




## ---- 5b, options_exercises-----------------------------------------------------------------------------
names(heights_complete)
heights_summary <- heights_complete %>%
  dplyr::select(income:bmi) %>%
  group_by(race, sex) %>%
  summarise(mean_height_in = mean(height),
            mean_height_m = mean(height_m),
            mean_weight_lbs = mean(weight),
            mean_weight_kg = mean(weight_kg),
            mean_income = mean(income)) %>% 
  arrange(desc(mean_income)) 


## ---- 5c, options_exercises-----------------------------------------------------------------------------
males <- heights_summary %>%
  dplyr::filter(sex == "male") %>% 
  dplyr::select(mean_income, race) %>%
  arrange(desc(race))

females <- heights_summary %>%
  dplyr::filter(sex == "female") %>%
  dplyr::select(mean_income, race) %>%
  arrange(desc(race))

difference <- as_tibble(cbind(males, females)) 
difference

names(difference) <- c("mean_income_m", "race_m", "mean_income_f", "race_f")
names(difference)
# str(difference)

difference %>%
  mutate(delta_income = (mean_income_m - mean_income_f)) #%>%
  #  arrange(delta_income)


## BAR plot
heights_summary %>%
  ggplot(aes(x = race,
         y = mean_income)) +
  geom_col(aes(fill = sex), position = "dodge")



