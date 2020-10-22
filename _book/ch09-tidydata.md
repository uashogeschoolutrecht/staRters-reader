# Tidy Data {#tidydata}

## Credits
The contents of this chapter are (partly) reproduced from [@r4ds]

## Introduction

 * In this lesson, you will learn a consistent way to structure your data in R, in a framework called __tidy data__. 
 * Getting your data into this format requires some upfront work, but that work pays off in the long term. 
 * Once you have tidy data and the tidy tools provided by packages in the tidyverse and others, you will spend much less time munging data from one representation to another, allowing you to spend more time on the analytic questions at hand.

## `{tidyr}` package

 * This lesson will give you a practical introduction to tidy data and the accompanying tools in the __tidyr__ package. 

If you'd like to learn more about the underlying theory, you might enjoy the *Tidy Data* paper published in the Journal of Statistical Software, <http://www.jstatsoft.org/v59/i10/paper>.

## Prerequisites
In this chapter we'll focus on tidyr, a package that provides a bunch of tools to help tidy up your messy datasets. tidyr is a member of the core tidyverse.


```r
library(tidyverse)
```

<img src="C:/Users/mteunis/workspaces/staRters/images/tidyr_sticker.png" width="222" />

## Tidy data rules
<img src="C:/Users/mteunis/workspaces/staRters/images/tidy-1.png" width="737" />

 * Each variable goes in it's own column
 * Each observation goes in a singe row
 * Each cell contains only one value

__**You will need them in (almost) every analysis!**__

## Examples 

 * This dataset concerns tuberculosis incidence in multiple countries over 2 years
 * Each dataset shows the same values of four variables *country*, *year*, *population*, and *cases*
 * Ask yourself: "How are the following tables different?"
 * Check if, and how the table complies to the tidy data rules

## Example 1

```r
head(table1, 6)
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

## Example 2

```r
head(table2, 6)
```

```
## # A tibble: 6 x 4
##   country      year type           count
##   <chr>       <int> <chr>          <int>
## 1 Afghanistan  1999 cases            745
## 2 Afghanistan  1999 population  19987071
## 3 Afghanistan  2000 cases           2666
## 4 Afghanistan  2000 population  20595360
## 5 Brazil       1999 cases          37737
## 6 Brazil       1999 population 172006362
```

## Example 3

```r
head(table3, 6)
```

```
## # A tibble: 6 x 3
##   country      year rate             
##   <chr>       <int> <chr>            
## 1 Afghanistan  1999 745/19987071     
## 2 Afghanistan  2000 2666/20595360    
## 3 Brazil       1999 37737/172006362  
## 4 Brazil       2000 80488/174504898  
## 5 China        1999 212258/1272915272
## 6 China        2000 213766/1280428583
```

## Data can be spread across multiple files/tables

```r
head(table4a, 3)  # cases
```

```
## # A tibble: 3 x 3
##   country     `1999` `2000`
##   <chr>        <int>  <int>
## 1 Afghanistan    745   2666
## 2 Brazil       37737  80488
## 3 China       212258 213766
```

```r
head(table4b, 3)  # population
```

```
## # A tibble: 3 x 3
##   country         `1999`     `2000`
##   <chr>            <int>      <int>
## 1 Afghanistan   19987071   20595360
## 2 Brazil       172006362  174504898
## 3 China       1272915272 1280428583
```

## One winner!
In the previous example, only `table1` is tidy. It's the only representation where each column is a variable. 


```r
head(table1)
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

## Why tidy data?
Why ensure that your data is tidy? There are two main advantages:

 1. There's a general advantage to picking one consistent way of storing data. If you have a consistent data structure, it's easier to learn the tools that work with it because they have an underlying uniformity.
    
 2. There's a specific advantage to placing variables in columns because they are vectors. Most built-in R functions work with vectors of values.

## Packages from the tidyverse are designed for tidy data 

Example plot from `table1`

```r
# Compute rate per 10,000
table1 %>% 
  mutate(rate = cases / population * 10000)
```

```
## # A tibble: 6 x 5
##   country      year  cases population  rate
##   <chr>       <int>  <int>      <int> <dbl>
## 1 Afghanistan  1999    745   19987071 0.373
## 2 Afghanistan  2000   2666   20595360 1.29 
## 3 Brazil       1999  37737  172006362 2.19 
## 4 Brazil       2000  80488  174504898 4.61 
## 5 China        1999 212258 1272915272 1.67 
## 6 China        2000 213766 1280428583 1.67
```

## Compute cases per year

```r
table1 %>% 
  count(year, wt = cases)
```

```
## # A tibble: 2 x 2
##    year      n
##   <int>  <int>
## 1  1999 250740
## 2  2000 296920
```

### <mark>**EXERCISE 1 Visualize changes over time**</mark> {-}

A) Create a plot from `table1` tuberculosis data, showing the number of cases from each country.

B) Now plot the incidence (number of cases per 10,000 people) for each country.

C) What can you conclude from the plots in exercise 1A) and 1B)



## Gathering

When some of the column names are not names of variables, but _values_ of a variable. Take `table4a`: the column names `1999` and `2000` represent values of the `year` variable, and each row represents two observations, not one.


```r
table4a
```

```
## # A tibble: 3 x 3
##   country     `1999` `2000`
## * <chr>        <int>  <int>
## 1 Afghanistan    745   2666
## 2 Brazil       37737  80488
## 3 China       212258 213766
```

## Gathering a set of value columns

To tidy a dataset like this, we need to __gather__ those columns into a new pair of variables. To describe that operation we need three parameters:

* The set of columns that represent values, not variables. In this example, 
  those are the columns `1999` and `2000`.
* The name of the variable whose values form the column names. I call that
  the `key`, and here it is `year`.
* The name of the variable whose values are spread over the cells. I call 
  that `value`, and here it's the number of `cases`.
  
## "gather()"  

```r
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
```

```
## # A tibble: 6 x 3
##   country     year   cases
##   <chr>       <chr>  <int>
## 1 Afghanistan 1999     745
## 2 Brazil      1999   37737
## 3 China       1999  212258
## 4 Afghanistan 2000    2666
## 5 Brazil      2000   80488
## 6 China       2000  213766
```

## The actions "gather()" performs
<div class="figure">
<img src="C:/Users/mteunis/workspaces/staRters/images/tidy-9.png" alt="Gathering `table4` into a tidy form." width="100%" />
<p class="caption">(\#fig:tidy-gather)Gathering `table4` into a tidy form.</p>
</div>

## Tidy table 4b

```r
table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
```

```
## # A tibble: 6 x 3
##   country     year  population
##   <chr>       <chr>      <int>
## 1 Afghanistan 1999    19987071
## 2 Brazil      1999   172006362
## 3 China       1999  1272915272
## 4 Afghanistan 2000    20595360
## 5 Brazil      2000   174504898
## 6 China       2000  1280428583
```

### <mark>**EXERCISE 2 Gathering columns**</mark> {-}
The data file "./data/messy_excel.xlsx" is not very tidy. Open the file in Excel. Discuss with you neighbour how you would tidy the data in this file, without changing anything in the Excel file. Write down your plan. try to develop a stepwise protocol that includes code-snippets and/or pseudo code.

**TIPS**
 
 1. You can define a range to be parsed in the readxl package
 1. You will need gather some columns in the data
 1. You might want to parse the file 2 times with different ranges to get all the data into R
 1. First try to parse the file as it is to see what R makes of the file and try to design (in Excel if you want) the end result that you would like to achieve.

_This is a difficult exercise and it will take you some time to figure out how to achieve this, take the time to look for additional online information_



## Joining tables
To combine the tidied versions of `table4a` and `table4b` into a single tibble, we need to use `dplyr::left_join()`

```r
tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
joined_4a_4b <- left_join(tidy4a, tidy4b)
joined_4a_4b
```

```
## # A tibble: 6 x 4
##   country     year   cases population
##   <chr>       <chr>  <int>      <int>
## 1 Afghanistan 1999     745   19987071
## 2 Brazil      1999   37737  172006362
## 3 China       1999  212258 1272915272
## 4 Afghanistan 2000    2666   20595360
## 5 Brazil      2000   80488  174504898
## 6 China       2000  213766 1280428583
```

## Spreading
Spreading is the opposite of gathering. You use it when an observation is scattered across multiple rows. For example, take `table2`: an observation is a country in a year, but each observation is spread across two rows.


```r
table2
```

```
## # A tibble: 12 x 4
##    country      year type            count
##    <chr>       <int> <chr>           <int>
##  1 Afghanistan  1999 cases             745
##  2 Afghanistan  1999 population   19987071
##  3 Afghanistan  2000 cases            2666
##  4 Afghanistan  2000 population   20595360
##  5 Brazil       1999 cases           37737
##  6 Brazil       1999 population  172006362
##  7 Brazil       2000 cases           80488
##  8 Brazil       2000 population  174504898
##  9 China        1999 cases          212258
## 10 China        1999 population 1272915272
## 11 China        2000 cases          213766
## 12 China        2000 population 1280428583
```

To tidy this up, we first analyse the representation in similar way to `gather()`. This time, however, we only need two parameters:

* The column that contains variable names, the `key` column. Here, it's 
  `type`.
* The column that contains values forms multiple variables, the `value`
  column. Here it's `count`.

## "spread()"

```r
spread(table2, key = type, value = count)
```

```
## # A tibble: 6 x 4
##   country      year  cases population
##   <chr>       <int>  <int>      <int>
## 1 Afghanistan  1999    745   19987071
## 2 Afghanistan  2000   2666   20595360
## 3 Brazil       1999  37737  172006362
## 4 Brazil       2000  80488  174504898
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

## The action "spread()" performs
<div class="figure">
<img src="C:/Users/mteunis/workspaces/staRters/images/tidy-8.png" alt="Spreading `table2` makes it tidy" width="100%" />
<p class="caption">(\#fig:tidy-spread)Spreading `table2` makes it tidy</p>
</div>

## "gather()" and "spread()" are complementary
As you might have guessed from the common `key` and `value` arguments, `spread()` and `gather()` are complements. `gather()` makes wide tables narrower and longer; `spread()` makes long tables shorter and wider.

## Separating and uniting

`table3` has a different problem: we have one column (`rate`) that contains two variables (`cases` and `population`). To fix this problem, we'll need the `separate()` function. You'll also learn about the complement of `separate()`: `unite()`, which you use if a single variable is spread across multiple columns.

## "separate()"

`separate()` pulls apart one column into multiple columns, by splitting wherever a separator character appears. Take `table3`:


```r
table3
```

```
## # A tibble: 6 x 3
##   country      year rate             
## * <chr>       <int> <chr>            
## 1 Afghanistan  1999 745/19987071     
## 2 Afghanistan  2000 2666/20595360    
## 3 Brazil       1999 37737/172006362  
## 4 Brazil       2000 80488/174504898  
## 5 China        1999 212258/1272915272
## 6 China        2000 213766/1280428583
```

## Separating rate into cases and population

```r
table3 %>% 
  separate(rate, into = c("cases", "population"))
```

```
## # A tibble: 6 x 4
##   country      year cases  population
##   <chr>       <int> <chr>  <chr>     
## 1 Afghanistan  1999 745    19987071  
## 2 Afghanistan  2000 2666   20595360  
## 3 Brazil       1999 37737  172006362 
## 4 Brazil       2000 80488  174504898 
## 5 China        1999 212258 1272915272
## 6 China        2000 213766 1280428583
```

## The action "separate()" performs
<div class="figure">
<img src="C:/Users/mteunis/workspaces/staRters/images/tidy-17.png" alt="Separating `table3` makes it tidy" width="75%" />
<p class="caption">(\#fig:tidy-separate)Separating `table3` makes it tidy</p>
</div>

## Unite
`unite()` is the inverse of `separate()`: it combines multiple columns into a single column. 

Look at `?tidyrt::unite()` to see the help and examples

## Missing values

Changing the representation of a dataset brings up an important subtlety of missing values. Surprisingly, a value can be missing in one of two possible ways:

* __Explicitly__, i.e. flagged with `NA`.
* __Implicitly__, i.e. simply not present in the data.

Let's illustrate this idea with a very simple data set:


```r
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
```

## The stocks dataframe

```r
stocks
```

```
## # A tibble: 7 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4  NA   
## 5  2016     2   0.92
## 6  2016     3   0.17
## 7  2016     4   2.66
```

## There are two missing values in this dataset:

 * The return for the fourth quarter of 2015 is explicitly missing, because the cell where its value should be instead contains `NA`.
 * The return for the first quarter of 2016 is implicitly missing, because it simply does not appear in the dataset.

## Making implicit missing values explicit
The way that a dataset is represented can make implicit values explicit. For example, we can make the implicit missing value explicit by putting years in the columns:


```r
stocks %>% 
  spread(year, return)
```

```
## # A tibble: 4 x 3
##     qtr `2015` `2016`
##   <dbl>  <dbl>  <dbl>
## 1     1   1.88  NA   
## 2     2   0.59   0.92
## 3     3   0.35   0.17
## 4     4  NA      2.66
```

## "na.rm = TRUE"
Because these explicit missing values may not be important in other representations of the data, you can set `na.rm = TRUE` in `gather()` to turn explicit missing values implicit:


```r
stocks %>% 
  spread(year, return) %>% 
  gather(year, return, `2015`:`2016`, na.rm = TRUE)
```

```
## # A tibble: 6 x 3
##     qtr year  return
##   <dbl> <chr>  <dbl>
## 1     1 2015    1.88
## 2     2 2015    0.59
## 3     3 2015    0.35
## 4     2 2016    0.92
## 5     3 2016    0.17
## 6     4 2016    2.66
```

## Explicit missing values "complete()"
Another important tool for making missing values explicit in tidy data is `complete()`:


```r
stocks %>% 
  complete(year, qtr)
```

```
## # A tibble: 8 x 3
##    year   qtr return
##   <dbl> <dbl>  <dbl>
## 1  2015     1   1.88
## 2  2015     2   0.59
## 3  2015     3   0.35
## 4  2015     4  NA   
## 5  2016     1  NA   
## 6  2016     2   0.92
## 7  2016     3   0.17
## 8  2016     4   2.66
```


## The "complete()" function
`complete()` takes a set of columns, and finds all unique combinations. It then ensures the original dataset contains all those values, filling in explicit `NA`s where necessary.

## Forward carrying
Sometimes when a data source has primarily been used for data entry, missing values indicate that the previous value should be carried forward:

## Carry-forward example

```r
(treatment <- tribble(
  ~ person,            ~ treatment, ~response,
  "Hans Anders",       1,           7,
  NA,                  2,           10,
  NA,                  3,           9,
  "Alber Heijn",       1,           4,
  NA,                  2,           8,
  NA,                  3,           12
))
```

```
## # A tibble: 6 x 3
##   person      treatment response
##   <chr>           <dbl>    <dbl>
## 1 Hans Anders         1        7
## 2 <NA>                2       10
## 3 <NA>                3        9
## 4 Alber Heijn         1        4
## 5 <NA>                2        8
## 6 <NA>                3       12
```

## Filling in the 'missing values'
You can fill in these missing values with `fill()`. It takes a set of columns where you want missing values to be replaced by the most recent non-missing value (sometimes called last observation carried forward).


```r
treatment %>% 
  fill(person)
```

```
## # A tibble: 6 x 3
##   person      treatment response
##   <chr>           <dbl>    <dbl>
## 1 Hans Anders         1        7
## 2 Hans Anders         2       10
## 3 Hans Anders         3        9
## 4 Alber Heijn         1        4
## 5 Alber Heijn         2        8
## 6 Alber Heijn         3       12
```


### <mark>**EXERCISE 3 Inspecting tidyness**</mark> {-}

3A) Describe how the variables and observations are organised in each of the sample tables: 
`table1`, `table2`, `table3`, `table4a`, `table4b`.

3B) Compute the `rate` for `table2`, and `table4a` + `table4b`. 

**STEPS**

You will need to perform four operations:

 1.  Extract the number of TB cases per country per year.
 2.  Extract the matching population per country per year.
 3.  Divide cases by population, and multiply by 10000.
 4.  Store back in the appropriate place.
 5.  Sort the data according year (ascending)
 
**TIPS**
 
 - You will need {tidyr} and {dplyr}
 - You will also need `mutate()` to calculate the rate
 - Use the pipe `%>%` 
 - Rember `gather()` collects observations in columns into variable columns (from wide to stacked) and `spread()` unstacks variables into variable columns (from stacked to wide)
 - Table 4a contains the cases, table 4b contains the populations
 - For joining the tables 4a and 4b you can use the `dplyr::left_join()` function. See `help("dplyr")` or `?dplyr` for more information.

table2


table 4a + 4b


Which representation is easiest to work with? Which is hardest? Why?

### <mark>**EXERCISE 4: Plotting tidy data**</mark> {-}

4A)  Recreate the plot showing change in cases over time using `table2`
instead of `table1`. What do you need to do first?



4B) Why does the code below fail, can you fix it?

```r
    table4a %>% 
      gather(1999, 2000, key = "year", value = "cases")
```

```
## Error: Can't subset columns that don't exist.
## [31mx[39m Locations 1999 and 2000 don't exist.
## [34mi[39m There are only 3 columns.
```

### <mark>**EXERCISE 5: Wide to long; Spreading and Gathering**</mark> {-}

5A)  Tidy the simple tibble below. Do you need to spread or gather it?




5B) Calculate the percentage of females that are pregnant, of all females in the dataset. 


5C) How many males are there in the dataset? How many of them are pregnant ;-)


### <mark>**EXERCISE 6: Additional operations**</mark> {-}

6A) What do the `extra` and `fill` arguments do in `separate()`? Experiment with the various options for the following two toy datasets.
    

```r
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
separate(x, c("one", "two", "three"))
```

6B) Compare and contrast the functions `separate()` and `extract()`.  Why are there three variations of separation (by position, by separator, and with groups), but only one unite?

### <mark>**EXERCISE 7: A Case**</mark> {-}

7A) Tidy the following dataset: "./data/messydata_5a.xlsx"
The data represents Mariages during the four seasons for a number of years in regions in Germany. 

Note: Germany has 16 states. When you load the data you will notice that the coding of the factor variable "State" is not consistent. You will need to correct tihs coding in order for the data to be tidy.
Use the function from {forcats} `forcats::fct_recode()` to achieve this. This file "./data/germany_states.txt" contains information on the states. How can you load this file into R?


**TIPS**
 
 - Use the code below to read all the sheets of the excel file, look at the help function first.
 - Which parameter of `read_excel()` controls the sheets to read? 
 - To read multiple sheets, a for loop is used
 - The Excel file contains 7 sheets 
 - Check spelling and values: are they consistent. 
 - Read the chapter "
 - Think about `gather()` or `spread()`, which do you need?
 - To convert a list of dataframes to one dataframe look at:
 the help for the function `dplyr::bind_rows()`. You will have to use this to convert the list of sheets into one dataframe.
- The first two sheets of the Excel file contain mistakes and errors

### Read data {-}

```r
library(readxl)

# path to data file
path_to_messy_mariages <- file.path(
  here::here(
    "data", 
    "messydata_5a.xlsx"))

# load messy data in empty list with loop and read_excel
messy_mariages <- list()

for(i in 1:7){
  messy_mariages[[i]] <- read_excel(path = path_to_messy_mariages, 
                                    sheet = i)
  messy_mariages[[i]]$timestamp <- i
}
```

```
## New names:
## * `` -> ...3
## * `` -> ...5
## * `` -> ...6
## * `` -> ...7
## * `` -> ...8
```




7B) Start analyzing your tidy data

 - How many marriages are there per year in each German "Bundesland"?
 - Visualize your findings in a plot
 


7C) Visual analysis
Compare the marriages of 1990, 2003 and 2014 and colour them by season

**TIPS:**
 - Filter data by the years 1990, 2003 and 2014
 - Group it by year and season and add up the values


