# Code for quick exploration of
# https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-05-26
# Video at https://youtu.be/kHFmtKCI_F4

# CC-BY NC 4.0 

library(tidyverse)

# cocktails <- readr::read_csv("boston_cocktails.csv")
cocktails <- readr::read_csv(
  "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/boston_cocktails.csv",
  col_names = c(LETTERS[1:6]),
  cols(
   A = col_character(),
    B = col_factor(),
    C = col_integer(),
    D = col_integer(),
     E = ingredient = col_character(),
    F = measure = col_character()
   )

cocktails$category %>% levels()
cocktails$name %>% unique()



# Are name and row_id equivalent? -----------------------------------------

cocktails %>% count(name)
cocktails %>% count(row_id)

cocktails %>%
  group_by(name) %>%
  summarise(ids = n_distinct(row_id)) %>%
  filter(ids > 1)
# Yes, they are


# How many ingredients are in each cocktail? ------------------------------
cocktails %>%
  count(name) %>%
  count(n)

# nrow(cocktails)


# These 1-ingredient cocktails suggest that non-alcoholic ingredients
# are not included
cocktails %>%
  group_by(name) %>%
  filter(n() == 1)

cocktails %>%
  group_by(name) %>%
  filter(n() == 2)

# How big is each cocktail? -----------------------------------------------

cocktails %>% count(measure, sort = TRUE)

non_spirit <- c("Chilled Champagne", "Water", "Orange Juice", "Cranberry Juice", "Light Cream (if desired)", "Fresh orange juice", "Orange juice")

# Have removed all cocktails with ounces of bitters - that is most
# likely a data entry error (it certainly doesn't give me much confidence
# in the quality of this data)

sizes <- cocktails %>%
  filter(str_detect(measure, "oz")) %>%
  filter(!str_detect(ingredient, fixed("bitters", ignore_case = TRUE))) %>%
  filter(!ingredient %in% non_spirit) %>%
  mutate(oz = str_replace(measure, " oz", "")) %>%
  mutate(oz = str_replace(oz, " ?1/2", ".5")) %>%
  mutate(oz = str_replace(oz, " ?1/4", ".25")) %>%
  mutate(oz = str_replace(oz, " ? ?3/4", ".75")) %>%
  mutate(oz = str_replace(oz, " ?1/3", ".33")) %>%
  mutate(oz = str_replace(oz, " ?2/3", ".66")) %>%
  mutate(oz = as.numeric(oz))


sizes

string <- c("This is a string", "Not a nice thing!")

str_view_all(string = string, pattern = "(^This.*$|thing!$)")

janitor::clean_names 


filter(sizes, oz > 3)
filter(sizes, oz > 10)

total_size <- sizes %>% group_by(name) %>% summarise(n = n(), oz = sum(oz))

total_size %>% filter(oz > 20)

total_size %>%
  filter(oz < 20) %>%
  ggplot(aes(oz)) +
  geom_histogram(binwidth = 0.5)

total_size %>%
  filter(oz > 6) %>%
  semi_join(cocktails, ., by = "name") %>%
  View()

cocktails %>%
  filter(str_detect(ingredient, "bitters"))

sizes %>%
  group_by(ingredient) %>%
  summarise(n = n(), oz = mean(oz)) %>%
  filter(n > 5) %>%
  arrange(desc(oz), sort = TRUE)


# What are the primary ingredients ----------------------------------------

cocktails <- cocktails %>% mutate(ingredient = tolower(ingredient))

cocktails %>%
  count(ingredient = tolower(ingredient), sort = TRUE) %>%
  head(20)

standard_ingredients <- tribble(
  ~ ingredient,        ~ standard_name,
  "fresh lemon juice", "lemon juice",
  "juice of a lemon",  "lemon juice",
  "fresh lime juice",  "lime juice",
  "juice of a lime",   "lime juice",
  "bitters",           "angostura bitters"
)

ingredient_changes <- cocktails %>%
  select(name, ingredient_number, ingredient) %>%
  right_join(standard_ingredients) %>%
  select(name, ingredient_number, ingredient = standard_name)

cocktails %>%
  rows_update(ingredient_changes, by = c("name", "ingredient_number")) %>%
  count(ingredient, sort = TRUE) %>%
  head(20)


cocktails_sample <- sample_n(cocktails, 100)
cocktails_sample <- sample_frac(cocktails, 0.1)


