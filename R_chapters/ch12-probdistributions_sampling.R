## ---- warning=FALSE, error=FALSE, message=FALSE---------------------------------------------------------
library(tidyverse)


## -------------------------------------------------------------------------------------------------------
data_students <- read.csv("https://userpage.fu-berlin.de/soga/200/2010_data_sets/students.csv") %>%
  as_tibble()
data_students


## -------------------------------------------------------------------------------------------------------
## relationship between weight, height and gender
data_students %>%
  ggplot(aes(x = height, y = weight)) +
  geom_point(aes(colour = gender), alpha = 0.2)

## distribution of weight
data_students %>%
  ggplot(aes(x = weight)) +
  geom_histogram(aes(fill = gender), bins = 70)

## distribution of height
data_students %>%
  ggplot(aes(x = height)) +
  geom_histogram(aes(fill = gender), bins = 70)

## missingness




## ---- include=FALSE, results='hide'---------------------------------------------------------------------
## a)
height_values <- data_students$height
degrees_freedom <- length(height_values)-1
sum_of_squares <- (height_values - mean(height_values))^2 %>% sum() 
sd = sqrt(sum_of_squares / degrees_freedom) 
sd

## b
mean_height <- mean(height_values)

## c
sd_height <- sd(height_values)



## -------------------------------------------------------------------------------------------------------
females <- data_students %>%
  dplyr::filter(gender == "Female") %>%
  as_tibble()

females

mean_height_f <- mean(females$height)
sd_height_f <- sd(females$height)
height_z <- (females$height - mean_height_f)/sd_height_f
height_z %>% hist(main = "Z-transformed, female height")



## -------------------------------------------------------------------------------------------------------
x <- 168 # height in cm (that we want the probability for)
x_z <- (x - mean_height_f)/sd_height_f # z-transformation
pnorm(x_z) %>% round(2)



## -------------------------------------------------------------------------------------------------------
x <- 168 # height in cm 
pnorm(x, 
      mean = mean_height_f, 
      sd = sd_height_f, 
      lower.tail = TRUE, log.p = FALSE
      ) %>%
  round(3)



## -------------------------------------------------------------------------------------------------------

z_prob <- ggplot(females, aes(x = height_z)) +
stat_function(
fun = dnorm,
args = with(females, c(mean = mean(height_z), sd = sd(height_z)))
) + stat_function(
  args = with(females, c(mean = mean(height_z), sd = sd(height_z))),
    fun = dnorm,
    geom = "area",
    fill = "steelblue",
    alpha = .5,
  xlim = c(-3.5, 0.55)) +
  ggtitle("P(z =< 0.55") +
  xlab("Z-transformed height") +
  ylab(NULL) +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())


real_prob <- ggplot(females, aes(x = height)) +
stat_function(
fun = dnorm,
args = with(females, c(mean = mean(height), sd = sd(height)))
) + stat_function(
  args = with(females, c(mean = mean(height), sd = sd(height))),
    fun = dnorm,
    geom = "area",
    fill = "steelblue",
    alpha = .5,
  xlim  = c(135, 168)) +
  ggtitle("P x =< 168 cm") +
  xlab("Height (cm)") +
  ylab(NULL) +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

cowplot::plot_grid(z_prob, real_prob)



## -------------------------------------------------------------------------------------------------------
# set.seed() is for reproducibility
set.seed(1234)
# define opulation and put in a dataframe
population <- rnorm(mean = 24, sd = 7.9, n = 5961) %>%
  enframe()

## see a fast picture of how the population distribution looks like (it should )
## normally this would be information we do NOT have (hence, we need to sample the population to get an estimate of this distribution)
population %>%
  ggplot(aes(x = ))

## what is the mean?
mean(population$value)

## define the sample-sized that we want to draw from the population
no_samples <- c(5, 10, 100, 500, length(population$value))

## draw random samples of size `no_samples` from the population
## we construct a loop by using map from the purrr package
samples <- map(
  .x = no_samples,
  .f = sample_n,
  tbl = population,
  replace = FALSE
)

## function to plot the draws from the population
plot_bootstrap <- function(bootstrap_tbl, mu, size = 1){

  bootstrap_tbl %>%
    ggplot(aes(x = value)) +
    geom_histogram() +
 #   xlim(c(1,100)) +
    geom_vline(xintercept = mu, 
               size = 1, 
               colour = "red", 
               linetype = "dashed")
  
  }


map(
  .x = samples,
  .f = plot_bootstrap,
  mu = mean(population$value)
)




## -------------------------------------------------------------------------------------------------------
source(
  here::here("R", "these_boots_are_made_for.R"))

bootstrap(x = population$value,
          n = 50,
          iter = 10,
          as_tbl = TRUE,
          mode = "raw") %>%
  tidyr::pivot_longer(
    cols = c(V1:V10), names_to = "boot", values_to = "value" 
  ) %>%
  mutate(iter = rep(1:10, times = 50)) -> boots_50 

boots_50 %>%
  ggplot(aes(x = value)) +
  geom_histogram() +
  facet_wrap(~iter, ncol = 2) +
  ggtitle("Sampled values (n=50) of the 10 boots")



## -------------------------------------------------------------------------------------------------------
source(
  here::here(
    "R",
    "these_boots_are_made_for.R"
  )
)

## run my self-written bootstrap function, this function takes a number of arguments to tune your bootstraps, you can get mean, median sd or raw (the actual sampled values) for  bootstrap
## look at the source code here: ".R/these_boots_are_made_for.R"
## we use map to loop over the predifined list of bootstrap iterations (repeats of sampling 30 samples from our simulated population) 
set.seed(1234)


bootstraps <- map_df(
  .x = no_samples, ## we use map to loop over the different sample sizes
  .f = bootstrap,
  x = population$value,
  iter = 1000, ## usually we run 1000 bootstraps 
  mode = "mean", ## the resampling statistic to be calculated after the bootstrapping
  as_tbl = TRUE
)

bootstraps_df <- bootstraps %>%
  mutate(sample_size = rep(no_samples, each = 1000))



## -------------------------------------------------------------------------------------------------------
mu <- mean(population$value)
## in one plot
bootstraps_df %>%
  ggplot(aes(x = value)) +
  geom_histogram(bins = 100) +
  facet_wrap(~sample_size, ncol = 2) +
  ggtitle("Sampled values bootstrapping experiment") +
    geom_vline(xintercept = mu, 
               size = 0.5, 
               colour = "red", 
               linetype = "dashed")



## -------------------------------------------------------------------------------------------------------
# install.packages("Rmisc")
library(Rmisc)

bootstraps_list <- map(
  .x = no_samples, ## we use map to loop over the different sample sizes
  .f = bootstrap,
  x = population$value,
  iter = 1000, ## usually we run 1000 bootstraps 
  mode = "mean", ## the resampling statistic to be calculated after the bootstrapping
  as_tbl = FALSE
)


margins_of_error <- map_df(
  .x = bootstraps_list,
  .f = CI
) %>%
  mutate(sample_size = no_samples) %>%
  select(
    sample_size,
    lower,
    mean,
    upper
  )

margins_of_error

## Of course we can put them in a plot
#margins_of_error %>%
#  ggplot(aes(x = mean)) 



