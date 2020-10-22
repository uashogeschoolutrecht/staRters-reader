## find large files and add them to .gitignore
library(tidyverse)

all_files <- list.files(recursive = TRUE, path = "./") %>%
  enframe() %>%
  mutate(size_Mb = file.size(value)/1000000)

big_files <- all_files %>%
  dplyr::filter(size_Mb > 99)

big_files

write_lines(big_files$value, path = ".gitignore", append = TRUE)
