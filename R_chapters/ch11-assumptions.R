## ---- warning=FALSE, error=FALSE, message=FALSE---------------------------------------------------------
library(tidyverse)
library(AppliedPredictiveModeling)
library(tidyverse)
library(devtools)
library(pastecs)
library(car)
library(e1071)
library(pastecs)
library(caret)
# install_github("profandyfield/adventr")
# library(adventr)
# devtools::install_github("tidymodels/parsnip")
library(parsnip)
library(tidymodels)
library(recipes)
library(moderndive)
library(skimr)
library(gapminder)


## -------------------------------------------------------------------------------------------------------
set.seed(1234999)
normals <- rnorm(n = 100, mean = 0, sd = 1) %>%
  enframe()

## determine mean and sd of our simulated random normals (should approach 0 and 1 resp.)
mean(normals$value)
sd(normals$value)

## 
hist(normals$value)

## plot
normals %>%
ggplot(aes(x=value)) + 
  stat_function(fun = dnorm, colour = "red", size = 1) +
  xlim(c(-4, 4)) 

## resampling

sample_1 <- sample_n(normals, 100, replace = TRUE)
mean(sample_1$value)
sample_2 <- sample_n(normals, 100, replace = TRUE)
mean(sample_2$value)  

## homework:
## create a function that generates 1000 boostrapped samples of the mean form the 'normal$value' sample
## plot a histogram of the 1000 mean-estimates




## ---- include is FALSE----------------------------------------------------------------------------------
normals %>%
ggplot(aes(x=value)) + 
  stat_function(fun = dnorm, colour = "red", size = 1) +
  xlim(c(-4, 4)) +
  geom_vline(xintercept = mean(normals$value), colour = 'blue', linetype = 'dashed') +
  geom_vline(xintercept = sd(normals$value), colour = 'darkblue', linetype = 'dashed') +
  geom_vline(xintercept = -sd(normals$value), colour = 'darkblue', linetype = 'dashed')



## -------------------------------------------------------------------------------------------------------
ggplot(mtcars, aes(x = mpg)) +
stat_function(
fun = dnorm,
args = with(mtcars, c(mean = mean(mpg), sd = sd(mpg)))
) + scale_x_continuous("Miles per gallon")


## -------------------------------------------------------------------------------------------------------
ggplot(mtcars, aes(x = mpg)) +
  stat_function(
    fun = dnorm,
    args = with(mtcars, c(mean = mean(mpg), sd = sd(mpg)))) + 
  scale_x_continuous("Miles per gallon") +
  geom_histogram(aes(y=..density..),      
                   binwidth = 1,
                   colour = "red")

## or density
ggplot(mtcars, aes(x = mpg)) +
  stat_function(
    fun = dnorm,
    args = with(mtcars, c(mean = mean(mpg), sd = sd(mpg)))) + 
  scale_x_continuous("Miles per gallon") +
  geom_density(aes(y=..density..),      
                   binwidth = 1,
                   colour = "red")









## ---- include=FALSE-------------------------------------------------------------------------------------
data_students <- read.csv("https://userpage.fu-berlin.de/soga/200/2010_data_sets/students.csv")


## -------------------------------------------------------------------------------------------------------
names(data_students)


## ---- echo=FALSE----------------------------------------------------------------------------------------
## correlation between height and weight
data_students %>%
  ggplot(aes(x = height, y = weight)) +
  geom_point()

## correlation between weight and age
data_students %>%
  ggplot(aes(x = weight, y = age)) +
  geom_point()

## gender over weight and height
data_students %>%
  ggplot(aes(x = height, y = weight)) +
  geom_point(aes(colour = gender))

## data distributions of height
data_students %>%
  ggplot(aes(x = height)) +
  geom_density()

## data distributions of height; split by gender
data_students %>%
  ggplot(aes(x = height)) +
  geom_density(aes(colour = gender))




## -------------------------------------------------------------------------------------------------------

data_students %>%
ggplot(aes(x = height)) +
  stat_function(
    fun = dnorm,
    args = with(data_students, c(mean = mean(height), sd = sd(height)))) + 
  scale_x_continuous("Height") +
  geom_density(aes(y=..density..),      
                   binwidth = 1,
                   colour = "red") +
  ylab("Density")


## -------------------------------------------------------------------------------------------------------

data_males <- data_students %>%
  dplyr::filter(gender == "Male")

data_females <- data_students %>%
  dplyr::filter(gender == "Female")

data_students %>%
ggplot(aes(x = height)) +
  stat_function(
    fun = dnorm,
    args = with(data_males, c(mean = mean(height), sd = sd(height))),
    colour = "darkblue") +
  stat_function(
    fun = dnorm,
    args = with(data_females, c(mean = mean(height), sd = sd(height))),
    colour = "darkred") + 
  scale_x_continuous("Height") +
  geom_density(aes(colour = gender))


## -------------------------------------------------------------------------------------------------------
qqnorm(data_females$height, main = 'Q-Q plot for the height of female students')
qqline(data_females$height, col = 3, lwd = 2)


## -------------------------------------------------------------------------------------------------------
data_students %>%
  group_by(gender) %>%
  nest() -> data_nested_students

ind <- map_lgl(data_nested_students$data[[1]], is.numeric) 

## Females  
map(data_nested_students$data[[1]][, ind], shapiro.test) 

vector <- c(1:10)

shapiro.test(vector)

# H0 = Shapiro = Distributie is normaal verdeeld

# %>%
#   map(., broom::tidy) %>% dplyr::bind_rows() %>%
#     mutate(var = names(data_nested_students$data[[1]][ind]),
#            gender = data_nested_students$gender[1]) -> shapiros_female
# 
## Males
map(data_nested_students$data[[2]][, ind], shapiro.test) %>%
  map(., broom::tidy) %>% dplyr::bind_rows() %>%
    mutate(var = names(data_nested_students$data[[2]][ind]),
           gender = data_nested_students$gender[2]) -> shapiros_male

map(data_nested_students$data[[1]][, ind], shapiro.test) %>%
  map(., broom::tidy) %>% dplyr::bind_rows() %>%
    mutate(var = names(data_nested_students$data[[1]][ind]),
           gender = data_nested_students$gender[1]) -> shapiros_female



dplyr::bind_rows(shapiros_female, shapiros_male) %>%
  mutate(p.value = round(p.value, 6)) -> shapiros


## -------------------------------------------------------------------------------------------------------
shapiros %>%
  ggplot(aes(x = var, y = log10(p.value))) +
  geom_col(position = "dodge") +
  facet_wrap(~gender) +
  coord_flip()


## -------------------------------------------------------------------------------------------------------
data_students %>%
  group_by(gender) %>%
  count()


## -------------------------------------------------------------------------------------------------------
## distributions
data_students %>%
  ggplot(aes(x = salary)) +
  geom_density(aes(colour = gender))

## actual vs theoretical


## Age and salary, vs major
data_students %>%
  ggplot(aes(x = age, y = salary)) +
  facet_grid(gender ~ major) +
  geom_point()


qqnorm(data_females$salary, main = 'Q-Q plot for the salary of female students')
qqline(data_females$salary, col = 3, lwd = 2)


## -------------------------------------------------------------------------------------------------------
data_students %>%
  group_by(gender, major, age) %>%
  summarise(mean_salary = mean(salary, na.rm = TRUE)) %>%
  ggplot(aes(x = age, y = mean_salary)) +
  geom_point(aes(colour = gender)) +
  geom_smooth(aes(group = gender, colour = gender), se = FALSE, method = "lm") +
  facet_wrap(~ major)


## ---- solution, include=FALSE---------------------------------------------------------------------------
library(nlme)

## statistics for inference
## statistics for prediction

## linear model, anova
salary_model_1 <- lm(data = data_students, salary ~ gender * major) 
aov(salary_model_1) %>% summary

## equal variance for all groups

## model inspection
plot(salary_model_1)

## mixed effects model
salary_model_2 <- lme(data = data_students %>% na.omit(), 
                      salary ~ gender * major,
                        random = ~1 | semester)

anova(salary_model_2)
plot(salary_model_2)


## -------------------------------------------------------------------------------------------------------
dlf <- read_delim(file = here::here("data", 
                                   "DownloadFestival.dat"), 
                                   delim =  "\t", na = c("", " "))
dlf %>% head(3)


## -------------------------------------------------------------------------------------------------------
sum(is.na(dlf))
x <- summary(dlf)
min_maxs <- x[c(1, 6), c(3:5)] %>% unlist() %>% print()
naniar::vis_miss(dlf)


## -------------------------------------------------------------------------------------------------------
hist.outlier <- ggplot(dlf, aes(day1)) + 
  geom_histogram(aes(y=..density..), 
                 colour="black", 
                 fill="white") + 
  labs(x="Hygiene score on day 1", y = "Density") +
  theme(legend.position = "none")
hist.outlier


## -------------------------------------------------------------------------------------------------------
dlf_long <- dlf %>% 
  tidyr::gather(day1:day3, key = "days", value = "hygiene_score")
dlf_long


## ---- echo=FALSE----------------------------------------------------------------------------------------
hist.boxplot <- dlf_long %>%
  ggplot(aes(x = days, y = hygiene_score)) + 
  geom_boxplot(aes(group = days)) +
  geom_point(data = dplyr::filter(dlf_long, hygiene_score > 19), 
             colour = "darkred", size = 2.5) +
  labs(x="Hygiene score on day 1", y = "Hygiene Score") +
  theme(legend.position = "none") + 
  facet_wrap(~ gender)
hist.boxplot


## ---- include=FALSE-------------------------------------------------------------------------------------
dlf <- dlf %>%
  dplyr::filter(!day1 > 19)

dlf_long <- dlf_long %>%
  dplyr::filter(!hygiene_score > 19)


## ---- include=FALSE-------------------------------------------------------------------------------------
## Boxplots without outlier
hist.boxplot <- dlf %>%
  tidyr::gather(day1:day3, key = "days", value = "hygiene_score") %>%
  ggplot(aes(x = days, y = hygiene_score)) + 
  geom_boxplot(aes(group = days)) + 
  labs(x="Hygiene score on day 1", y = "Hygiene Score") +
  theme(legend.position = "none") + 
  facet_wrap(~ gender)
hist.boxplot


## ----include=FALSE--------------------------------------------------------------------------------------
### All data
### At this point it is wise to look at all the data
dlf_long %>%
  ggplot(aes(x = hygiene_score, y = ticknumb)) +
  geom_point(aes(colour = days)) +
  facet_wrap(~gender)

dlf_long %>%
  group_by(gender) %>%
  count()




## ---- include=FALSE-------------------------------------------------------------------------------------
### Distributions for hygiene scores on day 1, day 2 and day 3. Here we disregard the gender variable, assuming there is no difference in hygiene score between males and females (which could be a dangerous assumption). We will come back to this later.

dlf_long %>%
  ggplot(aes(x = hygiene_score)) +
  geom_density(aes(colour = days)) +
  facet_wrap(~days)


## -------------------------------------------------------------------------------------------------------
set.seed(123)
## add normal distribution to the data (based on observed mean and sd per day)
dlf_norm <- dlf %>%
  mutate(
    norm_day_1 = rnorm(
      mean = mean(dlf$day1, na.rm = TRUE), 
      n = nrow(dlf), 
      sd = sd(dlf$day1, na.rm = TRUE)),
    norm_day_2 = rnorm(
      mean = mean(dlf$day2, na.rm = TRUE), 
      n = nrow(dlf), 
      sd = sd(dlf$day2, na.rm = TRUE)),
    norm_day_3 = rnorm(
      mean = mean(dlf$day3, na.rm = TRUE), 
      n = nrow(dlf), 
      sd = sd(dlf$day3, na.rm = TRUE))) %>%
  dplyr::select(gender, norm_day_1:norm_day_3) %>%
  tidyr::gather(norm_day_1:norm_day_3, 
                key = "days", 
                value = "norm_hygiene_score")
  

## add to plot
dlf_long %>%
  dplyr::filter(!hygiene_score > 19) %>%
  ggplot(aes(x = hygiene_score)) +
  geom_density(aes(colour = days)) +
  geom_density(data = dlf_norm, aes(x = norm_hygiene_score,
                                    colour = days)) +
  facet_wrap(~days)
  


## -------------------------------------------------------------------------------------------------------
## see the file ggqq.R for the function definition
source(file = here::here("code", "ggqq.R"))
gg_qq_1 <- gg_qq(dlf$day1)
gg_qq_1


## -------------------------------------------------------------------------------------------------------
gg_qq_2 <- gg_qq(dlf$day2)
gg_qq_2


## -------------------------------------------------------------------------------------------------------
gg_qq(dlf$day3)


## -------------------------------------------------------------------------------------------------------
library(pastecs)
round(stat.desc(dlf[, c("day1", "day2", "day3")], basic = FALSE, norm = TRUE), digits = 3)

## or 
descriptives <- map(dlf, stat.desc, basic = FALSE, norm = TRUE) 



## ---- eval=FALSE----------------------------------------------------------------------------------------
## leveneTest(dlf$day1, dlf$day2)
## leveneTest(data = dlf_long, hygiene_score ~ days)
## # leveneTest(data = dlf_long, hygiene_score ~ days * gender)
## 
## dlf_long %>%
##   ggplot(aes(x = hygiene_score, y = ticknumb)) +
##   geom_point(aes(colour = days)) +
##   facet_wrap(days ~ gender, nrow = 3)


## ---- include=FALSE-------------------------------------------------------------------------------------
library(dlookr)

## using normality() from `{dlookr}`
dlf %>%
  select(-ticknumb) %>%
  normality() %>%
  dplyr::mutate(p_value = round(p_value, digits = 4)) %>%
  arrange(desc(p_value))

## using plot_normality from `{dlookr}`
dlf_long %>%
  group_by(days) %>%
  select(-ticknumb) %>%
  plot_normality()



## ---- include=FALSE-------------------------------------------------------------------------------------
dlf_long_new <- dlf_long %>%
  mutate(hygiene_score_sqrt = sqrt(hygiene_score))
  
dlf_long_new %>% 
  select(-ticknumb) %>%
  group_by(days) %>%
  normality() %>%
  dplyr::mutate(p_value = round(p_value, digits = 4)) %>%
  arrange(desc(p_value))

dlf_long %>%
  mutate(hygiene_score_sqrt = sqrt(hygiene_score)) %>%
  select(days, hygiene_score_sqrt, -ticknumb) %>%
  group_by(days) %>%
  plot_normality()


## -------------------------------------------------------------------------------------------------------
lm_festival <- lm(data = dlf_long_new, hygiene_score_sqrt ~ gender + days)

summary(lm_festival)
anova(lm_festival) 


## -------------------------------------------------------------------------------------------------------
lm_festival <- lm(data = dlf_long_new, hygiene_score_sqrt ~ gender * days)
anova(lm_festival)


## -------------------------------------------------------------------------------------------------------
library(agricolae)
library(emmeans)

emmeans::emmeans(lm_festival, ~days)
emmeans::emmeans(lm_festival, ~gender)

agricolae::LSD.test(lm_festival, "days", console = TRUE, p.adj = "bonferroni")
agricolae::LSD.test(lm_festival, "gender", console = TRUE, p.adj = "bonferroni")



## -------------------------------------------------------------------------------------------------------
tibble(resids = lm_festival$residuals,
          fitted = lm_festival$fitted.values) %>%
  ggplot(aes(x = fitted,
             y = resids)) +
  geom_point(shape = 1, alpha = 0.4) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "red", size = 1)

plot(lm_festival)


