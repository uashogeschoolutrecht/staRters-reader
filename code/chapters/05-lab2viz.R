## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE,
                      warning = FALSE,
                      error = FALSE,
                      message = FALSE, 
                      fig.width = 8, fig.height = 6)


## ---- fig.cap="Visualizing stages for EDA", echo=FALSE-------------------
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
", engine = "circo")
dg

svg <- DiagrammeRsvg::export_svg(dg)
?DiagrammeRsvg::export_svg
plotly::orca(dg, file = here::here("images", "test_dg.svg"))


## ------------------------------------------------------------------------
library(dslabs)
library(tidyverse)
library(reshape)
library(pastecs)
library(naniar)
library(GGally)


## ---- results='hide'-----------------------------------------------------
citation(package = "ggplot2")
citation(package = "tidyverse")
citation(package = "dslabs")


## ---- eval=FALSE---------------------------------------------------------
## data(package="dslabs") %>% print()


## ---- echo=FALSE---------------------------------------------------------
knitr::include_graphics(path = here::here(
  "images",                                                                     "hex-ggplot2.png"))


## ------------------------------------------------------------------------
list.files(system.file("script", package = "dslabs"))


## ------------------------------------------------------------------------
wrangle_files <- list.files(system.file("script", package = "dslabs"), full.names = TRUE)
wrangle_files[[25]]



## ------------------------------------------------------------------------
data("gapminder", package = "dslabs")
## ?gapminder for more info on the variables in the dataset
gapminder <- gapminder %>% as_tibble


## ------------------------------------------------------------------------
gapminder <- gapminder %>% as_tibble()
gapminder %>% head(2)
head(gapminder, 2)
names(gapminder)


## ------------------------------------------------------------------------
naniar::vis_miss(gapminder)
naniar::gg_miss_var(gapminder)
naniar::gg_miss_case(gapminder)


## ------------------------------------------------------------------------
gapminder %>%
  dplyr::filter(year == 1960 | year == 2000) %>%
  dplyr::filter(continent == "Europe") %>%
  ggplot(aes(x = country,
         y = gdp)) +
  naniar::stat_miss_point() +
  coord_flip() +
  facet_wrap(~year)



## ------------------------------------------------------------------------
gapminder %>%
  dplyr::select(-c(country, region)) %>%
ggpairs()


## ------------------------------------------------------------------------
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point()


## ------------------------------------------------------------------------
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(alpha = 0.01)


## ------------------------------------------------------------------------
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = continent))



## ------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Africa") %>%
  ggplot(aes(x = year, y = population)) + ## why log10?
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


## ------------------------------------------------------------------------
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



## ------------------------------------------------------------------------

## pipe symbol 
reduce_data_plot <- gapminder %>% 
  filter(continent == "Africa"| continent == "Europe") %>%
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = continent), alpha = 0.2) 
  
reduce_data_plot


## ---- eval=FALSE---------------------------------------------------------
## reduce_data_plot <- gapminder %>%
##   filter(continent == "Africa" | continent == "Europe") %>%
##   ggplot(aes(x = fertility,
##              y = life_expectancy, colour = continent)) +
##   geom_point(alpha = 0.2) +
##   ## override the alpha setting for the points in the legend:
##   guides(colour = guide_legend(override.aes = list(alpha = 1)))


## ------------------------------------------------------------------------
## or e.g. show only two years and map a shape to continent
shape_plot <- gapminder %>% 
  dplyr::filter(continent == "Africa" | continent == "Europe",
         year == "1960" | year == "2010") %>%
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = as_factor(as.character(year)), 
                 shape = continent), 
             alpha = 0.7) +
  theme_bw()
shape_plot


## ------------------------------------------------------------------------
facets_plot <- gapminder %>% 
  dplyr::filter(continent == "Africa" | continent == "Europe",
         year == "1960" | year == "2010") %>%
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(aes(colour = continent), alpha = 0.5) +
  facet_wrap(~ year)

facets_plot


## ------------------------------------------------------------------------
library(ggrepel)

years <- c("1960", "1970", "1980", "1990", "2000", "2010")

summarize_plot <- gapminder %>% 
  dplyr::filter(year %in% years) %>%
  group_by(continent, year) %>%
  summarise(mean_life_expectancy = mean(life_expectancy),
            mean_fertility = mean(fertility)) %>%
  ggplot(aes(x = mean_fertility,
             y = mean_life_expectancy)) +
  geom_point(aes(colour = continent), alpha = 0.7) 

summarize_plot


## ------------------------------------------------------------------------
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
  geom_label_repel(aes(label=year), size = 2.5, box.padding = .5)
  
labels_plot


## ------------------------------------------------------------------------
## Model
lm <- gapminder %>% lm(formula = life_expectancy ~ fertility)

correlation <- cor.test(x = gapminder$fertility, y = gapminder$life_expectancy, method = "pearson")

# save predictions of the model in the new data frame 
# together with variable you want to plot against
predicted_df <- data.frame(gapminder_pred = predict(lm, gapminder), 
                           fertility = gapminder$fertility)



## ------------------------------------------------------------------------
model_plot <- gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(alpha = 0.03) +
  geom_line(data = predicted_df, aes(x = fertility, 
                                     y = gapminder_pred),
            colour = "darkred", size = 1)

model_plot


## ---- echo=FALSE---------------------------------------------------------
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



## ------------------------------------------------------------------------
gapminder %>% 
  ggplot(aes(x = fertility,
             y = life_expectancy)) +
  geom_point(alpha = 0.02) +
  geom_smooth(method = "lm") +
  stat_cor(method = "pearson", label.x = 2, label.y = 30) +
  theme_bw()


## ------------------------------------------------------------------------
africa <- gapminder %>%
  dplyr::filter(continent == "Africa")
  


## ------------------------------------------------------------------------
africa <- africa %>%
  mutate(welfare_index = (life_expectancy*gdp)/1000)



## ------------------------------------------------------------------------
africa %>%
  ggplot(aes(x = year, y = welfare_index)) +
  geom_line(aes(group = country, colour = country), show.legend = FALSE)


## ------------------------------------------------------------------------
africa %>%
  ggplot(aes(x = year, y = log10(welfare_index))) +
  geom_line(aes(group = country, colour = country), show.legend = FALSE)


## ------------------------------------------------------------------------
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


## ------------------------------------------------------------------------
continuous


## ------------------------------------------------------------------------
population_plot <- gapminder %>% 
  dplyr::group_by(continent, year) %>%
  dplyr::filter(year %in% years) %>%
  summarise(sum_population = sum(population)) %>% 
  ggplot(aes(x = year, 
             y = sum_population)) +
    geom_point(aes(colour = continent)) +
    geom_line(aes(group = continent,
                  colour = continent))


## ------------------------------------------------------------------------
population_plot


## ------------------------------------------------------------------------
ranking_plot <- gapminder %>%
  dplyr::filter(continent == "Europe",
                year == 2010) %>%
  ggplot(aes(x = reorder(as_factor(country), population),
             y = log10(population))) +
  geom_point() +
  ylab("log10(Population)") +
  xlab("Country") + 
  coord_flip() +
  geom_point(data = filter(gapminder %>%
  dplyr::filter(continent == "Europe",
                year == 2010), population >= 1e7), colour = "red")



## ------------------------------------------------------------------------
ranking_plot


## ------------------------------------------------------------------------
## without summarizing for countries
gapminder$continent %>% as_factor() %>% levels()
gapminder %>% 
  dplyr::filter(continent == "Americas" | continent == "Oceania") %>%
  ggplot(aes(x = year,
             y = life_expectancy)) +
  geom_line(aes(group = continent,
                colour = continent))


## ------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Americas" | continent == "Oceania") %>%
  ggplot(aes(x = year,
             y = life_expectancy)) +
  geom_point(aes(colour = country)) +
  theme(legend.position="none") +
  facet_wrap( ~ continent) +
  theme(legend.position="none") 
  


## ------------------------------------------------------------------------
gapminder$continent %>% as_factor() %>% levels()
gapminder %>% 
  dplyr::filter(continent == "Americas" | continent == "Oceania") %>%
  group_by(continent, year) %>%
  summarise(mean_life_expectancy = mean(life_expectancy)) %>%
  ggplot(aes(x = year,
             y = mean_life_expectancy)) +
  geom_line(aes(group = continent,
                colour = continent)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


## ------------------------------------------------------------------------

df <- gapminder %>% 
  dplyr::filter(continent == "Americas" | continent == "Oceania") %>%
  group_by(continent, year)

model <- aov(data = df, life_expectancy ~ continent * year)
anova(model)



## ------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  group_by(continent) %>%
  dplyr::filter(year %in% years) %>%
  ggplot(aes(x = year,
             y = infant_mortality)) +
  geom_point(aes(colour = country)) +
  theme(legend.position="none")
  


## ------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  dplyr::filter(year %in% years) %>%
    group_by(continent) %>%
  ggplot(aes(x = year,
             y = infant_mortality)) +
  geom_point(aes(colour = continent), position = "jitter") 
  


## ------------------------------------------------------------------------
gapminder %>% 
  dplyr::filter(continent == "Americas" |
                continent == "Africa") %>%
  dplyr::filter(year %in% years) %>%
  group_by(continent, year) %>%
  summarise(mean_infant_mortality = mean(infant_mortality, na.rm = TRUE)) %>% 
  ggplot(aes(x = year,
             y = mean_infant_mortality)) +
  geom_col(aes(fill = continent), position = "dodge") 
  


## ------------------------------------------------------------------------
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




## ------------------------------------------------------------------------
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



## ---- include=FALSE------------------------------------------------------
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

filter(gapminder, year%in%c(1962, 2013) & !is.na(group) &
         !is.na(fertility) & !is.na(life_expectancy)) %>%
  mutate(population_in_millions = population/10^6) %>%
  ggplot( aes(fertility, y=life_expectancy, col = group, size = population_in_millions)) +
  geom_point(alpha = 0.8) +
  guides(size=FALSE) +
  theme(plot.title = element_blank(), legend.title = element_blank()) +
  coord_cartesian(ylim = c(30, 85)) +
  xlab("Fertility rate (births per woman)") +
  ylab("Life Expectancy") +
  geom_text(aes(x=7, y=82, label=year), cex=12, color="grey") +
  facet_grid(. ~ year) +
  theme(strip.background = element_blank(),
        strip.text.x = element_blank(),
        strip.text.y = element_blank(),
   legend.position = "top")


## ------------------------------------------------------------------------
pub_plot


## ------------------------------------------------------------------------
heights_data <- read_csv(file = here::here("data",
                                           "heights_outliers.csv"))

heights_data


## ------------------------------------------------------------------------
summary_heights_data <- heights_data %>%
  group_by(sex, age) %>%
  summarise(mean_height = mean(height, na.rm = TRUE),
            min_height = min(height),
            max_height = max(height)) %>%
  arrange(desc(mean_height))

summary_heights_data[c(1:4),]


## ------------------------------------------------------------------------

heights_data %>%
  ggplot(aes(x = height)) +
  geom_histogram(aes(stat = "identity"), bins = 200)


## ------------------------------------------------------------------------
heights_data %>%
  ggplot(aes(y = log10(height))) +
  geom_boxplot()


## ------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height > 100)


## ------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(y = height)) +
  geom_boxplot()


## ------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(y = height, x = sex)) +
  geom_boxplot()



## ------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(height)) +
  geom_freqpoly(aes(y = ..density..))


## ------------------------------------------------------------------------
heights_data %>%
  dplyr::filter(height < 100) %>%
  ggplot(aes(height)) +
  geom_freqpoly(aes(y = ..density.., colour = sex))



## ------------------------------------------------------------------------
## a qqplot provides a visual aid to assess whether a distribution is approaching normality
source(file = here::here("code", "ggqq.R"))
height_data_outlier_removed <- heights_data %>%
  dplyr::filter(height < 100)
  gg_qq(height_data_outlier_removed$height) 
  
## formal statistical proof
shapiro.test(height_data_outlier_removed$height)


## ------------------------------------------------------------------------
males <- height_data_outlier_removed %>%
  dplyr::filter(sex == "male")

females <- height_data_outlier_removed %>%
  dplyr::filter(sex == "female")

shapiro.test(males$height)
shapiro.test(females$height)
## add shapiro for each sex

## we can do the same for age
shapiro.test(males$age)
shapiro.test(females$age)

