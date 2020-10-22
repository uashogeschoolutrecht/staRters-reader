# Eric Koncina <mail@koncina.eu>; 01/09/2016

# Imports the tables from a graphpad prism xml file (*.pzfx) into a dataframe
# Works with simple tables (One way ANOVA)

library(xml2)
library(dplyr)
library(purrr)
library(readr)

get_prism_column <- function(c) {
  if (c %>% xml_find_all(".//d") %>% length == 0) return(NA)
  # Column defined but with no value
  # returning NULL will mess up map2_df
  c %>% xml_find_all(".//d") %>% xml_text %>%
    parse_number(locale = locale(decimal_mark = ","))
  # xml_double is not working with the prism file I used
  # cause prism seems to use (locale dependent?) commas...
}

get_prism_name <- function(c) {
  c %>% xml_find_all("./Title") %>% xml_text(trim = TRUE)
}

read_prism_table <- function(t) {
  t %>%
    xml_find_all("./YColumn") -> t
  map2_df(map(t,  get_prism_name), map(t, get_prism_column), data_frame) %>%
    set_names(c("key", "value"))
}
# 
# read_xml("example.pzfx") %>%
#   xml_ns_strip() %>% # We remove the namespace for easier handling...
#   xml_find_all("/GraphPadPrismFile/Table") -> tables
# 
# tables %>%
#   map(read_prism_table) %>%
#   set_names(get_prism_name(tables)) %>%
#   bind_rows(.id = "table") -> df