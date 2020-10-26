## ---- fig.cap="Visualizing stages for EDA", echo=FALSE--------------------------------------------------
dg <- DiagrammeR::grViz("
digraph rmarkdown {
  'New DATA' -> 'Characteristics'
  'Characteristics' -> 'Distributions'
  'Distributions' -> 'Outliers' 
  'Outliers' -> 'Sorting'
  'Sorting' -> 'Trends'
  'Trends' -> 'Models'
  'Models' -> 'Formal'
  'Formal' -> 'Characteristics'
}
")
dg



## ---- message=FALSE, error=FALSE, warning=FALSE---------------------------------------------------------
library(dslabs)
library(tidyverse)
library(reshape)
library(pastecs)
library(naniar)
library(GGally)


## ---- results='hide'------------------------------------------------------------------------------------
citation(package = "ggplot2")
citation(package = "tidyverse")
citation(package = "dslabs")


## ---- eval=FALSE----------------------------------------------------------------------------------------
## data(package="dslabs") %>% print()


## ---- echo=FALSE----------------------------------------------------------------------------------------
knitr::include_graphics(path = here::here(
  "images",                                                                     "hex-ggplot2.png"))


## -------------------------------------------------------------------------------------------------------
list.files(system.file("script", package = "dslabs"))


## -------------------------------------------------------------------------------------------------------
wrangle_files <- list.files(system.file("script", package = "dslabs"), full.names = TRUE)
wrangle_files[[25]]



## -------------------------------------------------------------------------------------------------------
data("gapminder", package = "dslabs")
## ?gapminder for more info on the variables in the dataset
gapminder <- gapminder %>% as_tibble


## -------------------------------------------------------------------------------------------------------
gapminder <- gapminder %>% as_tibble()
gapminder %>% head(2)
head(gapminder, 2)
names(gapminder)


## -------------------------------------------------------------------------------------------------------
naniar::vis_miss(gapminder) + 
  toolboxr::rotate_axis_labels(axis = "x", angle = 90)

ggsave(filename = "missing_gapminder.svg", height = 11, width = 10)

naniar::gg_miss_var(gapminder) 

naniar::gg_miss_case(gapminder)


## ---- fig.width=8, fig.height=8-------------------------------------------------------------------------
gapminder %>%
  dplyr::filter(year == 1960 | year == 2000) %>%
  dplyr::filter(continent == "Europe") %>%
  ggplot(aes(x = country,
         y = gdp)) +
  naniar::stat_miss_point() +
  coord_flip() +
  facet_wrap(~year)



## ---- fig.width=8, fig.height=8, warning=FALSE, message=FALSE, error=FALSE------------------------------
gapminder %>%
  dplyr::select(-c(country, region)) %>%
ggpairs()


## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point()


## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(alpha = 0.05)


## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = continent))

## or combined with transparancy
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = continent), alpha = 0.1) +
  guides(colour = guide_legend(override.aes = list(alpha = 1)))




## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Africa") %>%
  ggplot(aes(x = year, y = population)) + 
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

## using a colour for continent
gapminder %>% 
  dplyr::filter(continent == "Africa") %>%
  ggplot(aes(x = year, y = log10(population))) + ## why log10?
  geom_line(aes(group = country, 
                colour = country), 
            show.legend = FALSE, size = 1) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))



## ---- include=FALSE-------------------------------------------------------------------------------------
## PPDAC: problem, plan, data, analysis, conclusion(s)
## problem: Is the rate in population growth different between Africa and Asia
## plan: Get data for growth of population over the past 10 years, from most (if not all) countries of the continents Africa and Asia, check the integrety of the data, clean if neccessary, check missing values, check validity of the source of the data, check minimal and maximal values, generate summary statistics
## data: use Gapminder dataset in the `{dslabs}` or `{gapminder}` R package (any other ideas?).
## Analysis: see partly under plan for initial steps: Filter data for continents Africa and Asia, summarize data for continents, plot population size to time (years), analyze data with a regression model (linear regression?, exponential?), Determine fit and slope paramters form the models. Perform comparisons of models for best fit. Analyze if slopes are different between continents, how? Maybe two way ANOVA? or repeated measures, multilevel? 
## Conclusions: draw conclusions about growth rate (slope parameter is proxy for growth rate)






## ---- include=FALSE-------------------------------------------------------------------------------------
## see answer above (regression, multilevel analysis of variance), normally distributed residuals, homoscedasticity (equal variance)


## ---- include=FALSE-------------------------------------------------------------------------------------
## look at the fit for linear or exponential regression models (r-squared), countries with population growth curves that display a very poor fit are deviating. 


## -------------------------------------------------------------------------------------------------------
## see above but for every continent, how would you keep all the models built for all countries together?


## -------------------------------------------------------------------------------------------------------
names(gapminder)

africa_high_life_exp <- gapminder %>% 
 dplyr::filter(continent == "Africa") %>%
 dplyr::filter(life_expectancy > 60 & fertility < 3) %>%
ggplot(aes(x = year,
             y = life_expectancy)) +
  geom_point(aes(colour = continent)) +
  guides(colour = guide_legend(
    override.aes = list(alpha = 1))) +        
  theme_bw() +
  facet_wrap(~ country) +
  theme(legend.position="none") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

africa_high_life_exp



## ---- echo=FALSE, results='hide', fig.show='hide'-------------------------------------------------------

## pipe symbol 
reduce_data_plot <- gapminder %>% 
  dplyr::filter(continent == "Africa"| continent == "Europe") %>%
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = continent), alpha = 0.2) 
  
reduce_data_plot


## -------------------------------------------------------------------------------------------------------
## or e.g. show only two years and map a shape to continent
shape_plot <- gapminder %>% 
  dplyr::filter(continent == "Africa" | continent == "Europe",
         year == "1960" | year == "2010") %>%
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = as_factor(as.character(year)), 
                 shape = continent), 
             alpha = 0.7) +
  theme_bw() +
  guides(colour = guide_legend(override.aes = list(alpha = 1)))
shape_plot


## -------------------------------------------------------------------------------------------------------
facets_plot <- gapminder %>% 
  dplyr::filter(continent == "Africa" | continent == "Europe",
         year == "1960" | year == "2010") %>%
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = continent), alpha = 0.5) +
  facet_wrap(~ year) + 
  guides(colour = guide_legend(override.aes = list(alpha = 1)))

facets_plot


## -------------------------------------------------------------------------------------------------------
library(ggrepel)

years <- c("1960", "1970", "1980", "1990", "2000", "2010")

summarize_plot <- gapminder %>% 
  dplyr::filter(year %in% years) %>%
  group_by(continent, year) %>%
  summarise(mean_life_expectancy = mean(life_expectancy),
            mean_fertility = mean(fertility)) %>%
  ggplot(aes(x = mean_fertility,
             y = mean_life_expectancy)) +
  geom_point(aes(colour = continent, shape = as_factor(year)), alpha = 0.7) +    guides(colour = guide_legend(override.aes = list(alpha = 1)))

summarize_plot


## -------------------------------------------------------------------------------------------------------
library(ggrepel)

years <- c("1960", "1970", "1980", "1990", "2000", "2010")

labels_plot <- gapminder %>% 
  dplyr::filter(year %in% years) %>%
  group_by(continent, year) %>%
  summarise(mean_life_expectancy = mean(life_expectancy),
            mean_fertility = mean(fertility)) %>%
  ggplot(aes(x = mean_fertility,
             y = mean_life_expectancy)) +
  geom_point(aes(colour = continent), alpha = 0.7) +
  geom_label_repel(aes(label=year), size = 2.5, box.padding = .5) +              guides(colour = guide_legend(override.aes = list(alpha = 1)))
  
labels_plot


## -------------------------------------------------------------------------------------------------------
## Model
lm <- gapminder %>% lm(formula = life_expectancy ~ fertility)

correlation <- cor.test(x = gapminder$fertility, y = gapminder$life_expectancy, method = "pearson")

# save predictions of the model in the new data frame 
# together with variable you want to plot against
predicted_df <- data.frame(gapminder_pred = predict(lm, gapminder), 
                           fertility = gapminder$fertility)



## -------------------------------------------------------------------------------------------------------
model_plot <- gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(alpha = 0.03) +
  geom_line(data = predicted_df, aes(x = fertility, 
                                     y = gapminder_pred),
            colour = "darkred", size = 1)

model_plot


## ---- echo=FALSE----------------------------------------------------------------------------------------
library(ggpubr)
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(alpha = 0.02) +
  
  geom_line(data = predicted_df, 
            aes(x = fertility, 
                y = gapminder_pred),
            colour = "darkred", size = 1) +
  stat_cor(method = "pearson", label.x = 2, label.y = 30) +
  theme_bw()



## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(alpha = 0.02) +
  geom_smooth(method = "lm") +
  stat_cor(method = "pearson", label.x = 2, label.y = 30) +
  theme_bw()


## -------------------------------------------------------------------------------------------------------
africa <- gapminder %>%
  dplyr::filter(continent == "Africa")
  


## -------------------------------------------------------------------------------------------------------
africa <- africa %>%
  mutate(welfare_index = (life_expectancy*gdp)/1000)



## -------------------------------------------------------------------------------------------------------
africa %>%
  ggplot(aes(x = year, y = welfare_index)) +
  geom_line(aes(group = country, colour = country), 
            show.legend = FALSE, size = 1) 


## -------------------------------------------------------------------------------------------------------
africa %>%
  ggplot(aes(x = year, y = log10(welfare_index))) +
  geom_line(aes(group = country, colour = country), 
            show.legend = FALSE, size = 1) 


## -------------------------------------------------------------------------------------------------------
continuous <- gapminder %>%
  dplyr::filter(country == "Netherlands" | 
                country == "China" |
                country == "India") %>%
  dplyr::filter(year %in% years) %>%
  ggplot(aes(x = year,
         y = life_expectancy)) +
  geom_point(aes(size = population, colour = country)) +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  geom_line(aes(group = country, colour = country), size = 1) +
  theme_bw()
continuous


## -------------------------------------------------------------------------------------------------------
gapminder$year %>% unique()

gapminder %>%
  group_by(continent, country, year) %>%
  summarise(mean_pop = mean(population)) %>%
  ggplot(aes(x = year, y = country)) +
  geom_tile(aes(fill = mean_pop)) +
  toolboxr::rotate_axis_labels(axis = "x", angle = 90) +
  theme(axis.text.y= element_text(size = 5))



## -------------------------------------------------------------------------------------------------------
population_plot <- gapminder %>% 
  dplyr::group_by(continent, year) %>%
  dplyr::filter(year %in% years) %>%
  summarise(sum_population = sum(population, na.rm = TRUE),
            mean_life_exp = mean(life_expectancy, na.rm = TRUE)) %>% 
  ggplot(aes(x = year, 
             y = log10(sum_population))) +
    geom_point(aes(colour = continent, 
                   size = mean_life_exp),
                   alpha = 0.5) +
    geom_line(aes(group = continent,
                  colour = continent)) +
    guides(colour = guide_legend(override.aes = list(alpha = 1)))
  
population_plot


## -------------------------------------------------------------------------------------------------------

over_10_million <- gapminder %>%
  dplyr::filter(
  continent == "Europe",
  year == 2010, 
  population >= 1e7)

ranking_plot <- gapminder %>%
  dplyr::filter(continent == "Europe",
                year == 2010) %>%
  ggplot(aes(x = reorder(as_factor(country), population),
             y = log10(population))) +
  geom_point() +
  ylab("log10(Population)") +
  xlab("Country") + 
  coord_flip() +
  geom_point(data = over_10_million, colour = "red")

ranking_plot


## -------------------------------------------------------------------------------------------------------
## without summarizing for countries
gapminder$continent %>% as_factor() %>% levels()
gapminder %>% 
  dplyr::filter(continent == "Americas" | continent == "Oceania") %>%
  ggplot(aes(x = year,
             y = life_expectancy)) +
  geom_line(aes(group = continent,
                colour = continent))


## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Americas" | continent == "Oceania") %>%
  ggplot(aes(x = year,
             y = life_expectancy)) +
  geom_point(aes(colour = country)) +
  theme(legend.position="none") +
  facet_wrap( ~ continent) +
  theme(legend.position="none") 
  


## -------------------------------------------------------------------------------------------------------
gapminder$continent %>% as_factor() %>% levels()
gapminder %>% 
  dplyr::filter(continent == "Americas" | continent == "Oceania") %>%
  group_by(continent, year) %>%
  summarise(mean_life_expectancy = mean(life_expectancy)) %>%
  ggplot(aes(x = year,
             y = mean_life_expectancy)) +
  geom_line(aes(group = continent,
                colour = continent), size = 3) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  group_by(continent) %>%
  dplyr::filter(year %in% years) %>%
  ggplot(aes(x = year,
             y = infant_mortality)) +
  geom_point(aes(colour = country)) +
  theme(legend.position="none")
  


## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  dplyr::filter(year %in% years) %>%
    group_by(continent) %>%
  ggplot(aes(x = year,
             y = infant_mortality)) +
  geom_point(aes(colour = continent), position = "jitter") 
  


## -------------------------------------------------------------------------------------------------------
mean_inf_mort <- gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  dplyr::filter(year %in% years) %>%
  group_by(continent, year) %>%
  summarise(mean_infant_mortality = mean(infant_mortality, na.rm = TRUE))

gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  dplyr::filter(year %in% years) %>%
    group_by(continent) %>%
  ggplot(aes(x = year,
             y = infant_mortality)) +
  geom_point(aes(colour = continent), position = "jitter") +

## summary data added to previous 
  geom_line(data = mean_inf_mort, aes(x = year, 
                                      y = mean_infant_mortality, 
                                      colour = continent),  size = 2)




## -------------------------------------------------------------------------------------------------------
library(ggiraph)

gapminder$country <- 
  str_replace_all(string = gapminder$country, 
                pattern = "'", 
                replacement = "_")


interactive_inf_mort <- gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  dplyr::filter(year %in% years) %>%
    group_by(region, country) %>%
  ggplot(aes(x = year,
             y = infant_mortality)) +
  
  geom_point_interactive(aes(tooltip = country, colour = region), position = "jitter") +
  
#  geom_point(aes(colour = continent), position = "jitter") +

## summary data added to previous 
 geom_line(data = mean_inf_mort, aes(x = year, 
                                      y = mean_infant_mortality, 
                                      colour = continent, group = continent),  size = 2
            )

interactive_inf_mort

gapminder$country %>% as_factor() %>% levels()
ggiraph(ggobj = interactive_inf_mort)



## -------------------------------------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  dplyr::filter(year %in% years) %>%
  group_by(continent, year) %>%
  summarise(mean_infant_mortality = mean(infant_mortality, na.rm = TRUE)) %>% 
  ggplot(aes(x = year,
             y = mean_infant_mortality)) +
  geom_col(aes(fill = continent), position = "dodge") 
  


## -------------------------------------------------------------------------------------------------------
## A more complicated example (for showing the capabilities of ggplot2)

west <- c("Western Europe","Northern Europe","Southern Europe",
          "Northern America","Australia and New Zealand")

pub_plot <- gapminder <- gapminder %>%
  mutate(group = case_when(
    region %in% west ~ "The West",
    region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
    region %in% c("Caribbean", "Central America", "South America") ~ "Latin America",
    continent == "Africa" & region != "Northern Africa" ~ "Sub-Saharan Africa",
    TRUE ~ "Others"))
gapminder <- gapminder %>%
  mutate(group = factor(group, levels = rev(c("Others", "Latin America", "East Asia","Sub-Saharan Africa", "The West"))))

dplyr::filter(gapminder, year%in%c(1962, 2013) & !is.na(group) &
         !is.na(fertility) & !is.na(life_expectancy)) %>%
  mutate(population_in_millions = population/10^6) %>%
  ggplot( aes(fertility, y=life_expectancy, col = group, size = population_in_millions)) +
  geom_point(alpha = 0.8) +
  guides(size=FALSE) +
  theme(plot.title = element_blank(), legend.title = element_blank()) +
  coord_cartesian(ylim = c(30, 85)) +
  xlab("Fertility rate (births per woman)") +
  ylab("Life Expectancy") +
  geom_text(aes(x=7, y=82, label=year), cex=7, color="grey") +
  facet_grid(. ~ year) +
  theme(strip.background = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank(),
   legend.position = "top")

pub_plot


## -------------------------------------------------------------------------------------------------------
heights_data <- read_csv(file = here::here("data",
                                           "heights_outliers.csv"))

heights_data


## -------------------------------------------------------------------------------------------------------
summary_heights_data <- heights_data %>%
  group_by(sex, age) %>%
  summarise(mean_height = mean(height, na.rm = TRUE),
            min_height = min(height),
            max_height = max(height)) %>%
  arrange(desc(mean_height))

summary_heights_data[c(1:4),]


## -------------------------------------------------------------------------------------------------------

heights_data %>%
  ggplot(aes(x = height)) +
  geom_histogram(aes(stat = "identity"), bins = 200)


## -------------------------------------------------------------------------------------------------------
heights_data %>%
  ggplot(aes(y = log10(height))) +
  geom_boxplot()


## -------------------------------------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height > 100)


## -------------------------------------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(y = height)) +
  geom_boxplot()


## -------------------------------------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(y = height, x = sex)) +
  geom_boxplot()



## -------------------------------------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(height)) +
  geom_density(aes(y = ..density..))


## -------------------------------------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(height)) +
  geom_density(aes(y = ..density.., colour = sex), size = 1.5)



## -------------------------------------------------------------------------------------------------------
model <- lm(data = heights_data, height ~ sex)
anova(model) %>% summary

## are other factors (e.g. race) contributing? 
model <- lm(data = heights_data, height ~ sex * race)
anova(model)

## look at a plot
heights_data %>%
#  group_by(race, sex) %>%
#  summarise(mean_height = mean(height)) %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(x = race, y = height)) + 
  geom_point(aes(colour = race), position = "jitter")
             
## The sample size is unbalanced, s this a problem for the ANOVA we just did?

heights_data %>%
  group_by(race, sex) %>%
  tally() %>%
  ggplot(aes(x = race, y = n)) +
  geom_col(aes(fill = sex), position = "dodge")




## ---- ex_pkgs-------------------------------------------------------------------------------------------
## the packages that you minimally need for this exercise
library(tidyverse)
library(cowplot)
library(readr)
library(readxl)
## add more if you need them


## ---- load_airq-----------------------------------------------------------------------------------------
## load dataset airquality
airq <- datasets::airquality


## ---- inspect_airq--------------------------------------------------------------------------------------
head(airq)
sum(is.na(airq)) # so no missing values
str(airq) # you see that all variables have the right type


## ---- adapt_names_airq----------------------------------------------------------------------------------
names(airq) <- tolower(names(airq))
head(airq)
names(airq) <- str_replace_all(names(airq), pattern = "\\.", replacement = "_")
head(airq)



## ---- all_data_airq-------------------------------------------------------------------------------------
names(airq)
plot_1c <-  airq %>%
  ggplot(aes(x = month, y = wind)) +
  geom_point(aes(), alpha = 0.4) 

#  geom_jitter(aes(x = time, y = weight), position = "jitter") 
  
plot_1c


## ---- overplotting_airq---------------------------------------------------------------------------------
names(airq)
plot_1d <-  airq %>%
  ggplot(aes(x = month, y = wind)) +
  geom_point(aes(), alpha = 0.4, position = "jitter")
 
plot_1d



## ---- line_wind_month-----------------------------------------------------------------------------------
names(airq)
plot_1e <-  airq %>%
  ggplot(aes(x = month, y = wind)) +
  geom_point(aes(), alpha = 0.4, position = "jitter")  +
  geom_smooth(method = "lm")
  #
#+
 # geom_jitter(position = "jitter") 
  
plot_1e



## -------------------------------------------------------------------------------------------------------
airq %>%
  group_by(month) %>%
  summarise(mean_wind = mean(wind, na.rm = TRUE),
            sd = sd(wind, na.rm = TRUE)) %>%
  ggplot(aes(x = month, y = mean_wind)) +
  geom_col() +
  geom_errorbar(aes(x = month, ymax = mean_wind+sd, 
                    ymin = mean_wind - sd), size = 1, width = 0.4)



## ---- echo=TRUE-----------------------------------------------------------------------------------------
tb_burden <- read.csv(
  file = here::here(
    "data",
    "messy",
    "TB_burden_countries_2016-12-08_messy.csv"))


names(tb_burden)


## -------------------------------------------------------------------------------------------------------
names(tb_burden)
tb_data_selected <- tb_burden %>%
  dplyr::select(
    iso3,
    country,
    g_whoregion,
    year,
    e_inc_num,
    e_mort_exc_tbhiv_num,
    e_pop_num,
  )



## ---- echo=TRUE-----------------------------------------------------------------------------------------
dictionary <- read_csv("./data/messy/TB_data_dictionary_2016-12-08.csv")

## filter solution
dplyr::filter(dictionary, variable_name %in% names(tb_data_selected))




## ---- high_burden---------------------------------------------------------------------------------------
tb_burden %>%
  ggplot(aes(x = year, y = log10(e_inc_num))) +
  geom_point(aes(colour = country), position = "jitter") +
  theme(legend.position = "none") +
  ggtitle("Number of total TB cases")

tb_burden %>%
  ggplot(aes(x = year, y = e_inc_num)) +
  geom_point(aes(colour = country), position = "jitter") +
  theme(legend.position = "none") +
  ggtitle("Number of total TB cases")

tb_burden %>%
  dplyr::filter(e_inc_num > 2500000) %>%
  as_tibble() %>%
  select(country) %>%
  unique()


## ---- incidence_tb--------------------------------------------------------------------------------------
tb_data_selected %>%
  as_tibble() %>%
  mutate(incidence_1e3 = (e_inc_num/e_pop_num)*1000) %>%
  dplyr::filter(incidence_1e3 > 5) %>%
  ggplot(aes(x = year,
             y = incidence_1e3)) +
  geom_point(aes(colour = country)) +
  geom_line(aes(group = country, colour = country), show.legend = FALSE) +
  theme(legend.position = "none") +
  ggtitle("Number of total TB cases")



## ---- highest_tb_incidence------------------------------------------------------------------------------
tb_data_selected %>%
  as_tibble() %>%
  mutate(incidence_1e3 = (e_inc_num/e_pop_num)*1000) %>%
  dplyr::filter(incidence_1e3 > 5,
                year == "2010") %>%
  arrange(desc(incidence_1e3)) %>%
  select(country, incidence_1e3)


## ---- average_inc_tb------------------------------------------------------------------------------------
names(tb_data_selected)
tb_data_selected %>%
  as_tibble() %>%
  mutate(incidence_1e3 = (e_inc_num/e_pop_num)*1000) %>%  
  group_by(g_whoregion, year) %>%
  summarize(median_incidence_per_region = median(incidence_1e3)) %>%
  ggplot(aes(x = year, 
             y = median_incidence_per_region)) +
    geom_point(aes(colour = g_whoregion)) +
  geom_line(aes(group = g_whoregion, colour = g_whoregion)) +
  ggtitle("Mean Incidence of TB per WHO region")
  


## ---- echo=TRUE, eval=FALSE-----------------------------------------------------------------------------
## library(tmap)
## data("World") # from the tmap package
## names(World)
## names(tb_burden)
## 
## World <- World %>%
##   dplyr::rename(iso3 = iso_a3)
## 
## joined_data <- left_join(World, tb_data_selected, by = "iso3")
## names(joined_data)
## 
## joined_data <- joined_data %>%
##   mutate(incidence_1e3 = (e_inc_num/e_pop_num)*1000)


## ---- 4b, options_exercises, eval=FALSE-----------------------------------------------------------------
## names(joined_data)
## joined_data %>%
##   na.omit() %>%
##   ggplot(aes(x = gdp_cap_est,
##              y = incidence_1e3)) +
##   geom_point(alpha = 0.2) +
##   facet_wrap(~ year) +
##   geom_smooth(se = FALSE) -> ## reverse assign
##   plot_gdp_tuberculosis
## 
## plot_gdp_tuberculosis


## ---- 5a, eval=FALSE------------------------------------------------------------------------------------
## joined_data %>%
##   ggplot(aes(x = incidence_1e3)) +
##   geom_histogram(aes(fill = g_whoregion), bins = 50)
## 
## 
## joined_data %>%
##   ggplot(aes(x = gdp_cap_est)) +
##   geom_histogram(aes(fill = g_whoregion), bins = 50)


## ---- 5b, eval=FALSE------------------------------------------------------------------------------------
## joined_data %>%
##   ggplot(aes(x = log10(incidence_1e3))) +
##   geom_freqpoly(aes(colour = g_whoregion), size = 1) +
##   facet_wrap(~year)
## 
## joined_data %>%
##   ggplot(aes(x = log10(gdp_cap_est))) +
##   geom_freqpoly(aes(colour = g_whoregion), size = 1) +
##   facet_wrap(~year)
## 
## 
## joined_data %>%
##   ggplot(aes(x = log10(gdp_cap_est))) +
##   geom_density(aes(colour = g_whoregion, y = ..density..), size = 1) +
##   facet_wrap(~year)
## 


## ---- echo=TRUE-----------------------------------------------------------------------------------------
## load dataset ChickWeights
chicks <- datasets::ChickWeight 


## ---- 6a------------------------------------------------------------------------------------------------
head(chicks)
sum(is.na(chicks)) # so no missing values
str(chicks) # you see that all variables have the right type


## ---- 6b------------------------------------------------------------------------------------------------
names(chicks) <- tolower(names(chicks))
names(chicks) <- c("weight", "time", "chick", "diet")  
head(chicks)


## ---- 6c------------------------------------------------------------------------------------------------
names(chicks)
plot_1c <-  ggplot(data = chicks, aes(x = time, y = weight)) +
  geom_point(aes(colour = diet), alpha = 0.4, position = "jitter") 

#  geom_jitter(aes(x = time, y = weight), position = "jitter") 
  
plot_1c


## ---- 6d------------------------------------------------------------------------------------------------
plot_1d_1 <-  ggplot(data = chicks, 
                   aes(x = time, y = weight)) +
  geom_point(alpha = 0.6) 
## setting alpha does not really solve the overplotting 
plot_1d_1

plot_1d_2 <-  ggplot(data = chicks, 
                   aes(x = time, y = weight)) +
  geom_point() + geom_jitter(position = "jitter") 
## setting "jitter" solves it
plot_1d_2

## antoher solution
plot_1d_3 <-  ggplot(data = chicks, 
                   aes(x = time, y = weight, color = diet)) +
  geom_point() + geom_jitter(position = "jitter") 
## setting "color = diet" provides even more insight
plot_1d_3



## ---- 6e------------------------------------------------------------------------------------------------
plot_1e <-  ggplot(data = chicks,
                   aes(x = time, y = weight, color = diet)) +
  geom_point()
plot_1e


## ---- 6f------------------------------------------------------------------------------------------------
set.seed(1234)
plot_1f <-  ggplot(data = chicks,
                   aes(x = time, y = weight, color = diet)) +
  geom_point() +
  geom_jitter(position = "jitter")
plot_1f


## ---- 6g------------------------------------------------------------------------------------------------
# summarize the chicks data with {dyplyr}
chicks_summary <- chicks %>%
  group_by(diet, time) %>%
  summarise(mean_weight = mean(weight)) 

# dot plot with a smoother, the method for smoothing is "linear model"
plot_1g <-  ggplot(data = chicks_summary, 
  aes(x = time, y = mean_weight, color = diet)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

plot_1g


plot(chicks$time ~ chicks$chick) # base plotting R




## ---- 7a------------------------------------------------------------------------------------------------
# tidyverse solution
# readxl::readxl solution
library(readxl)
path_to_file <- here::here("data", "Animals.xls")
animals_readxl <- readxl::read_excel(path = path_to_file, sheet = 1,
                              skip = 1, trim_ws = TRUE)

animals_readxl <- na.omit(animals_readxl)

# ?readxl
## the names are not correct, change if neccessary, see 2C


## ---- eval=FALSE----------------------------------------------------------------------------------------
## # Other option: {xlsx}
## # install.packages("xlsx")
## library(xlsx)
## # ?read.xlsx2
## animals_xlsx <- read.xlsx2(file = path_to_file, startRow = 4,
##                            sheetIndex = 1)
## # okay, so the version of Excel originally used to build this datafile is too old...


## ---- eval=FALSE----------------------------------------------------------------------------------------
## # other option: {gdata}
## library(gdata)
## # ?read.xls()
## # ?read.csv
## animals_gdata = read.xls(path_to_file, sheet = 1, header = TRUE,
## skip = 1)
## 
## ## This needs a Perl installation (see: strawberryperl.com)
## ## OKAY, so obviously, there are good reasons, NOT to use Excel files to store data!!
## 


## ---- 7b------------------------------------------------------------------------------------------------
names(animals_readxl) <- c("animal", "body_weight", "brain_weight")

## other solution:
colnames(animals_readxl) <- c("animal", "body_weight", "brain_weight")

pander::pander(head(animals_readxl))


## ---- 7c------------------------------------------------------------------------------------------------
library(dplyr)
## dplyr solution:
animals_readxl %>% 
  dplyr::filter(body_weight == 6654 & brain_weight == 5712)

## base-R solution 
#ind <- animals_readxl[,2] == 6654 & animals_readxl[, 3] == 5712 
#animals_readxl[ind, ]


## ---- 7d------------------------------------------------------------------------------------------------
## dplyr solution
head(animals_readxl %>% arrange(brain_weight), 1)

## or
animals_readxl %>% 
  dplyr::filter(brain_weight == min(animals_readxl$brain_weight, 
                             na.rm = TRUE))



## ---- 17e-----------------------------------------------------------------------------------------------
library(ggplot2)
plot <- animals_readxl %>% 
  ggplot(aes(x = body_weight, y = brain_weight)) +
    geom_point() +
    geom_smooth()
plot


## ---- 7f------------------------------------------------------------------------------------------------
no_brachio <- animals_readxl %>% 
  dplyr::filter(!animal == "Brachiosaurus") %>%
  ggplot(aes(x = body_weight, y = brain_weight)) +
    geom_point() +
    geom_smooth()
no_brachio


## ---- 7g------------------------------------------------------------------------------------------------
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


## ---- 7h------------------------------------------------------------------------------------------------
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

