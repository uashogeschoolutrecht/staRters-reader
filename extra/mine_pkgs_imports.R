## Problem: What R-package installed on the
## system has the most dependencies (as defined in the Imports' field)

## Plan

# Use google to: get the dependencies for R packages

# 1) Which packages are installed currently on the system
# 2) Look at Imports info
# 3) Get amount of packages in Imports
# 4) Make comparison (sort from high to low)
# 5) look at first row
# 6) Make a graph

# ad1)
library(tidyverse)


pkgs <- installed.packages() %>%
  as_tibble() %>%
  dplyr::select(Package,
                Imports) %>%                                                       mutate(splitted = map(.x = Imports,
                        .f = str_split, pattern = ",")) %>%
  mutate(split_unlist = map(.x = splitted,
                            .f = unlist)) %>%
  mutate(n_deps = map(split_unlist,
                      length) %>% unlist) %>%
  dplyr::filter(n_deps > 10) %>%
  ggplot(aes(x = reorder(as_factor(Package), n_deps), y = n_deps)) +
  geom_point() +
  coord_flip()

pkgs

# pkgs$n_deps
