## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, fig.width = 5, fig.height = 3)


## ---- root_1, include=FALSE----------------------------------------------
## defines the root of the project for later use
require("rprojroot") || utils::install.packages("rprojroot")
library(rprojroot)
root <- find_root_file(criterion = is_rstudio_project)


## ---- echo=FALSE, fig.align='left'---------------------------------------
path_to_image <- file.path(root, "images", "data-science.png")
knitr::include_graphics(path_to_image, dpi = 60)


## ---- packages, message = FALSE------------------------------------------
library(tidyverse)


## ------------------------------------------------------------------------
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))


## ------------------------------------------------------------------------
diamonds %>% 
  count(cut)


## ------------------------------------------------------------------------
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.05)
## we already saw what changing the binwidth does


## ------------------------------------------------------------------------
diamonds %>% 
  count(cut_width(carat, 0.05))


## ------------------------------------------------------------------------
smaller <- diamonds %>% 
  filter(carat < 3)
  
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)


## ------------------------------------------------------------------------
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)


## ------------------------------------------------------------------------
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)


## ------------------------------------------------------------------------
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)


## ------------------------------------------------------------------------
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)


## ------------------------------------------------------------------------
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))


## ---- include = FALSE----------------------------------------------------
old <- options(tibble.print_max = 10, tibble.print_min = 10)


## ------------------------------------------------------------------------
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  arrange(y)
unusual


## ---- eval = FALSE-------------------------------------------------------
## diamonds2 <- diamonds %>%
##   filter(between(y, 3, 20))


## ------------------------------------------------------------------------
  diamonds2 <- diamonds %>% 
      mutate(y = ifelse(y < 3 | y > 20, NA, y))


## ---- dev = "png", fig.height=2, fig.width=2-----------------------------
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()


## ---- echo=TRUE----------------------------------------------------------
nycflights13::flights %>% 
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100,
         sched_min = sched_dep_time %% 100,
         sched_dep_time = sched_hour + sched_min / 60) %>%
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)


## ------------------------------------------------------------------------
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)


## ------------------------------------------------------------------------
ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))


## ------------------------------------------------------------------------
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)


## ---- echo = FALSE-------------------------------------------------------
path_to_image <- file.path(root, "images", "EDA-boxplot.png")
knitr::include_graphics(path = path_to_image, dpi = 250)


## ----fig.height = 3------------------------------------------------------
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()


## ------------------------------------------------------------------------
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()


## ----fig.height = 3------------------------------------------------------
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), 
                             y = hwy)) + xlab("Class")


## ------------------------------------------------------------------------
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip() + xlab("Class")


## ------------------------------------------------------------------------
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))


## ---- dev = "png"--------------------------------------------------------
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))


## ---- dev = "png"--------------------------------------------------------
ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 3 / 100) +
  geom_smooth(aes(x = carat, y = price), method = "lm", fullrange = FALSE )


## ------------------------------------------------------------------------
# install.packages("hexbin")
ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))


## ------------------------------------------------------------------------
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))


## ------------------------------------------------------------------------
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1))) +
  geom_smooth(method = "auto")



## ------------------------------------------------------------------------
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

