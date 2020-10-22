# Data Wrangling {#wrangling}

## Packages

```r
library(tidyverse)
library(dslabs)
```

## Citations
To get the citations for the packages used in this chapter.

```r
citation(package = "tidyverse")
citation(package = "dplyr")
```

## Case Data

 * Pertussis outbreaks from The World Health Organization
 * http://data.euro.who.int/cisid/?TabID=463987
 * http://ecdc.europa.eu/sites/portal/files/documents/Pertussis%20AER.pdf
 * The data used in this presentation has been constructed from the interactive database tool hosted at: http://data.euro.who.int/cisid/ 
 * A selection was made for all available countries and all available years, for the number of cases reported to the WHO for Whooping Cough - pertussis infections
 * The file is avaialble in `./data/CISID_pertussis_10082018.csv`
 * The values included here in the dataset are the total reported cases, per country per year
 * At the start of the file there are remarks and metadata indicated by `#`
 * Missing values are indicated with an empty string

Open the file to inspect. The delimeter is `,` and you should see the comments at the start of the file. 

### Read data {-}

```r
pertussis_data <- read_csv(
  file = here::here( 
                  "data", 
                  "CISID_pertussis_10082018.csv"),
                           comment = "#", 
                           na = c("", " ")
  )
```

```
## Warning: Missing column names filled in: 'X1' [1], 'X2' [2]
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   .default = col_double(),
##   X2 = col_character(),
##   `1980` = col_logical(),
##   `1981` = col_logical(),
##   `1982` = col_logical(),
##   `1983` = col_logical(),
##   `1984` = col_logical(),
##   `1985` = col_logical(),
##   `1986` = col_logical(),
##   `1987` = col_logical(),
##   `1988` = col_logical(),
##   `1989` = col_logical(),
##   `2014` = col_logical(),
##   `2015` = col_logical(),
##   `2016` = col_logical(),
##   `2017` = col_logical(),
##   `2018` = col_logical()
## )
## i Use `spec()` for the full column specifications.
```

```
## Warning: 1 parsing failure.
## row col   expected    actual                                                                     file
##  55  -- 41 columns 1 columns 'C:/Users/mteunis/workspaces/staRters/data/CISID_pertussis_10082018.csv'
```

### Inspect data {-}

```r
pertussis_data
```

```
## # A tibble: 55 x 41
##       X1 X2    `1980` `1981` `1982` `1983` `1984` `1985` `1986` `1987` `1988`
##    <dbl> <chr> <lgl>  <lgl>  <lgl>  <lgl>  <lgl>  <lgl>  <lgl>  <lgl>  <lgl> 
##  1     2 Alba~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  2     5 Ando~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  3    10 Arme~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  4    13 Aust~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  5    14 Azer~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  6    19 Bela~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  7    20 Belg~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  8    26 Bosn~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  9    31 Bulg~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
## 10    51 Croa~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
## # ... with 45 more rows, and 30 more variables: `1989` <lgl>, `1990` <dbl>,
## #   `1991` <dbl>, `1992` <dbl>, `1993` <dbl>, `1994` <dbl>, `1995` <dbl>,
## #   `1996` <dbl>, `1997` <dbl>, `1998` <dbl>, `1999` <dbl>, `2000` <dbl>,
## #   `2001` <dbl>, `2002` <dbl>, `2003` <dbl>, `2004` <dbl>, `2005` <dbl>,
## #   `2006` <dbl>, `2007` <dbl>, `2008` <dbl>, `2009` <dbl>, `2010` <dbl>,
## #   `2011` <dbl>, `2012` <dbl>, `2013` <dbl>, `2014` <lgl>, `2015` <lgl>,
## #   `2016` <lgl>, `2017` <lgl>, `2018` <lgl>
```

```r
names(pertussis_data)
```

```
##  [1] "X1"   "X2"   "1980" "1981" "1982" "1983" "1984" "1985" "1986" "1987"
## [11] "1988" "1989" "1990" "1991" "1992" "1993" "1994" "1995" "1996" "1997"
## [21] "1998" "1999" "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007"
## [31] "2008" "2009" "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017"
## [41] "2018"
```

### Prepare the data with `{tidyr}` and `{dplyr}` {-}
The data will be prepared for Exploratory Data Analysis using two core packages of the tidyverse. `{tidyr}` is for reshaping data, `{dplyr}` is for wrangling data.

### Characteristics of the pertussis dataset {-}

- The first few lines of the file have comments indicated with `#`
- There are 53 countries in the dataset
- There is no data for the years 1980-1989 and 2014-2018
- The data is not in `tidy` format
- Missing values are indicated with __empty cells__
- It is not a good idea to have a column name starting with a digit; why?


```r
pertussis_data
```

```
## # A tibble: 55 x 41
##       X1 X2    `1980` `1981` `1982` `1983` `1984` `1985` `1986` `1987` `1988`
##    <dbl> <chr> <lgl>  <lgl>  <lgl>  <lgl>  <lgl>  <lgl>  <lgl>  <lgl>  <lgl> 
##  1     2 Alba~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  2     5 Ando~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  3    10 Arme~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  4    13 Aust~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  5    14 Azer~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  6    19 Bela~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  7    20 Belg~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  8    26 Bosn~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
##  9    31 Bulg~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
## 10    51 Croa~ NA     NA     NA     NA     NA     NA     NA     NA     NA    
## # ... with 45 more rows, and 30 more variables: `1989` <lgl>, `1990` <dbl>,
## #   `1991` <dbl>, `1992` <dbl>, `1993` <dbl>, `1994` <dbl>, `1995` <dbl>,
## #   `1996` <dbl>, `1997` <dbl>, `1998` <dbl>, `1999` <dbl>, `2000` <dbl>,
## #   `2001` <dbl>, `2002` <dbl>, `2003` <dbl>, `2004` <dbl>, `2005` <dbl>,
## #   `2006` <dbl>, `2007` <dbl>, `2008` <dbl>, `2009` <dbl>, `2010` <dbl>,
## #   `2011` <dbl>, `2012` <dbl>, `2013` <dbl>, `2014` <lgl>, `2015` <lgl>,
## #   `2016` <lgl>, `2017` <lgl>, `2018` <lgl>
```

**Discuss the output with you neighbour**

Try solving the questions:

 - Are the rows observations?
 - Are the columns variables?
 - Is there a single value in each cell?

## Tidy data 
To tidy the pertussis data we need to `gather` the `year` columns. We create a long formatted dataframe containing all the years in one column, all the `annual_pertussis_cases` in another, and all the countries in a seperate column. Each combination will be repated over the new columns automatically.


```r
## try the code below, why does it fail?
pertussis_data_tidy <- pertussis_data %>% 
  gather(1980:2018, key = "year", value = "annual_pertussis_cases")
```

To reference names that contain 'digits' or other 'special characters'

``` ` ``` 


```r
pertussis_data_tidy <- pertussis_data %>% 
  gather(`1980`:`2018`, key = "year", 
                        value = "annual_pertussis_cases") %>%
  mutate(annual_pertussis_cases = as.numeric(annual_pertussis_cases
                                             ))
pertussis_data_tidy
```

```
## # A tibble: 2,145 x 4
##       X1 X2                     year  annual_pertussis_cases
##    <dbl> <chr>                  <chr>                  <dbl>
##  1     2 Albania                1980                      NA
##  2     5 Andorra                1980                      NA
##  3    10 Armenia                1980                      NA
##  4    13 Austria                1980                      NA
##  5    14 Azerbaijan             1980                      NA
##  6    19 Belarus                1980                      NA
##  7    20 Belgium                1980                      NA
##  8    26 Bosnia and Herzegovina 1980                      NA
##  9    31 Bulgaria               1980                      NA
## 10    51 Croatia                1980                      NA
## # ... with 2,135 more rows
```

## The pipe or "%>%"
<img src="C:/Users/mteunis/workspaces/staRters/images/pipe.png" width="348" style="display: block; margin: auto 0 auto auto;" />

### Pipes {-}

 - The pipe, `%>%`, comes from the __magrittr__ package by Stefan Milton Bache
 - Load it explicitly:


```r
library(magrittr)
```

### Using the pipe (`%>%`) {-}

No pipe:

`variable_new <- do_something(variable_old)`

Pipe:

`variable_new <- variable_old %>% 
  do_something(.)`

or the same:

`variable_new <- variable_old %>% 
  do_something()`

The `.` (dot) is a placeholder for the 'old' variable. If you need to explicitely refer to something inside `variable_old` e.g. a column in dataframe you can use `.$colum_name` 

## The `{dplyr}` package in detail

_Subsetting, filtering, selecting, summarizing, sorting data(frames)_

### the {dplyr} package {-}
The dplyr package makes these steps fast and easy:

* dplyr simplifies how you can think about common data manipulation tasks.
* Simple "verbs", functions that correspond to the most common data manipulation tasks, to help you translate those thoughts into code.
* It uses efficient data storage backends, so you spend less time waiting for the computer.

### Data bases can be connected to dplyr {-}

 * Besides in-memory data frames
 * {dplyr} also connects to out-of-memory, remote databases. 
 * By translating your R code into the appropriate SQL
 * Allows you to work with both types of data using the same set of tools.

__dplyr can work with data frames as is, but if you're dealing with large data, it's worthwhile to convert them to a `tbl_df`: this is a wrapper around a data frame that won't accidentally print a lot of data to the screen.__

### Verbs {-}

`{dplyr}` aims to provide a function for each basic verb of data manipulation:

* `select()` (and `rename()`)
* `left_join()` (`full_join()`, `anti_join()`, `right_join()`)
* `filter()` (and `slice()`)
* `arrange()`
* `distinct()`
* `mutate()` (and `transmute()`)
* `summarise()`
* `sample_n()` (and `sample_frac()`)


#### `dplyr::rename()` & `dplyr::select()` {-}
For Renaming variables (`rename()`)

```r
names(pertussis_data_tidy)
```

```
## [1] "X1"                     "X2"                     "year"                  
## [4] "annual_pertussis_cases"
```

```r
## we can `rename()` a variable and `select()` variables
pertussis_data_tidy <- pertussis_data_tidy %>%
  dplyr::rename(some_strange_index = X1,
       country = X2)

pertussis_data_tidy %>% head(2)
```

```
## # A tibble: 2 x 4
##   some_strange_index country year  annual_pertussis_cases
##                <dbl> <chr>   <chr>                  <dbl>
## 1                  2 Albania 1980                      NA
## 2                  5 Andorra 1980                      NA
```

Dropping the column "some_strange_index (`select()`)

```r
pertussis_data_tidy <- pertussis_data_tidy %>%
  dplyr::select(country,
          year,
          annual_pertussis_cases)

pertussis_data_tidy %>% head(2)
```

```
## # A tibble: 2 x 3
##   country year  annual_pertussis_cases
##   <chr>   <chr>                  <dbl>
## 1 Albania 1980                      NA
## 2 Andorra 1980                      NA
```

Using `-` to drop specific column(s) will also work

```r
only_cases <- pertussis_data_tidy %>%
  dplyr::select(-c(country, year))

pertussis_data_tidy %>% head(2)





## When selecting multiple columns, construct a vector with `c()`
## like select(-c(columns_1, columns_2, column_3))
```

#### -- INTERMEZZO -- Creating a joined table {-}
Before we start playing with the other `{dplyr}` verbs I would like for  you to have a more complex dataset to practice with. Here we create one joining the `gapminder` and our `pertussis` data.

## Join pertussis with gapminder data
Here we join the pertussis data with the `gapminder` data though an `inner_join()`. `{dplyr}` has many join function, which we will not go into detail here. For more information and a tutorial see:
http://stat545.com/bit001_dplyr-cheatsheet.html


```r
data("gapminder", package = "dslabs")
gapminder <- gapminder %>% as_tibble()
```

#### Using `inner_join()` from `{dplyr}` {-}
When joining tables you need at least one shared variable, that has the same name in all tables you want to join. We call this variable (or variables) the (primary) `key`s. Here we use `country` and `year` as key to join only those observations that are fully shared for both `key`s in both datasets (`inner_join`) 


```r
# pertussis_data_tidy
# gapminder
gapminder$year <- as.character(gapminder$year)

join <-   dplyr::inner_join (gapminder, pertussis_data_tidy, by = c("country", "year")) %>%
  na.omit()
join
```

```
## # A tibble: 861 x 10
##    country year  infant_mortality life_expectancy fertility population     gdp
##    <chr>   <chr>            <dbl>           <dbl>     <dbl>      <dbl>   <dbl>
##  1 Albania 1990              35.1            73.3      2.97    3281453 3.22e 9
##  2 Armenia 1990              42.5            70.1      2.54    3544695 2.82e 9
##  3 Austria 1990               8              75.7      1.46    7706571 1.47e11
##  4 Azerba~ 1990              75.5            65.6      2.97    7216503 8.95e 9
##  5 Belarus 1990              13.5            70.5      1.89   10231983 1.44e10
##  6 Belgium 1990               8.3            76        1.58    9978241 1.87e11
##  7 Bulgar~ 1990              18.4            71.4      1.77    8821111 1.46e10
##  8 Croatia 1990              11.2            72.6      1.67    4776374 2.51e10
##  9 Cyprus  1990               9.9            76.8      2.41     766611 6.19e 9
## 10 Czech ~ 1990              12.7            71.8      1.82   10323701 5.63e10
## # ... with 851 more rows, and 3 more variables: continent <fct>, region <fct>,
## #   annual_pertussis_cases <dbl>
```
*Now we are ready to start exploring and manipulating this dataset and maybe create some visualizations as we go along!*

#### `dplyr::filter()` {-}
Subsetting data with `filter()`. Filter all data for the country 'The Netherlands'

```r
# join$year %>% as_factor %>% levels()
# join$country %>% as_factor() %>% levels()
netherlands <- join %>%
  dplyr::filter(country == "Netherlands")
netherlands
```

```
## # A tibble: 20 x 10
##    country year  infant_mortality life_expectancy fertility population     gdp
##    <chr>   <chr>            <dbl>           <dbl>     <dbl>      <dbl>   <dbl>
##  1 Nether~ 1990               6.8            77        1.62   14915139 2.82e11
##  2 Nether~ 1991               6.5            77.2      1.61   15019184 2.89e11
##  3 Nether~ 1992               6.3            77.3      1.59   15128288 2.94e11
##  4 Nether~ 1993               6.1            77.2      1.57   15239262 2.97e11
##  5 Nether~ 1994               5.8            77.5      1.57   15347792 3.06e11
##  6 Nether~ 1995               5.7            77.6      1.53   15450803 3.16e11
##  7 Nether~ 1996               5.5            77.6      1.53   15546647 3.27e11
##  8 Nether~ 1997               5.3            77.9      1.56   15636131 3.41e11
##  9 Nether~ 1998               5.3            78.1      1.63   15721627 3.54e11
## 10 Nether~ 1999               5.2            78        1.65   15806771 3.70e11
## 11 Nether~ 2000               5.1            78.1      1.72   15894016 3.85e11
## 12 Nether~ 2001               5              78.3      1.71   15984365 3.92e11
## 13 Nether~ 2002               4.9            78.5      1.73   16076427 3.93e11
## 14 Nether~ 2004               4.6            79.1      1.73   16253397 4.03e11
## 15 Nether~ 2005               4.5            79.6      1.71   16331646 4.11e11
## 16 Nether~ 2006               4.3            79.9      1.72   16401105 4.25e11
## 17 Nether~ 2007               4.2            80.2      1.72   16463031 4.42e11
## 18 Nether~ 2008               4              80.3      1.77   16519862 4.50e11
## 19 Nether~ 2009               3.8            80.6      1.79   16575173 4.34e11
## 20 Nether~ 2011               3.6            80.9      1.76   16689863 4.46e11
## # ... with 3 more variables: continent <fct>, region <fct>,
## #   annual_pertussis_cases <dbl>
```

#### Booleans {-}
Boolans such as `AND`, `OR` and `NOT` can be used to call multiple filter argument. You need to be explicit if you use them:

Using booleans with `filter()`

```r
#join$year %>% as_factor %>% levels()
#join$country %>% as_factor() %>% levels()

booleans_demo <- join %>%
  dplyr::filter(country == "Netherlands" |
         country == "Belarus" &
         year == "1990" |                 ## | is OR in R
         year == "1995" &                 ## & is AND in R   
         !annual_pertussis_cases < 100)   ## ! is NOT in R (not smaller                                                             than 100)
booleans_demo
```

```
## # A tibble: 40 x 10
##    country year  infant_mortality life_expectancy fertility population     gdp
##    <chr>   <chr>            <dbl>           <dbl>     <dbl>      <dbl>   <dbl>
##  1 Belarus 1990              13.5            70.5      1.89   10231983 1.44e10
##  2 Nether~ 1990               6.8            77        1.62   14915139 2.82e11
##  3 Nether~ 1991               6.5            77.2      1.61   15019184 2.89e11
##  4 Nether~ 1992               6.3            77.3      1.59   15128288 2.94e11
##  5 Nether~ 1993               6.1            77.2      1.57   15239262 2.97e11
##  6 Nether~ 1994               5.8            77.5      1.57   15347792 3.06e11
##  7 Albania 1995              29.1            73.7      2.72    3106727 2.83e 9
##  8 Belarus 1995              14.4            68.2      1.47   10159731 9.38e 9
##  9 Bosnia~ 1995              12.3            67        1.53    3879278 1.62e 9
## 10 Croatia 1995               8.7            73        1.52    4616762 1.82e10
## # ... with 30 more rows, and 3 more variables: continent <fct>, region <fct>,
## #   annual_pertussis_cases <dbl>
```

Conditional filtering. Conditions such as:

 - `>` or `>=` (larger than, or larger or eual to), 
 - `<` or `<=` (smaller than, or smaller or equal to) 
 - `==` (equal to) 
 - `!=` (not qual to)

Can be built into a `filter()` or `select()` call as we have seen above.
Let's apply this to our dataset in more detail. To match multiple filter statements you can use 

`%in%`

This shorthand is synonym for `match()` and takes a vector of values and a table (variable names in our case). 

Look at `?%in%` for more detail amd help

#### Example for using `%in%` (match) {-}

```r
numbers <- tribble(
  ~number_1, ~number_2,
  1,          2,
  3,          4,
  5,          6
)  

match_vector <- c(1,3)

## 
numbers %>% dplyr::filter(!number_1 %in% match_vector)
```

```
## # A tibble: 1 x 2
##   number_1 number_2
##      <dbl>    <dbl>
## 1        5        6
```

Generalized `%in%` looks like
```
values_you_want_to_match_against (variable name) %in% values_to_match (vector)
```

**Discuss with you neighbour**
Write a filter statement using the `join` data that:

 - filters only those countries that have more than 3000 annual cases for pertussis infection. 
 - Use only data between year 1990 and 2010 
 - The resulting table must only contain the variables `year`, `country` and `annual_pertussis_cases` in that order
 - Create a plot that shows that your code has worked



```r
## first define the values to match against
years <- c(1990:2010) %>% as.character()
## than do the filtering using %in%
join_filtered <- join %>%
  dplyr::filter(annual_pertussis_cases > 3000 &
         year %in% years) %>%
  dplyr::select(year,
         country,
         annual_pertussis_cases)

join_filtered %>%
  ggplot(aes(x = year,
             y = annual_pertussis_cases)) +
  geom_point(aes(colour = country)) +
  geom_line(aes(group = country, colour = country)) +
  theme(axis.text.x = element_text(angle = -90, hjust = 1))
```

<img src="ch08-wrangling_files/figure-html/using_match, options_exercises-1.png" width="672" />

#### `dplyr::arrange()` {-}
Sorting data with `arrange()`

 - Sort(rank) your data ascending or descending  
 - `{dplyr}` verb to use is `arrange()`, 
 - In conjunction with the `desc()` function if you want to rank in descending order 
 - `arrange()` takes one or multiple variable names for which you want to sort

#### Example `arrange()` {-}

```r
## ascending
join_filtered %>%
  arrange(annual_pertussis_cases)
```

```
## # A tibble: 61 x 3
##    year  country annual_pertussis_cases
##    <chr> <chr>                    <dbl>
##  1 2002  Norway                    3170
##  2 1992  Ukraine                   3363
##  3 1997  Italy                     3364
##  4 1994  Ukraine                   3374
##  5 2000  Norway                    3417
##  6 2010  Norway                    3565
##  7 1996  Spain                     3577
##  8 1998  Italy                     3632
##  9 1995  Spain                     3741
## 10 1999  Italy                     3797
## # ... with 51 more rows
```

```r
## descending
join_filtered %>%
  arrange(desc(annual_pertussis_cases))
```

```
## # A tibble: 61 x 3
##    year  country     annual_pertussis_cases
##    <chr> <chr>                        <dbl>
##  1 1994  Switzerland                  26000
##  2 1995  Switzerland                  20000
##  3 1991  Italy                        19356
##  4 1990  Italy                        16992
##  5 1995  Italy                        14359
##  6 1994  Italy                        13360
##  7 1994  Sweden                       13187
##  8 1997  Switzerland                  13000
##  9 1998  Switzerland                  13000
## 10 1993  Sweden                       11542
## # ... with 51 more rows
```
Apparently the worst `pertussis` year was 1994 in Switzerland?

#### `dplyr::mutate()` {-}
Changing variables on the basis of a computation (`mutate()`)
Sometimes you want to change a variable by mutation e.g.:

 - Change type of the variable
 - Compute a new variable using two exisiting ones
 - Do a mathmatical transformation (e.g. `log10()` of `log2()`)
 - ... something else that mutates a variable
 
You can do two things:
 
 1) Overwrite an existing variable with the newly mutated one
 2) Add a newly mutated variable to the existing data
 
#### Example `mutate()` {-}
The annual pertussis cases is reported as an absolulte number per year. Using the population size from the `gapminder` dataset, we can calculate the number of pertussis cases per 100.000 people in a country with `mutate()`  

```r
join_new <- join %>% 
  dplyr::mutate(incidence = 
                  (annual_pertussis_cases/population)*100000) %>%
  dplyr::select(incidence, 
         annual_pertussis_cases, 
         country, year) %>%
  arrange(desc(incidence))
join_new 
```

```
## # A tibble: 861 x 4
##    incidence annual_pertussis_cases country     year 
##        <dbl>                  <dbl> <chr>       <chr>
##  1      374.                  26000 Switzerland 1994 
##  2      285.                  20000 Switzerland 1995 
##  3      183.                  13000 Switzerland 1997 
##  4      183.                  13000 Switzerland 1998 
##  5      169.                   7737 Norway      2004 
##  6      163.                  11500 Switzerland 1996 
##  7      154.                  11000 Switzerland 1999 
##  8      150.                  13187 Sweden      1994 
##  9      141.                   6587 Norway      2006 
## 10      133.                  11432 Sweden      1991 
## # ... with 851 more rows
```

Plotting the cases/100.000

```r
pop_size_corrected <- join_new %>%
  dplyr::filter(country == "Netherlands" | country == "Norway") %>%
  ggplot(aes(x = year, 
             y = incidence)) +
  geom_line(aes(group = country, colour = country)) +
  theme(axis.text.x = element_text(angle = -90, hjust = 1))
```

Let's see the difference between correcting for population size or not

```r
pop_size_uncorrected <- join %>%
  dplyr::filter(country == "Netherlands" | country == "Norway") %>%
  ggplot(aes(x = year, 
             y = annual_pertussis_cases)) +
  geom_line(aes(group = country, colour = country)) +
  theme(axis.text.x = element_text(angle = -90, hjust = 1))
```

Plotting two graphs in a panel

```r
cowplot::plot_grid(pop_size_uncorrected,
                   pop_size_corrected, labels = c("A", "B"))
```

<img src="ch08-wrangling_files/figure-html/unnamed-chunk-17-1.png" width="960" />

**Discuss with you neighbour**

Using `dplyr::mutate()`

 - Calculate the log10 of the population in a new variable called `log10_pop`
 - Add this new variable to the `join` dataset  
 - Create a plot using this new `log10_pop` variable



```r
join %>% 
  dplyr::mutate(log10_pop = log10(population)) %>%
  ggplot(aes(x = gdp,
             y = log10_pop)) +
  geom_point(aes(colour = continent)) 
```

<img src="ch08-wrangling_files/figure-html/correct_population, options_exercises-1.png" width="672" />

```r
#+
 # facet_wrap(~year)
```
 
#### Summarize data with `dplyr::summarise()` {-}
Summarizing data is an important step in Exploratory Data Analysis. Especially if you have high deminsional data, summarizing might lead you to interesting findings. It comes at a price howver, you also discard information, so beware!

#### Example `dplyr::summarise()` {-}

```r
summary_plot <- join %>%
  group_by(country) %>%
  summarise(total_pertussis_cases = sum(annual_pertussis_cases)) %>%
  ggplot(aes(x = reorder(as_factor(country), total_pertussis_cases),
             y = total_pertussis_cases)) +
  geom_point() +
  coord_flip() +
  ylab("Total pertussis cases from 1990 - 2013") +
  xlab("Country")
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
summary_plot
```

<img src="ch08-wrangling_files/figure-html/unnamed-chunk-18-1.png" width="768" />

### Case 1; Which country has the highest total number of pertussis cases, over the years?

Create a code chuk below that:
 
 - Groups the data by `gdp`, `continent` and `year` (use the `gapminder` dataset)
 - Calculate the total population and the total gdp for each continent and each year
 - Plot the data in a graph that shows the relationship between year, continent, total gdp per continent and total population per continent.
 
**TIP** You might want to map population-size to the size of the datapoints 


```r
## your answer goes here --->
```


```r
plot <- gapminder %>%
  group_by(year, continent) %>%
  summarise(total_population = sum(population),
            total_gdp = sum(gdp), na.rm = TRUE) %>%
    ggplot(aes(x = year,
               y = total_gdp)) +
  geom_point(aes(colour = continent, size = total_population)) +
  coord_flip()
```

```
## `summarise()` regrouping output by 'year' (override with `.groups` argument)
```

```r
plot
```

```
## Warning: Removed 232 rows containing missing values (geom_point).
```

<img src="ch08-wrangling_files/figure-html/options_exercises-1.png" width="672" />
 
### Case 2; Is there a relationship between infant mortality and pertussis cases?  

**Write a code chunk below:**
 
 - Using `{ggplot2}`
 - Plot `annual_pertussis_cases` againt `infant_mortality`
 - Filter only for "Belarus" and "Netherlands"
 - Use all available data for these countries
 - Do not scroll ahead
 - What do you think is going on with this relationship?
 - Try using `colour = year` in your code
 - Try using `facet`s
 
## **ONE POSSIBLE SOLUTION**

```r
names(join)
```

```
##  [1] "country"                "year"                   "infant_mortality"      
##  [4] "life_expectancy"        "fertility"              "population"            
##  [7] "gdp"                    "continent"              "region"                
## [10] "annual_pertussis_cases"
```

```r
join %>%
  dplyr::filter(country == "Netherlands" |
         country == "Belarus") %>%
      ggplot(aes(x = annual_pertussis_cases,
               y = infant_mortality)) +
      geom_point(aes(colour = year)) +
  geom_smooth(method = "lm") +
  facet_wrap(~ country, scales = "free")
```

```
## `geom_smooth()` using formula 'y ~ x'
```

<img src="ch08-wrangling_files/figure-html/unnamed-chunk-20-1.png" width="672" />

## Other data sources
dplyr works with data that is stored in other ways, like data tables, databases and multidimensional arrays.

To see a tutorial: https://db.rstudio.com/dplyr/ 

## EXERCISES {-}




__Write an Rmd file, containing code chunks (if applicable) and answer all the questions below. Store the file in a folder called: "./answers_exercises" in your course project folder. Give this file the same name as the title of the current Rmd file__

## The exercise data {-}

For this exercise we use the "heights" dataset.
This dataset contains heights, weights, income and ethnicity information. The information for the variables that are needed for this exercise are in the file "annotations_height.txt".

It was downloaded from:

https://github.com/rstudio/webinars/tree/master/15-RStudio-essentials/4-Projects

Load the data with the following code

```r
library(tidyverse)

heights_file <- here::here("data", "heights.RDS")
heights <- read_rds(file = heights_file)
head(heights)
heights
heights_tib <- as_tibble(heights)
```

### <mark>**Exercise 1; Data inspection**</mark> {-}

1A) `head()` and `tail()`
Use the `head` and `tail` functions. The datset contains 3988 observations.   

 - What types of variables are present in the data.
 - Focus on the variables `id` `income`, `height`, `weight`, `sex` and `race`



1B) Call the function `summary()` on the data. {-}
What do you notice when you look at the max. and min. value for the `height`. For nicer printing (in an Rmd output file) you can use `pander::pander()` or `knitr::kable()`



1C) Missing values
Are there any missing values in the data? Determine the number of missing values. Try creating a plots using the `{naniar}` package.

 
### <mark>**Exercise 2; Selecting variables with {dplyr} and missing values**</mark> {-}

Subsetting data with the {dplyr} verbs `select()` and `filter()` is convenient for creating slices of the data that are of interest.

For this exercise we will use the variables: 

`id`, `income`, `height`, `weight`, `sex` and `race`

2A) Subsetting
Generate a subset of the `heights` dataframe containing only these variables. Call this new dataframe `heights_selected`
 
 - Use `dplyr::select()`
 - Use `%>%` 
 - To find NAs, use `sum(is.na(dataframe))`



2B) Check the amount of NAs that you have left in the dataset


2C) Complete cases
To complete the data-inspection and do a bit of cleaning we can look at the records in the `heigths_selected` dataset that are complete. This means, for which we have data points for all 5 variables.

use the function `complete.cases()` from the {stats} package. Look at `?complete.cases()` to see how to use this function. Create a new data frame with complete case that you call `heights_complete`

 - Remember that you can use data.frame[rows, columns] to subset a dataframe with a logical vector
 


2D) NAs in complete cases
How many NAs are present in the `heights_complete` dataset that you just created under 2C? What did you expect?


### <mark>**Exercise 3; Filtering**</mark> {-}

For the next assignment you can use the `filter()` command from {dplyr}

3A) Filter all people that have a weight of over 200 lbs {-}


3B) Who is most overweighted?
What is the most frequent ethnicity in the group of people that have a weight over 200 lbs   

 - Think about how you can answer this question: you want to have some sort of tabular summary! Discuss with your neighbour. And/or look on the internet. 


3C) Filter to extract the top 5 tallest hispanic males in the dataset   
What is their respective weight? 
What is their average height?

 - This one is already a bit more complicated:
 - Use `%>%`
 - Use `filter()`
 - Use `arrange()` to sort in descending order



3D) Finding individual datapoints
Find the two tallest women in the data. See if you can find two men that match the weight and heigt of these women.


### **<mark>Exercise 4; Creating new variables**</mark> {-}

The units of the data in the `heights` dataset is somewhat difficult to interpret because of the use of non-SI notation (so basically non-scientific units). The weights are in `lbs` or also called pounds and the height is in `inches`.

 * 1 inch = 2.54 cm
 * 1 lbs = 0.45359237 kg

4A) Convert the `height` and the `weight` variable to SI units (so meters, and kg, respectively)
 
 Add the new variables to the exsting `heigths_complete` dataset. Call the new columns: `height_m` and `weight_kg`
 
  - Use `dplyr::mutate()` to solve this question 
  - Round the `height_m` and `weight_kg` to decimals that make sense
 


4B) Body-mass index
The body-mass index or BMI can be calculated from the weight and the height of a person. 
 
 The formula for determining the BMI is
 
 Bodyweight in kilograms divided by height in meters squared
 
 or in formula form:
 
$BMI=\frac{bodyweight(kg)}{height(meters)^2}$
 
4C) Calculate a new variale called `bmi` for the `heights_complete` dataset


### <mark>**Exercise 5; Grouping and summarizing**</mark> {-}
When we have multiple observations per unit or groups of units, it makes sense to be able to group the data accordingly.

Here we need to take a closer look at `dplyr::group_by` and `dplyr::summarize` to group, summarize and generate new summary variables of the (cleaned) data. 

5A) Summarize the data

 - Group the data by `race`, and `sex`, drop the `id`, variable
 - Call the new summarized dataframe: `heights_summary`
 - Make a `summary` dataframe with new summary variables with the `dplyr::summary()`function 
 - Call the new summary variables `mean_height_in`, `mean_weight_lbs`, `mean_height_m`, `mean_weight_kg`, `mean_bmi` and `mean_income`
 - Rank (`dplyr::arrange()`) the data according income from high to low (`arrange(desc(variable_for_which_to_rank)`)
 


5B) Which race has the highest income?



5C) Gender difference in mean income?

Is there a difference between males and females. For which race is this difference the biggest? Also create a plot to confirm this observation.


