## ---- root_1, include=FALSE----------------------------------------------
## defines the root of the project for later use
require("rprojroot") || utils::install.packages("rprojroot")
library(rprojroot)
root <- find_root_file(criterion = is_rstudio_project)


## ---- knitr_setup, warning=FALSE, error=FALSE, message=FALSE, include=FALSE----
## setting knitr options
if (!require("knitr")) utils::install.packages("knitr")
library(knitr)

knitr::opts_chunk$set(echo = TRUE, warning = FALSE, error = FALSE, message = FALSE, fig.width = 3, fig.height = 3)
knitr::opts_knit$set(root.dir = root)


## ------------------------------------------------------------------------
library(ggplot2)
library(gapminder)
library(gganimate)
library(gifski)
library(tidyverse)

## setting them to black and white for all ggplots to come
theme_set(theme_bw())


## ------------------------------------------------------------------------

gapminder_animation <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~ continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) + ## regulation the actual layers for the animation
  ease_aes('linear')

gapminder_animation
## ------------------------------------------------------------------------
# library(av)
# p <- ggplot(airquality, 
#             aes(x = Day, 
#                 y = Temp)) + 
#   geom_line(size = 2, colour = 'steelblue') + 
#   transition_states(state = Month, 
#                     transition_length = 4, 
#                     state_length = 2) + 
#   shadow_mark(size = 0.3, colour = 'lightgrey')
# animate(p, renderer = av_renderer())
# 
