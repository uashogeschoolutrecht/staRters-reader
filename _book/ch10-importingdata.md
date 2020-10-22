# Importing data {#importingdata}

## Packages

```r
library(tidyverse)
library(haven)
```

## Don't be absolute!

 * You could point to a file with an absolute path: 
 The file for the "allijn" dataset on my laptop is located at:

```r
"C:/Users/mteunis/workspaces/staRters/data/allijn.tsv"
```

```
## [1] "C:/Users/mteunis/workspaces/staRters/data/allijn.tsv"
```
There is a very good chance that this folder does not exist on your machine. 

 -__Using absolute paths probably makes the code break almost every time__
 
 -__Whatever you do, do not use the function `setwd()` to change the working directory__

## Be relative!!

There are a few things you should do to increase portability of your R projects:

 * ALWAYS work in an RStudio Project. 
 * Also when you are playing (call your folder "play" or "sandbox" or something), than later move files to their intended locations!
 * **ONLY** use relative paths, they prevent code from breaking in the future
 * Use the `{here}` package to create relative paths
## File types

## File types

There are many functions available in Base-R and in packages to read in very different file types. In this chapter we mainly use `{readr}`. Users of Excel should look in the "/extra" folder for a demo on using `{readxl}` to read Excel files into R. 

In general it is always better to use a non-proprietary format for data (csv, txt, tab-delimted, json etc.). When you use Excel. Just export the final dataset you want to analyse, share or post in repository to a cvs file.

A good data file comes with a thouroughly documented `README.txt` file that explains how the data was obtained, who the owner is and what the variables mean, and what their respective units of measurment are.



 - Proprietary: `xls`, `xlsx`, `sav` or (`{reaxl}`, `{xlsx}`, `{haven}`, `{foreign}`)
 - text-based: `csv`, `txt`, `json` (`{readr}`, `{jsonlite}`)
 - xml-based: `XML`, `mzXML` (`{XML}`, `{xml2}`, `{mzR}`)
 - cdf-based (maps data: `NCDF` (`{ncdf4}`)
 
The packages `{foreign}` and `{haven}` can also read files from SAS, Minitab, S-Plus, SPSS, Stata, Systat and EpiInfo software.  


```r
## sav example for SPSS files (with {haven})
data_mtcars_spss <- read_sav(
  here::here(
    "data",
    "mtcars.sav"
  )
)
```

 If you want to find a function or package for your specific file type, a search on Google usually does the trick: e.g. 'Prism' files can be read in using the information in this link: https://cran.r-project.org/web/packages/pzfx/vignettes/pzfx.html

### <mark>**EXERCISE 1 - Construct a path to a data file**</mark> {-}

To make the code as reproducible as possible
 
 1) Construct a `file.path` to the data file you want to import
 2) Use this `file.path` as argumnent for the call in your import function. Construct the `file.path` relative to the current working directory
 3) use the function `here()` from the `{here}`

A) Construct a full path to the `DP_LIVE_06112019150508524.csv` file located in the `/data` folder, using the `here()` function.
 


B) Read the `DP_LIVE_06112019150508524.csv` file into R using the `{readr}` package. Consult  help("readr") for tips. Try to think about what type of file this can be. Open the file in the Viewer choose 'View file' in the Files pane of RStudio, click on the file.    


```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   LOCATION = col_character(),
##   INDICATOR = col_character(),
##   SUBJECT = col_character(),
##   MEASURE = col_character(),
##   FREQUENCY = col_character(),
##   TIME = col_double(),
##   Value = col_double(),
##   `Flag Codes` = col_logical()
## )
```

```
## # A tibble: 3,110 x 8
##    LOCATION INDICATOR SUBJECT MEASURE FREQUENCY  TIME Value `Flag Codes`
##    <chr>    <chr>     <chr>   <chr>   <chr>     <dbl> <dbl> <lgl>       
##  1 AUS      TAXREV    TOT     PC_GDP  A          1965  20.6 NA          
##  2 AUS      TAXREV    TOT     PC_GDP  A          1966  19.9 NA          
##  3 AUS      TAXREV    TOT     PC_GDP  A          1967  20.4 NA          
##  4 AUS      TAXREV    TOT     PC_GDP  A          1968  20.4 NA          
##  5 AUS      TAXREV    TOT     PC_GDP  A          1969  20.7 NA          
##  6 AUS      TAXREV    TOT     PC_GDP  A          1970  21.1 NA          
##  7 AUS      TAXREV    TOT     PC_GDP  A          1971  21.9 NA          
##  8 AUS      TAXREV    TOT     PC_GDP  A          1972  21.4 NA          
##  9 AUS      TAXREV    TOT     PC_GDP  A          1973  22.5 NA          
## 10 AUS      TAXREV    TOT     PC_GDP  A          1974  24.6 NA          
## # ... with 3,100 more rows
```

--- END EXERCISE ---

## Getting started with importing files
Most of `{readr}` functions are concerned with turning flat files into data frames:

* `read_csv()` reads comma delimited files, 
* `read_csv2()` reads semicolon
  separated files (common in countries where "`,`" is used as the decimal place),
* `read_tsv()` reads tab delimited files, and 
* `read_delim()` reads in files with any delimiter.
* `read_fwf()` reads fixed width files. You can specify fields either by their
  widths with `fwf_widths()` or their position with `fwf_positions()`.
* `read_table()` reads a common variation of fixed width files where columns are separated by white space.

## CSV as the golden standard

* Convert Excel files to CSV files
* Use CSV as much as possible
* The delimiter in CSV can be different: "," or ";"
* `read_csv` works with ","
* `read_csv2` works with ";"

## General syntax
The first argument to `read_csv()` is the most important: it's the path to the file to read.

```
path_to_file <- here::here("subfolder", "datafile")
read_...(file = path_to_file, ...)

## ... = aditional options

```

### <mark>**EXERCISE 2 - parser message in `{readr}`**</mark> {-}

A) Read the file "heights.csv" in the "/data" folder into R, using the `{readr}` package.
If all goes well you will see the following message: 

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   earn = col_double(),
##   height = col_double(),
##   sex = col_character(),
##   ed = col_double(),
##   age = col_double(),
##   race = col_character()
## )
```

**Parser message**
When you run `read_csv()` it prints out a column specification that gives the name and type of each column. That's an important part of readr, which we'll come back to in [parsing a file].

B) Experiment with readr
You can also supply an inline csv file. This is useful for experimenting with readr and for creating reproducible examples to share with others:
Run the code below, discuss with your neighbour what you think happened and why this works.

```r
read_csv("a,b,c
1,2,3
4,5,6")
```

```
## # A tibble: 2 x 3
##       a     b     c
##   <dbl> <dbl> <dbl>
## 1     1     2     3
## 2     4     5     6
```

```r
# each new line results in a new row of observations
```

--- END EXERCISE ---

## Changing default behaviour
In both cases `read_csv()` uses the first line of the data for the column names, which is a very common convention. There are two cases where you might want to tweak this behaviour:

## Skipping lines (usually at the top of the file)
Sometimes there are a few lines of metadata at the top of the file. You can
use `skip = n` to skip the first `n` lines; or use `comment = "$$"` to drop
all lines that start with (e.g.) `$$`.
    

```r
## no options
read_csv("The first line of metadata
The second line of metadata
x,y,z
1,2,3
4,6,8")
```

```
## Warning: 3 parsing failures.
## row col  expected    actual         file
##   2  -- 1 columns 3 columns literal data
##   3  -- 1 columns 3 columns literal data
##   4  -- 1 columns 3 columns literal data
```

```
## # A tibble: 4 x 1
##   `The first line of metadata`
##   <chr>                       
## 1 The second line of metadata 
## 2 x                           
## 3 1                           
## 4 4
```

```r
## skip lines
read_csv("The first line of metadata
The second line of metadata
x,y,z
1,2,3
4,6,8", skip = 2)
```

```
## # A tibble: 2 x 3
##       x     y     z
##   <dbl> <dbl> <dbl>
## 1     1     2     3
## 2     4     6     8
```

```r
## define comment
read_csv("#The first line of metadata
#The second line of metadata
x,y,z
1,2,3
4,6,8", comment = "#")
```

```
## # A tibble: 2 x 3
##       x     y     z
##   <dbl> <dbl> <dbl>
## 1     1     2     3
## 2     4     6     8
```

### <mark>**EXERCISE 3 - comments and skipping lines**</mark> {-}

A) Parse the "allijn.tsv" file in the "/data". This file has comments at the top of the file in the first 22 lines. Each comment is indicated by either a double pound sign "##". Open the file first to confirm this.


B) Can you come up with a way that would prevent opening this file first in RStudio in the viewer and still learn how the first few lines of the file look. 

**TIP: The solution to the above challenge requires you to think about a Linux Terminal command. You can exacute Terminal command from inside R with the `system()` function.

```r
system("head -25 data/allijn.tsv")
```

--- END EXERCISE ---

## No headers / column names    
The data might not have column names. You can use `col_names = FALSE` to
tell `read_csv()` not to treat the first row as headings, and instead
label them sequentially from `X1` to `Xn`:
    

```r
read_csv("1,2,3 \n 4,5,6", col_names = FALSE)
```

```
## # A tibble: 2 x 3
##      X1    X2    X3
##   <dbl> <dbl> <dbl>
## 1     1     2     3
## 2     4     5     6
```
    
(`"\n"` is a convenient shortcut for adding a new line)

## Setting column names for `readr`    
Alternatively you can pass `col_names` a character vector which will be
used as the column names:
    

```r
read_csv("1,2,3\n4,5,6", col_names = c("var_1", "var_2", "var_3"))
```

```
## # A tibble: 2 x 3
##   var_1 var_2 var_3
##   <dbl> <dbl> <dbl>
## 1     1     2     3
## 2     4     5     6
```


### <mark>**EXERCISE 4 - Missing values**</mark> {-}
Another option that commonly needs tweaking is `na`: this specifies the value (or values) that are used to represent missing values in your file:


```r
read_csv("a,b,c \n 1,2,.", na = ".")
```

```
## # A tibble: 1 x 3
##       a     b c    
##   <dbl> <dbl> <lgl>
## 1     1     2 NA
```

A) Read the file "John.csv" in the "/data/diet" folder.
Try fixing the different annotations for missing values used in this file by setting the `na = c(...)` option in your readr function call.


```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   `Patient Name` = col_character(),
##   Age = col_double(),
##   Weight = col_character(),
##   Day = col_double()
## )
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   `Patient Name` = col_character(),
##   Age = col_double(),
##   Weight = col_double(),
##   Day = col_double()
## )
```

B) What happens to the type of the variables when you do not set the `na` option?


C) The folder "./data/diet" contains a number of csv files. How would you go about if you want to join all these files in one big dataframe? First write pseudocode, than write the full code.

**TIPS** 

 - use the function `list.files()`, set the option `full.names = TRUE` and `pattern = "\\.csv"`
 - use the function `map_df()` to loop over the list of file paths, in conjuction with `read_csv()`
 - you will need to set `na = c("?", "not recorded", "missing", "", " ")`
 - think about also setting the parser for your calls to read_csv
 - build a pipe (using `%>%`) that does the full processing of all steps and outputs the combined dataframe
 
 


-- **END EXERCISE** --

## Examples to learn more
You can also easily adapt what you've learned to read tab separated files with

 * `read_tsv()` and 
 * fixed width files with `read_fwf()`
 * you can even have more control over which delimiter was used (to seperate the columns in the file) with `read_delim()`

### <mark>**EXERCISE 5 - delimiters**</mark> {-} 

A) Parse the file "gender.txt" in the "/data" folder. Remember that a quick inspection in the Linux terminal is a good idea before trying to read any file into R.

B) Which function of readr did you use? Why?

--- **END EXERCISE** ---

## Challenging variable types 
To read in more challenging files, you'll need to learn more about how readr parses each column, turning them into R vectors. This is an advanced operation and will be addressed during exercises, when we need it

1.  `parse_logical()` and `parse_integer()` parse logicals and integers
    respectively. There's basically nothing that can go wrong with these
    parsers so I won't describe them here further.
    
2.  `parse_double()` is a strict numeric parser, and `parse_number()` 
    is a flexible numeric parser. These are more complicated than you might
    expect because different parts of the world write numbers in different
    ways.
    
3.  `parse_character()` seems so simple that it shouldn't be necessary. But
    one complication makes it quite important: character encodings.

4.  `parse_factor()` create factors, the data structure that R uses to represent
    categorical variables with fixed and known values.

5.  `parse_datetime()`, `parse_date()`, and `parse_time()` allow you to
    parse various date & time specifications. These are the most complicated
    because there are so many different ways of writing dates.

We will adress only the most important parsers

## Numbers
It seems like it should be straightforward to parse a number, but three problems make it tricky:

* People write numbers differently in different parts of the world. For example, some countries use `.` as a decimal placeholder, others use `,`.
* Numbers are often surrounded by other characters that provide some context, like "$8,-" or "99.9%".
* Numbers often contain "grouping" characters to make them easier to read, like "1,000,000", and these grouping characters vary around the world.

## Overiding the default `decimal_mark`
You can override the default value of `.` (dot) by creating a new locale and setting the `decimal_mark` argument:

**Remember, R is US centric, so by default it regards the `.` as a decimal**


```r
parse_double("8.78")
```

```
## [1] 8.78
```

```r
parse_double("8,78", locale = locale(decimal_mark = ","))
```

```
## [1] 8.78
```

```r
# in Some countries "," is used as a decimal place holder
```

## Numbers parsing
`parse_number()` addresses the second problem: it ignores non-numeric characters before and after the number. This is particularly useful for currencies and percentages, but also works to extract numbers embedded in text.

It can be especially helpful if you are trying to parse an Excel or Excel-derived file, because Excel users often apply some additional formatting to the contents of a workbook.


```r
parse_number("$8,-")
```

```
## [1] 8
```

```r
parse_number("99.9%")
```

```
## [1] 99.9
```

## Grouping marks
The final problem is addressed by the combination of `parse_number()` and the locale as `parse_number()` will ignore the "grouping mark":

### <mark>**EXERCISE 6 - grouping marks**</mark> {-}

A) Review the documentation for `locale()`

B) Try parsing the following strings as an appropriate number:

 1. "$123,456,789"
 1. "$123.456.789"
 1. "123'456''789" (used for example in time annotations or GPS coordinates)



--- **END EXERCISE** ---

## Parsing factors 
R uses factors to represent categorical variables that have a known set of possible values. Give `parse_factor()` a vector of known `levels` to generate a warning whenever an unexpected value is present:


```r
autobots <- c("Optimus Prime", "Perceptor", "Arcee")
parse_factor(c(
  "Optimus Prime", "Perceptor", "Arcee", "Soundwave", "Starscream" 
), levels = autobots)
```

```
## Warning: 2 parsing failures.
## row col           expected     actual
##   4  -- value in level set Soundwave 
##   5  -- value in level set Starscream
```

```
## [1] Optimus Prime Perceptor     Arcee         <NA>          <NA>         
## attr(,"problems")
## # A tibble: 2 x 4
##     row   col expected           actual    
##   <int> <int> <chr>              <chr>     
## 1     4    NA value in level set Soundwave 
## 2     5    NA value in level set Starscream
## Levels: Optimus Prime Perceptor Arcee
```

But if you have many problematic entries, it's often easier to leave as character vectors and then use the tools you'll learn about in [strings] and [factors] to clean them up.

## Dates, date-times, and times

We already saw dates and date-times in vectors \@ref(lab1bintror)

## Datetime

* `parse_datetime()` expects an ISO8601 date-time. ISO8601 is an international standard in which the components of a date are organised from biggest to smallest: 

year, month, day, hour, minute, second.
    

```r
## 7 November 1973 at 10 minutes and zero seconds past eight in the evening 
parse_datetime("1973-11-07T2010")
```

```
## [1] "1973-11-07 20:10:00 UTC"
```

```r
# If time is omitted, it will be set to midnight
parse_datetime("19731107")
```

```
## [1] "1973-11-07 UTC"
```
    
This is the most important date/time standard, and if you work with
dates and times frequently, I recommend reading
<https://en.wikipedia.org/wiki/ISO_8601>

## Date

 * `parse_date()` expects a four digit year, a `-` or `/`, the month, a `-` or `/`, then the day:
    

```r
parse_date("2010-10-01")
```

```
## [1] "2010-10-01"
```

## Time

* `parse_time()` expects the hour, `:`, minutes, optionally `:` and seconds, and an optional am/pm specifier:
  

```r
library(hms)
parse_time("01:10 am")
```

```
## 01:10:00
```

```r
parse_time("20:10:01")
```

```
## 20:10:01
```
    
## Build your own time format

The best way to figure out the correct format is to create a few examples in a character vector, and test with one of the parsing functions. For example:


```r
parse_date("01/02/15", "%m/%d/%y")
```

```
## [1] "2015-01-02"
```

```r
parse_date("01/02/15", "%d/%m/%y")
```

```
## [1] "2015-02-01"
```

```r
parse_date("01/02/15", "%y/%m/%d")
```

```
## [1] "2001-02-15"
```

### <mark>**EXERCISE 7 - Parsing a file**</mark> {-}
To parse a file succesfully, you can define the column type in the call to readr

A) Parse the file "vl5_dummy.csv"
Be sure to:

 - parse factors in the data as factors (`Group` and `Class` variable)
 - use the `cols()` function together with the `col_types = ` argument in your call
 - to appropriately parse the Date variable (the format is "year'month'day")




--- **END EXERCISE** ---

## Parsing dates is hard
People are (always) inconsistent in data-entry ;-)
Here I demonstrate what a regular expression can do to fix this. There is a inappropriate trailing `'` in the fifth observation of this data. We need to remove it

```r
## the dollar sign ($) signifies the end of a string
str_view(pattern = "\\'$", string = "14'05'17'")
```

<!--html_preserve--><div id="htmlwidget-009e07fc7e17b87e97ba" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-009e07fc7e17b87e97ba">{"x":{"html":"<ul>\n  <li>14'05'17<span class='match'>'<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
# correcting the row 5 faulty date entry
data_class <- data_class %>% 
  mutate(Date_new = 
    str_replace_all(
      pattern = "\\'$", 
      replacement = "", 
      string = Date
      )
)
data_class
```

```
## # A tibble: 6 x 7
##   Group Surname StudentID Class Score Date      Date_new
##   <fct> <chr>       <dbl> <fct> <dbl> <chr>     <chr>   
## 1 1     vip          7789 vl5a     20 17'10'07  17'10'07
## 2 1     oeps         5567 vl5a     60 18'10'07  18'10'07
## 3 1     swer         1111 vl5a      5 12'02'04  12'02'04
## 4 2     hee          7786 vl5b     10 13'12'31  13'12'31
## 5 2     soof         1112 vl5b     30 14'05'17' 14'05'17
## 6 2     lien         1253 vl5b     45 12'09'12  12'09'12
```


## Other types of data
To get other types of data into R, we recommend starting with the tidyverse packages listed below. They're certainly not perfect, but they are a good place to start. For rectangular data:

* {haven} reads SPSS, Stata, and SAS files.

* {readxl} reads excel files (both `.xls` and `.xlsx`).

* {DBI}, along with a database specific backend (e.g. __RMySQL__, __RSQLite__, __RPostgreSQL__ etc) allows you to run SQL queries against a database and return a data frame.

For hierarchical data: use __jsonlite__ (by Jeroen Ooms) for json, and __xml2__ for XML. Jenny Bryan has some excellent worked examples at <https://jennybc.github.io/purrr-tutorial/examples.html>.

For other file types, try the [R data import/export manual](https://cran.r-project.org/doc/manuals/r-release/R-data.html) and the [__rio__](https://github.com/leeper/rio) package.


### <mark>**EXERCISE 8**</mark> {-}

8A) What function-call would you use to read a file where fields were separated with  
"|"?

    

    
8B) Apart from `file`, `skip`, and `comment`, what other arguments do
    `readr::read_csv()` and `readr::read_tsv()` have in common?



8C) What are the most important arguments to `read_fwf()`?

```r
#?readr::read_fwf
```
   
8D) Sometimes strings in a CSV file contain commas. To prevent them from causing problems they need to be surrounded by a quoting character, like `"` or `'`. By convention, `read_csv()` assumes that the quoting character will be `"`, and if you want to change it you'll need to
use `read_delim()` instead. What arguments do you need to specify to read the following text into a data frame?
    

```r
x <- "x,y\n1,'a,b'"
```


    
8E) Identify what is wrong with each of the following inline CSV files. What happens when you run the code?
Write a code chunk that corrects the code:

CSV 1

```r
read_csv("a,b\n1,2,3\n4,5,6")
```

```
## Warning: 2 parsing failures.
## row col  expected    actual         file
##   1  -- 2 columns 3 columns literal data
##   2  -- 2 columns 3 columns literal data
```

```
## # A tibble: 2 x 2
##       a     b
##   <dbl> <dbl>
## 1     1     2
## 2     4     5
```




CSV 2

```r
read_csv("a,b,c\n1,2\n1,2,3,4")
```

```
## Warning: 2 parsing failures.
## row col  expected    actual         file
##   1  -- 3 columns 2 columns literal data
##   2  -- 3 columns 4 columns literal data
```

```
## # A tibble: 2 x 3
##       a     b     c
##   <dbl> <dbl> <dbl>
## 1     1     2    NA
## 2     1     2     3
```




CSV 3

```r
read_csv("a,b\n\"1")
```

```
## Warning: 2 parsing failures.
## row col                     expected    actual         file
##   1  a  closing quote at end of file           literal data
##   1  -- 2 columns                    1 columns literal data
```

```
## # A tibble: 1 x 2
##       a b    
##   <dbl> <chr>
## 1     1 <NA>
```





### <mark>**EXERCISE 9 Data types**</mark> {-}

MS Excel is still a frequently used file format: `*.xls` or the "newer" format `*.xlsx` 

9A) List three reasons why you should avoid MS Excel formats for your data

9B) Which functions and packages in R (you are allowed to google) can you use to read `xls`  or `xlsx`  files?

9C) What does `CSV` mean?

9D) What type of delimiters (to seperate columns) can be used in datafiles?  List at least 3.



## <mark>**EXERCISE 10 Loading datafiles**</mark> {-}
For this exercise we are going to load and inspect a number of files

## Loading Microsoft Office Excel files. 

10A) Loading an Excel file
 
In the `"./data"` folder of your project you wille find several example datafiles that we are going to work on during the exercises.

The first set we are going to work on is a rather simple example

"./data/Animals.xls". 

It is an Miscrosoft Excel file containing brain and body weight of a number of animals: http://mste.illinois.edu/malcz/DATA/BIOLOGY/Animals.html 

DESCRIPTION:
Average brain and body weights for 27 species of land animals.

VARIABLES:

 - body: body weight in kg
 - brain: brain weight in g 

SIZE: 

 - Observations = 27; 
 - Variables = 2

SOURCE:
Rousseeuw, P.J. & Leroy, A.M. (1987) Robust Regression and Outlier Detection. Wiley, p. 57.

Write a code chunk that loads the file `"./data/Animals.xls"` into R. 
You may use any function you like, but you are not allowed to transform the data in any way. Name the file `animals` as a datatable/dataframe/tibble in R 


**TIPs** 
 
 - You can use the `readr::readxl` function to solve this question.
 - Rember to use `library` to load the required package(s)
 - The first row that contains data is the "Mountain Beaver" observation
 - Remember that in some functions you can also set `header = FALSE`
 - The variables in this dataset need to be `animal`, `body_weigth` and `brain_weigth` and IN THAT ORDER!. These are the so-called `names` of the dataframe and can be set or checked using the function `names()`
 - Remember `dplyr::select`, `dplyr::filter()`, `dplyr::group_by`, `dplyr::summarize()`
 

```r
# tidyverse solution
# readxl::readxl solution
library(readxl)
path_to_file <- here::here("data", "Animals.xls")
animals_readxl <- readxl::read_excel(path = path_to_file, sheet = 1,
                              skip = 1, trim_ws = TRUE)
```

```
## New names:
## * `` -> ...1
## * Weight -> Weight...2
## * Weight -> Weight...3
```

```r
animals_readxl <- na.omit(animals_readxl)
animals_readxl <- animals_readxl[-1,] 



#?readxl
## something went wrong, we need to skip a line 
## the names are not correct, change if neccessary, see 2C
```





10B) Variable names.
The `names` of a dataframe can be found or set with `names(dataframe)`. Try setting the names for the `animal` dataframe to `animal`, `body_weigth` and `brain_weigth` and IN THAT ORDER. 



10C) Subsetting.
The `animals` data can be subsetted and explored by using the subsetting functions from `dplyr`.

  - Which animal has a body weight of 6654.000 kg and a brain weight of 5712.0 g?
  - Write a few lines of code that extract this information from the dataframe.



10D) Filtering.
Which animal has the smallest brain weight? 
Write code that confirms this finding  
 
 **TIPs**
 
 - Use `dplyr::filter()` and `%>%` to find the answer.
 - You can also use `min(vector, na.rm = TRUE)` to find the answer. 
 - Try to write a few lines of code that answer this question with the correct output in the `Console` 


10E) Plots; 
Create a plot that shows the realtionship between `body_weigth` and `brain_weight`. Create a dot plot, that shows this relationship.

**TIPs**
 
 - Remember `ggplot2` from the "Visualizations" class
 - Remember `geom_point()`
 - Remember `geom_smooth()`
 - Remember using `%>%` in conjunction with `ggplot()` and the `dplyr` verbs
 



10F) Removing oulier. 
On the basis of the plot above, construct a new plot that eliminates the data point for the animal "Brachiosaurus". What can you conclude from the relationship between body weigth and brain weigth, from this new plot? 



 From the plot, what can you conclude about the relationship. Are there any outliers?

10G) Data Transformation.
Plot the relationship of the full dataset (including "Brachiosaurus"), between body weight and brain weight.
Transform the body_weight variable to a log10 scale


10H) What can you conclude from the 3G plot? 
What happens to the relation between body_weigt and brain_weight if you excluse all dinosaurs ("Brachiosaurus", "Diplodocus" and "Triceratops") from the dataset?
**Write a short conclusion on this plot.**




### <mark>**EXERCISE 11 STORMS DATASET**</mark> {-}

11A) Many times data files are compressed. To uncompress a file it depends on the type of archive which function to use. Here we will try to extract the file from ".bz2" archive. This file is in "/data/storm_data_csv.bz2". You will need the package `{R.utils}` and the function from that package `bunzip2()`. Set the `remove` option to FALSE to keep the original archive. This file is big, so it can take a while to load it. 
Information on this data can be viewed in the data dictionary "./data/supporting/data_dictionary_storm_data.csv.bz2.txt"
The zipped data is in "./data/strom_data.csv.bz2"

 **TIPS** 
 - You should know that many times when a files is compressed it is big. How would you inspect the file to know what the delimeter is of the file, without reading the full file into R? Maybe use the Linux Terminal? 
 - There will be some parsing error, you can ignore those for this exercise






11B) Inspect the storm data. What types of variables are included. Think of a way to get started with a first interesting observation in a visualization. 



11C) Preprocessing the data
This dataset is rather large (almost a million datapoints). For the sake of speed we will clean up the data in the chunk below. Go over the different steps and discribe in your own words what each step does


```r
types <- unique(storm$EVTYPE) %>% 
  enframe()

## step 1.
names(storm) <- names(storm) %>% 
  tolower() 
names(storm)
```

```
##  [1] "state__"    "bgn_date"   "bgn_time"   "time_zone"  "county"    
##  [6] "countyname" "state"      "evtype"     "bgn_range"  "bgn_azi"   
## [11] "bgn_locati" "end_date"   "end_time"   "county_end" "countyendn"
## [16] "end_range"  "end_azi"    "end_locati" "length"     "width"     
## [21] "f"          "mag"        "fatalities" "injuries"   "propdmg"   
## [26] "propdmgexp" "cropdmg"    "cropdmgexp" "wfo"        "stateoffic"
## [31] "zonenames"  "latitude"   "longitude"  "latitude_e" "longitude_"
## [36] "remarks"    "refnum"
```

```r
## step 2.
storm %>%
  mutate(evtype = str_trim(evtype),                                             
         year = format(strptime(bgn_date,
         format="%m/%d/%Y %T"), format="%Y")) %>%
  select(
    state__,
    bgn_date,
    bgn_time,
    state,
    year,
    evtype,
    f,
    fatalities,
    injuries, 
    mag,
    propdmg,
    propdmgexp,
    cropdmg,
    cropdmgexp) -> storm_cleaned
```

11D) Try to answer these question from the storms data:
 
1) Which weather events were most harmful to the population health
2) Which weather events had the greatest economic consequences. 

_Harm to population health is measured in terms of injuries and fatalities, while economic consequences are measured in terms of dollar amounts._
 
**TIPs**

 - Remember ggplot's `aes(group = ...)` and/or `aes(color = ...` and `facet_wrap()`
 - This dataset is quite big, try some summarizing before plotting first





11E) Which state has the most Tornados? 


11F) Which state has the most injuries


11G) In which year was the worst Tornado with the most casualties
 Check if you graph is a close representation of the information in this [wiki](https://en.wikipedia.org/wiki/Tornado_records)




