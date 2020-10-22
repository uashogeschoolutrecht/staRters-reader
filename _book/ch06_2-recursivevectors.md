# Lists and dataframes {#recursivevectors}

## Packages

```r
library(tidyverse)
```

## Atomic vectors vs. recursive vectors
The R vectors above are so called `atomic vectors`. They are the 'atoms' of R, the building block of which all other objects can be build. The resulting constituated R objects that can be build from the 'atoms' are called `recursive vectors`. The molecules. With these atoms and molecules we can build really complex data objects.

## Recursive vectors
The recursive vectors are:

 * List
 * Dataframe: as special kind of list
 * Tibble: as special kind of dataframe

Below I will explain the difference

## The Dataframe
The dataframe is the most widely used data structure. If you use R for doing analysis of data, this is the datstructure that you will use the most, by far!

To understand the dataframe we can best look at a named-vector.
An object in R has a value and can have attibutes. One of the most convenient attributes is the name of each element in a vector, which is collectively called the `names` attribute


```r
named_vector_ages <- c("Sofie" = 38, "Marc" = 45, "Marie" = 1.5)
named_vector_ages
```

```
## Sofie  Marc Marie 
##  38.0  45.0   1.5
```

```r
names(named_vector_ages)
```

```
## [1] "Sofie" "Marc"  "Marie"
```

```r
attributes(named_vector_ages)
```

```
## $names
## [1] "Sofie" "Marc"  "Marie"
```

When we call the `attributes` function on our named vactor, we get the names ("Walter", "Marc") of each element of the vector.
Other attributes can be the class and the dimensions and any user-defined attributes.

**Remember "Tidy data!"**   

## Subsetting vectors
To subset vectors we can use the square brackets `[]` in R.
Some examples:

```r
numbers <- c(1:10)

## get the 1st 
numbers[1]
```

```
## [1] 1
```

```r
## get the 1st and 3rd element
numbers[c(1,3)]
```

```
## [1] 1 3
```

```r
## get the second element three times
numbers[c(2,2,2)] #or
```

```
## [1] 2 2 2
```

```r
numbers[rep(2, times = 3)]
```

```
## [1] 2 2 2
```

```r
## remove the 5th element
numbers[-5]
```

```
## [1]  1  2  3  4  6  7  8  9 10
```

```r
## you can go crazy - but expect the unexpected
numbers[c(1:3, c(1,2,(c(3))))]
```

```
## [1] 1 2 3 1 2 3
```


```r
## you can't mix positive and negative indices
numbers[c(-5,5)]
```

## The dataframe
Now that we understand the named vector we can expand this idea by creating several vectors with elements. These are then as the columns of the dataframe. One prerequisite of a `dataframe` is that all columns must have equal `length`. Individual columns of a datframe can have different data types. Remember that a vector can only contain one datatype. 

```r
## indivual vectors
age = c(24, 27, 19, 34)
sex = c("F","F","M", "M")
weight = c(64, 55, 80, 70)
given_names = c("Christa", "Suzan", "Matt", "John")

people_df <- data.frame(
  age,
  sex,
  weight,
  given_names
)

head(people_df)
```

```
##   age sex weight given_names
## 1  24   F     64     Christa
## 2  27   F     55       Suzan
## 3  19   M     80        Matt
## 4  34   M     70        John
```

## Or the 'tidyverse' way

```r
people_tbl <- tibble::tibble(
  age,
  sex,
  weight,
  given_names
)
people_tbl
```

```
## # A tibble: 4 x 4
##     age sex   weight given_names
##   <dbl> <chr>  <dbl> <chr>      
## 1    24 F         64 Christa    
## 2    27 F         55 Suzan      
## 3    19 M         80 Matt       
## 4    34 M         70 John
```

## Viewing the contents of a dataframe

```r
summary(people_df)
table(people_df)

## gives the content of the data frame
head(people_df) 			
names(people_df) 
str(people_df)

## gives the content of the variable "age" from the data frame
people_df$age 
tibble::glimpse(people_tbl)
```

## Using index on dataframes
Using the index "[]" on a dataframe is a bit tricky. The dataframe always consists of rows and columns. Indexing a dataframe goes like:

`dataframe[row number(s), column number(s)]`


```r
## first element of this vector
people_df$age[1] 	

## content of 2nd variable (column) 
people_df[,2]

## content of the 1st row
people_df[1,] 	  
                  # multiple indices
people_df[2:3, c(1,3)] # remember to use c (2nd and 3rd row, 1st and 3rd column)
```

## Lists

The dataframe and the list are the most widely used datastructures when considering experimental data. Where a dataframe is constricted to the columns having all equal length, the elements of a list can be of different length and type. This is what makes the list the most flexible and sometimes the most agonizing datastructure in R.
The elemements of a list can have names, or not. Below we create a list with named elements.

## Create a List

```r
lst <- list(
  first_names = c(male = "Fred", 
                  female = "Mary"), 
                  no.children = 3, 
                  child_ages=c(4,7,16),
  child_names = c("Suzy", 
                  "Marvin", 
                  "Jane"), 
  address = c("Pandamonium Alley 114, Chaosville"),
  marital_status = TRUE)

lst
```

```
## $first_names
##   male female 
## "Fred" "Mary" 
## 
## $no.children
## [1] 3
## 
## $child_ages
## [1]  4  7 16
## 
## $child_names
## [1] "Suzy"   "Marvin" "Jane"  
## 
## $address
## [1] "Pandamonium Alley 114, Chaosville"
## 
## $marital_status
## [1] TRUE
```

## Accessing items in a list

```r
# number of elements in the list
length(lst) 
```

```
## [1] 6
```

```r
lst[1] %>% class # 1st element of list as a list
```

```
## [1] "list"
```

```r
lst[[1]] # 1st element of List
```

```
##   male female 
## "Fred" "Mary"
```

```r
lst[[3]][2] # second item of third element
```

```
## [1] 7
```

```r
names(lst) # named elements in this list
```

```
## [1] "first_names"    "no.children"    "child_ages"     "child_names"   
## [5] "address"        "marital_status"
```

```r
lst$child_names # pull "named" elements from a list using 
```

```
## [1] "Suzy"   "Marvin" "Jane"
```

```r
lst$address
```

```
## [1] "Pandamonium Alley 114, Chaosville"
```

```r
#`$` operator
```

## `str()` also gives you the structure of a list

```r
str(lst) # display structure of lst
```

```
## List of 6
##  $ first_names   : Named chr [1:2] "Fred" "Mary"
##   ..- attr(*, "names")= chr [1:2] "male" "female"
##  $ no.children   : num 3
##  $ child_ages    : num [1:3] 4 7 16
##  $ child_names   : chr [1:3] "Suzy" "Marvin" "Jane"
##  $ address       : chr "Pandamonium Alley 114, Chaosville"
##  $ marital_status: logi TRUE
```
The new RStudio Interface also enables interactive exploration of R-objects (demo)

## Selecting single elements in a list
To select a single element from a variable in a list

```r
lst$child_ages[3] 
```

```
## [1] 16
```

```r
lst[[6]][2] # returns the value of the second element for your variable
```

```
## [1] NA
```

## Looping over lists

```r
purrr::map(lst, is.na)
```

```
## $first_names
##   male female 
##  FALSE  FALSE 
## 
## $no.children
## [1] FALSE
## 
## $child_ages
## [1] FALSE FALSE FALSE
## 
## $child_names
## [1] FALSE FALSE FALSE
## 
## $address
## [1] FALSE
## 
## $marital_status
## [1] FALSE
```

## The matrix
A matrix is a table with only numeric values. An array consists of multiple matices. Below we create a matrix. The difference between a matrix and a dataframe is that a matrix can only hold one type of data, whereas the columns of a dataframe can be of different types of data.

Here we create a numeric matrix of 100 random normals, with 20 rows and 5 columns.

```r
matrix_num <- matrix(data = rnorm(n = 100),
                 nrow = 20,
                 ncol = 5) %>%
  print()
```

```
##             [,1]        [,2]        [,3]        [,4]       [,5]
##  [1,] -1.3601494  2.54746854  0.19558101 -0.97180955 -1.5288652
##  [2,] -0.6132954 -0.29488644 -0.19106304  0.97685667 -0.1225710
##  [3,]  1.5804070  0.09499850  0.13572249 -0.03507475 -0.7211249
##  [4,]  0.1247081 -2.57150358  1.52976438 -0.01813338  1.1302598
##  [5,]  1.3094271 -0.69113914  1.17308870  2.29567803 -0.9839287
##  [6,]  1.0352320 -2.33768660  0.19237962  1.03649597 -2.0215262
##  [7,] -1.4647457  0.53467819  1.66866146  0.08297965  0.7278933
##  [8,]  0.6282886 -0.29658741 -0.13896453 -0.20832764 -0.8431092
##  [9,]  0.6710785  0.43295405  0.23367067 -0.82586047  0.1819198
## [10,] -0.2437354  0.52706236 -0.75439498 -1.05322871 -1.1406141
## [11,] -0.8224508 -0.15821356 -0.38363753  0.53556769  1.4335632
## [12,]  0.2286838 -0.02378003  0.06842753  1.03141303  1.3893755
## [13,] -0.4181425 -0.54125377 -1.42466233  0.39850255 -0.2370935
## [14,]  0.9072435  0.49242584  0.64790911  0.53650024 -0.7930855
## [15,] -0.8109155 -1.15046768  0.48100711  0.69266230  0.3885299
## [16,] -0.5422037  1.33724294 -0.62706097 -0.81447730 -1.3777712
## [17,]  0.0159730 -0.39685237  1.15218407 -0.72650442  0.9244136
## [18,] -0.5355065 -0.39633148  0.42830183 -1.10713812 -0.3518456
## [19,] -0.6838313 -0.33545111 -1.28162169  0.01847540 -1.3416773
## [20,] -0.3458875 -1.71570721  0.15129277 -0.68505920  0.2811018
```

You can put any valid R data type in a matrix, but remember, it can only hold one type of data: A matrix with CAPITALS

```r
matrix_chr <- matrix(data = (c(LETTERS, LETTERS)[1:30]),
                     nrow = 5,
                     ncol = 6) %>%
  print()
```

```
##      [,1] [,2] [,3] [,4] [,5] [,6]
## [1,] "A"  "F"  "K"  "P"  "U"  "Z" 
## [2,] "B"  "G"  "L"  "Q"  "V"  "A" 
## [3,] "C"  "H"  "M"  "R"  "W"  "B" 
## [4,] "D"  "I"  "N"  "S"  "X"  "C" 
## [5,] "E"  "J"  "O"  "T"  "Y"  "D"
```

A matrix with logicals

```r
matrix_lgl <- matrix(data = rep(c(TRUE, FALSE, TRUE), times = 20),
                     ncol = 5) %>%
  print()
```

```
##        [,1]  [,2]  [,3]  [,4]  [,5]
##  [1,]  TRUE  TRUE  TRUE  TRUE  TRUE
##  [2,] FALSE FALSE FALSE FALSE FALSE
##  [3,]  TRUE  TRUE  TRUE  TRUE  TRUE
##  [4,]  TRUE  TRUE  TRUE  TRUE  TRUE
##  [5,] FALSE FALSE FALSE FALSE FALSE
##  [6,]  TRUE  TRUE  TRUE  TRUE  TRUE
##  [7,]  TRUE  TRUE  TRUE  TRUE  TRUE
##  [8,] FALSE FALSE FALSE FALSE FALSE
##  [9,]  TRUE  TRUE  TRUE  TRUE  TRUE
## [10,]  TRUE  TRUE  TRUE  TRUE  TRUE
## [11,] FALSE FALSE FALSE FALSE FALSE
## [12,]  TRUE  TRUE  TRUE  TRUE  TRUE
```

A matrix is basically a vector, with attributes that contain it's dimensions

```r
matrix_num[1:10]
```

```
##  [1] -1.3601494 -0.6132954  1.5804070  0.1247081  1.3094271  1.0352320
##  [7] -1.4647457  0.6282886  0.6710785 -0.2437354
```

```r
attributes(matrix_num)
```

```
## $dim
## [1] 20  5
```

## Import data into R

```r
library(tidyverse)
path_to_gender_age_data <- here::here("data", "gender.txt")
gender_age <- read_delim(path_to_gender_age_data,
                         delim = "/")
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   sex = col_character(),
##   age = col_double()
## )
```

## read_csv
CSV is a format of a data file that uses commas or semicolons as separators for the columns.


```r
library(readr)
skin <- read_csv(here::here("data", "skincolumns.csv")) 
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   `Genotype A` = col_double(),
##   `Genotype B` = col_double()
## )
```

```r
skin %>% head(3)
```

```
## # A tibble: 3 x 2
##   `Genotype A` `Genotype B`
##          <dbl>        <dbl>
## 1         54.9         30.5
## 2         48.8         24.8
## 3         50.8         24.2
```

## Inspecting the skin dataframe

```r
head(skin)	 # content of the data frame
dim(skin)
attributes(skin)
summary(skin)
## ?read_csv 	 # help on the function
```

## `skin` dataset contains an NA, some functions do not work with NAs:

```r
mean(skin$`Genotype A`)
```

```
## [1] 48.22066
```

```r
mean(skin$`Genotype B`)
```

```
## [1] NA
```

```r
# to remove the NA, take care: consider leaving NAs in and use arguments like na.rm = TRUE
skin_noNA <- na.omit(skin)
mean(skin_noNA$`Genotype B`)
```

```
## [1] 25.72858
```

## Let's clean up the workspace

```r
rm(list=ls())
root <- find_root_file(criterion = is_rstudio_project)
## Note: never use this in code that is meant for others!!!
```

*_The above is an effective way to clear all the items in the Global Environment, but is is not very friendly to use this in code you share with others: can you think of why?_*

## Number notations and rounding

## Scientific notations 

```r
big_numbers <- rnorm(10, mean = 10000000, sd = 2000000)
big_numbers %>% formatC(format = "e", digits = 5)
```

```
##  [1] "1.21969e+07" "1.07730e+07" "8.86731e+06" "9.48226e+06" "9.60524e+06"
##  [6] "6.07739e+06" "1.04231e+07" "1.01798e+07" "6.18424e+06" "1.15735e+07"
```

```r
many_digits <- c(2.55858868688584848)
round(many_digits, digits = 3)
```

```
## [1] 2.559
```

```r
sqrt(many_digits * 1000 /200 * 2^6)  
```

```
## [1] 28.61378
```

## Rounding numbers

```r
small_numbers <- runif(10, min = 0.001, max = 0.1) %>% print()
```

```
##  [1] 0.065976580 0.050123522 0.051126251 0.067535135 0.004193009 0.052330324
##  [7] 0.001542476 0.095239497 0.012712700 0.029333510
```

```r
small_numbers %>% round(digits = 2)
```

```
##  [1] 0.07 0.05 0.05 0.07 0.00 0.05 0.00 0.10 0.01 0.03
```

## **EXERCISES** {-}

## 1. Load example dataset {-}

```r
library(readr)
df <- read_csv(here::here(
"data",
"simple-IO.csv"
))
```

```
## 
## -- Column specification --------------------------------------------------------
## cols(
##   x = col_character(),
##   swd1_del = col_double(),
##   msn2_del = col_double(),
##   hht1_del = col_character(),
##   mig3_del = col_double(),
##   mig2_del = col_double(),
##   rds1_del = col_double(),
##   asf1_del = col_double(),
##   swi5_del = col_double(),
##   dot1_del = col_double(),
##   sir2_del = col_double()
## )
```
 A.  What are the dimensions of the `df` dataframe?
 A.  What are the column names of `df`?
 A.  What are the data types of the different columns of `df?`


```r
dim(df)
```

```
## [1] 100  11
```

```r
ncol(df)
```

```
## [1] 11
```

```r
nrow(df)
```

```
## [1] 100
```

## 2. Inspecting a dataframe {-}

 A.  How do we inspect `df`?
 A.  How many variables does `df` have?
 A.  How many rows?
 A.  Call `summary()` on `df`; In which variable do we observe the highest expression ratio?

## 3. Vector types {-}

 A.  Run the following code 
 A.  Inspect the class of each vector
 A.  Combine vctor a to zz in a list.
 A.  Inspect the contents of this list
 A.  Review the documentation for the `map()` function from the `{purrr}` package
 A.  Using map, find the length of each element in the list you created in this exercise


```r
a <- c("a", "b", "c", NA)
b <- c(1:4)
c <- c(6:8, NA)
d <- c(1.3, 1.6, 6.7)
e <- as.integer(d)
f <- as.integer(a)
```

```
## Warning: NAs introduced by coercion
```

```r
g <- as.numeric(a)
```

```
## Warning: NAs introduced by coercion
```

```r
(z <- paste(a, b, c))
```

```
## [1] "a 1 6"   "b 2 7"   "c 3 8"   "NA 4 NA"
```

```r
(zz <- paste0(a, b, c))
```

```
## [1] "a16"   "b27"   "c38"   "NA4NA"
```

## Matrices {-}

## 4. Creating a basic matrix {-}

During these exercises, we are going to work with a matrix of 8x10 that mostly contains (randomly generated) numerical values, interspersed with some missing values.

We do this in a number of steps.

A. Create a numerical vector named v using the runif() function consisting of 80 values between -10 and 10. Review the help function for the `runif()` function


```r
set.seed(123)
v <- runif(n = 80, min = -10, max = 10)  
```

B. Assign missing values randomly to this vector using the following R code:


```r
set.seed(123)
v[sample(1:80, sample(10:20, 1))] <- NA
```

C. How many missing values do you have?

```r
sum(is.na(v))
```

```
## [1] 12
```

D. Create a matrix named m from this numerical vector that has 8 rows. Check to make sure the dimensions are OK!

**TIP: use the function matrix() to create the matrix**

```r
m <- matrix(v, nrow = 8)
m
```

```
##           [,1]       [,2]      [,3]       [,4]       [,5]      [,6]      [,7]
## [1,] -4.248450         NA -5.078245         NA  3.8141056 -7.144000 -4.680547
## [2,]  5.766103 -0.8677053 -9.158809         NA  5.9093484        NA        NA
## [3,] -1.820462  9.1366669 -3.441586  0.8813205 -9.5077263        NA -9.083377
## [4,]  7.660348 -0.9333169  9.090073  1.8828404 -0.4440806 -2.623091 -1.155999
## [5,]  8.809346  3.5514127  7.790786 -4.2168053  5.1691908 -6.951105  5.978497
## [6,] -9.088870         NA  3.856068 -7.0577271 -5.6718413 -7.223879 -7.562015
## [7,]        NA -7.9415063  2.810136  9.2604847 -3.6363798 -5.339318  1.218960
## [8,]  7.848381  7.9964994  9.885396  8.0459809 -5.3674843 -0.680751 -5.869372
##           [,8]      [,9]      [,10]
## [1,]        NA  6.292801  4.2036480
## [2,]  5.066157 -1.029673 -9.9875045
## [3,]  7.900907        NA -0.4936685
## [4,] -2.510744  6.247790 -5.5976223
## [5,]  3.302304        NA -2.4036692
## [6,] -8.103187 -1.203366  2.2554201
## [7,] -2.320607  5.089503 -2.9640418
## [8,] -4.512327  2.584423         NA
```

E. Assign row and column names

number the rows column_1:column_8 and the columns column_1:column_10
use the paste() function, set sep = "_"


```r
rownames(m) <- paste("row", 1:8, sep="_")
colnames(m) <- paste("column", 1:10, sep="_")
m
```

```
##        column_1   column_2  column_3   column_4   column_5  column_6  column_7
## row_1 -4.248450         NA -5.078245         NA  3.8141056 -7.144000 -4.680547
## row_2  5.766103 -0.8677053 -9.158809         NA  5.9093484        NA        NA
## row_3 -1.820462  9.1366669 -3.441586  0.8813205 -9.5077263        NA -9.083377
## row_4  7.660348 -0.9333169  9.090073  1.8828404 -0.4440806 -2.623091 -1.155999
## row_5  8.809346  3.5514127  7.790786 -4.2168053  5.1691908 -6.951105  5.978497
## row_6 -9.088870         NA  3.856068 -7.0577271 -5.6718413 -7.223879 -7.562015
## row_7        NA -7.9415063  2.810136  9.2604847 -3.6363798 -5.339318  1.218960
## row_8  7.848381  7.9964994  9.885396  8.0459809 -5.3674843 -0.680751 -5.869372
##        column_8  column_9  column_10
## row_1        NA  6.292801  4.2036480
## row_2  5.066157 -1.029673 -9.9875045
## row_3  7.900907        NA -0.4936685
## row_4 -2.510744  6.247790 -5.5976223
## row_5  3.302304        NA -2.4036692
## row_6 -8.103187 -1.203366  2.2554201
## row_7 -2.320607  5.089503 -2.9640418
## row_8 -4.512327  2.584423         NA
```

## 5. Select statements {-}

The next couple of exercises will take you through some of the basics of selecting data within a matrix given some criteria. These basics will come back in more real life examples during the remainder of the course.

A. From row 4 select all values greater than 3. How many are there?

**TIP:** Subsetting in dataframe or matrix also works with

`df[rows, columns]`


```r
## in two steps
ind <-  m[4,] >3
m[4, ind]
```

```
## column_1 column_3 column_9 
## 7.660348 9.090073 6.247790
```

```r
## in one go:
m[4, m[4,] >3]
```

```
## column_1 column_3 column_9 
## 7.660348 9.090073 6.247790
```

B. What is the average of these numbers?



Did you account for missing values? What happens when you have missing values within your data? Probably not. These also get selected and also affect the outcome of certain functions.

C. Do the same, but now also exclude missing values. How many values did you select now?


```r
## works
mean(m[4, m[4,] >3], na.rm = TRUE)
```

```
## [1] 7.66607
```

## 6. Storing intermediate products as index {-}

Working with implicit logical vectors easily becomes daunting when the logics are more complicated. It is usually better to then first save this vector and then use this (or in combination with another logical vector).
This also avoids mistakes during typing and reuses your code (both of which are good design principles). We are going to create a subselection of the data from rows 1, 4 and 8. To do this, first set up a vector for the rows that selects row 1, 4 and 8 and name this row_ind. Do this twice, first using a numerical vector and than using a character vector.

A. Use this vector to create a new matrix that only contains these rows. Make sure you have a good look at the data structure to ensure you have selected the correct values.

```r
## numerical
row_ind <- c(1, 4, 8)
m[row_ind,]
```

```
##        column_1   column_2  column_3 column_4   column_5  column_6  column_7
## row_1 -4.248450         NA -5.078245       NA  3.8141056 -7.144000 -4.680547
## row_4  7.660348 -0.9333169  9.090073 1.882840 -0.4440806 -2.623091 -1.155999
## row_8  7.848381  7.9964994  9.885396 8.045981 -5.3674843 -0.680751 -5.869372
##        column_8 column_9 column_10
## row_1        NA 6.292801  4.203648
## row_4 -2.510744 6.247790 -5.597622
## row_8 -4.512327 2.584423        NA
```

```r
## or via a character
row_ind <- c("row_1", "row_4", "row_8")
new_m <- m[row_ind,]
```

B. For the second row in this new matrix, select all values between -2.5 and 4, excluding missing values. How many are there and what is the average?

```r
x <- new_m[2,] 
ind_x <- x > -2.5 & x < 4 
x[ind_x]
```

```
##   column_2   column_4   column_5   column_7 
## -0.9333169  1.8828404 -0.4440806 -1.1559985
```

## 7. Data frames {-}

A. Make a `data.frame` called `blood` of the table below.  

|subject   |treatment |weight |blood pressure |cholesterol |
|:---------|:---------|:------|:--------------|:-----------|
|human1    |control   |80     |80 / 120       |20          |
|human3 	 |control   |78 	  |78 / 115       |32          |
|human4 	 |50 ng/mg  |76 	  |90 / 125       |45          |
|human5 	 |50 ng/mg  |83 	  |92 / 120       |43          |
|human6 	 |50 ng/mg  |81 	  |87 / 119       |NA          |

B. Convert this `blood` `data.frame` to a tibble.

C. Create a tibble called `combined` from the individual vectors below.

```
nr <- c(1.8, 4.5, 10.1, 8.3, 7.5)
prime <- c(seq(1, 7, 2), 11)
valid <- c(TRUE, FALSE, FALSE, TRUE, FALSE)
name <- c("abc1", "foo2", "bar3", "app5", "bar1")
```

```r
## in one go
combined <- tibble(
nr = c(1.8, 4.5, 10.1, 8.3, 7.5),
prime = c(seq(1, 7, 2), 11),
valid = c(TRUE, FALSE, FALSE, TRUE, FALSE),
name = c("abc1", "foo2", "bar3", "app5", "bar1")
)
```

D) Get the values from the `prime` column. Use at least two different ways (there are three). Calculate the root-square of the sum of these values. Use a pipe operator `%>%`

```r
## index
combined[,2]
```

```
## # A tibble: 5 x 1
##   prime
##   <dbl>
## 1     1
## 2     3
## 3     5
## 4     7
## 5    11
```

```r
## by name
combined[, "prime"]
```

```
## # A tibble: 5 x 1
##   prime
##   <dbl>
## 1     1
## 2     3
## 3     5
## 4     7
## 5    11
```

```r
## by $
x <- combined$prime %>% 
  sum() %>%
  sqrt()
```

The answer is ``5.1961524``


D. Select the second value of the `nr` column. Use at least two different ways (there are at least 4).

```r
combined$nr[2]
```

```
## [1] 4.5
```

```r
combined[2, "nr"]
```

```
## # A tibble: 1 x 1
##      nr
##   <dbl>
## 1   4.5
```

```r
combined$nr[[2]]
```

```
## [1] 4.5
```

```r
combined[2,1]
```

```
## # A tibble: 1 x 1
##      nr
##   <dbl>
## 1   4.5
```


E. Calculate the sum of the `prime` column.

```r
combined$nr %>% sum
```

```
## [1] 32.2
```

F. Combine the `nr` and `prime` columns (vectors) into a new vector.

```r
c(combined$nr, combined$prime)
```

```
##  [1]  1.8  4.5 10.1  8.3  7.5  1.0  3.0  5.0  7.0 11.0
```

## 8 Ordering {-}
The current data.frame has no particular ordering yet. In the next few exercises, we are going to reorder the data.frame based on a particular column. We can order a dataframe by variable by using the order() function

An example to order the mydata dataframe by name

```
mydata <- mydata[order(mydata$name), ]
mydata
```

This statement can be read as "order all variables (columns) of the dataframe by the rows of he variable 'name' in decreasing order". In this case name is a character vector, and order will order the variable according alphabetical order.

You can also order dataframes (or so-called tibbles) with dplyr. We will see how this works with the arrange() function later in the course.

Use this dataframe for the follwing exercises

id| nr   |name    |characters|valid
--|------|--------|----------|-------
1 | 1.8  |     1  |abc1      |TRUE
4 | 8.3  |     7  |app5      |TRUE
5 | 7.5  |     11 |bar1      |FALSE
3 | 10.1 |     5  |bar3      |FALSE
2 | 4.5  |     3  |foo2      |FALSE

A) Order the data.frame based on the `nr` column in increasing order.

```r
combined[order(combined$nr), ]
```

```
## # A tibble: 5 x 4
##      nr prime valid name 
##   <dbl> <dbl> <lgl> <chr>
## 1   1.8     1 TRUE  abc1 
## 2   4.5     3 FALSE foo2 
## 3   7.5    11 FALSE bar1 
## 4   8.3     7 TRUE  app5 
## 5  10.1     5 FALSE bar3
```

B) Order the data.frame alphabetically using the `character` column.

```r
combined[order(combined$name), ]
```

```
## # A tibble: 5 x 4
##      nr prime valid name 
##   <dbl> <dbl> <lgl> <chr>
## 1   1.8     1 TRUE  abc1 
## 2   8.3     7 TRUE  app5 
## 3   7.5    11 FALSE bar1 
## 4  10.1     5 FALSE bar3 
## 5   4.5     3 FALSE foo2
```

C) Order the data.frame based on the `nr` column in decreasing order.

```r
combined[order(combined$prime, decreasing = TRUE), ]
```

```
## # A tibble: 5 x 4
##      nr prime valid name 
##   <dbl> <dbl> <lgl> <chr>
## 1   7.5    11 FALSE bar1 
## 2   8.3     7 TRUE  app5 
## 3  10.1     5 FALSE bar3 
## 4   4.5     3 FALSE foo2 
## 5   1.8     1 TRUE  abc1
```

D) What happens if you use the `valid` column for ordering? Can you explain this?

```r
combined[order(combined$valid), ]
```

```
## # A tibble: 5 x 4
##      nr prime valid name 
##   <dbl> <dbl> <lgl> <chr>
## 1   4.5     3 FALSE foo2 
## 2  10.1     5 FALSE bar3 
## 3   7.5    11 FALSE bar1 
## 4   1.8     1 TRUE  abc1 
## 5   8.3     7 TRUE  app5
```

```r
## FALSE can also be written as 0, TRUE as 1 in binary notation
```


