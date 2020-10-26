## ---- message=FALSE, error=FALSE, warning=FALSE---------------------------------------------------------
library(tidyverse)


## -------------------------------------------------------------------------------------------------------
## for setting the random number generator - to increase reproducibility
## to get help
# ?rnorm
set.seed(1234)
normals <- rnorm(n = 1000, mean = 5, sd = 1.36)
normals_2 <- rnorm(1000, mean = 1.5, sd = 1.42)

df <- tibble(A = normals,
             B = normals_2)

df
## change number of observations to 10000 and rerun


## -------------------------------------------------------------------------------------------------------
df %>% ## pipe `%>%` takes a value an puts it in a function
  pivot_longer(A:B, names_to = "distro", values_to = "value") %>%
  ggplot(aes(x = value)) +
  geom_density(aes(colour = distro), size = 2)


## change the `bins` argument to see what happens


## -------------------------------------------------------------------------------------------------------
t.test(df$A, df$B) 


## -------------------------------------------------------------------------------------------------------
read_csv("1,3;2,4;3\n4,7;5,6;6,8", col_names = FALSE) ## does not parse the right way
read_csv2("1,3;2,4;3\n4,7;5,6;6,8", col_names = FALSE) ## does the job 



## ---- echo=FALSE----------------------------------------------------------------------------------------
knitr::include_graphics(path = here::here(
        "images",
        "tidyverse_sticker.png"))


## -------------------------------------------------------------------------------------------------------
# install.packages("tidyverse")
library(tidyverse)


## ---- eval=FALSE----------------------------------------------------------------------------------------
## ## installing `{affy}` package
## BiocManager::install("affy")
## biocLite("affy")
## 
## ## loading affy package and the vignettes pages of this package
## # library(affy)
## # browseVignettes("affy")


## ---- eval=FALSE----------------------------------------------------------------------------------------
## #install.packages("dplyr")
## library(dplyr)
## library(ggplot2)
## ?dplyr
## ?ggplot2
## ?mean
## ?mean  # goes to the page with functions related to '.mean.'
## apropos("mean") # search on more options of or alternatives for a certain function
## formals(dplyr::filter)


## ---- eval=FALSE----------------------------------------------------------------------------------------
## example(mean) # to see a worked example
## demo(graphics) # demonstration of R functions


## ---- error=FALSE, message=FALSE, warning=FALSE---------------------------------------------------------
seed <- c(1:4)
set.seed(seed = seed) 
q <- rnorm(n = 10000, mean = 20, sd = 2)
hist(q)


## -------------------------------------------------------------------------------------------------------
set.seed(seed)
qq <- rnorm(10000, 20, 2)
all(q == qq)


## ---- echo=FALSE----------------------------------------------------------------------------------------
source(here::here("code", "render_help_to_console.R"))
x <- help_console(mean)


## -------------------------------------------------------------------------------------------------------
x <- c(1:10)
x


## -------------------------------------------------------------------------------------------------------
mean(x)


## -------------------------------------------------------------------------------------------------------
mean(x, trim = 0.2)

## manual - compute mean over 2nd - 9th element of x
mean(x[2:9])




## -------------------------------------------------------------------------------------------------------
x[c(3,6)] = NA
x


## -------------------------------------------------------------------------------------------------------
mean(x)


## -------------------------------------------------------------------------------------------------------
mean(x, na.rm = TRUE)


## -------------------------------------------------------------------------------------------------------
# Examples from the documentation for the mean() function:

x <- c(0:10, 50)
xm <- mean(x)
c(xm, mean(x, trim = 0.10))
     


## ---- fig.cap="Elementary building blocks in R"---------------------------------------------------------
DiagrammeR::grViz("
digraph rmarkdown {
  'Vector' -> 'Atomic'
  'Vector' -> 'Recursive vectors' -> List -> 'Data frame'
  'NULL'
}
", engine = "circo")


## ---- fig.cap="All important R objects in one graph"----------------------------------------------------
DiagrammeR::grViz("
digraph rmarkdown {
  'R object' -> 'Atomic vectors'
  'R object' -> 'Recursive vectors'
  'Atomic vectors' -> 'Numeric'
  'Atomic vectors' -> 'Logical'
  'Logical' -> 'TRUE'
  'Logical' -> 'FALSE'
  'Logical' -> 'NA'
  'Atomic vectors' -> 'Character'
  'Numeric' -> 'Integer'
  'Numeric' -> 'Double'
  'Numeric' -> 'Inf'
  'Numeric' -> '-Inf'
  'Numeric' -> 'NaN'
  'Recursive vectors' -> List
  'List' -> 'Data frame'
  'Data frame' -> Tibble 
  'Double' -> 'Date [S3]'
  'Double' -> 'Date-Time [S3]'
  'Integer' -> 'Factor [S3]'
}
", engine = "circo")
## for graph'n with DiagrammeR: http://rich-iannone.github.io/DiagrammeR/index.html


## -------------------------------------------------------------------------------------------------------
double_x <- 5.4 # using the `<-` assign function to create an numeric object
class(double_x) # the class = "nummeric"
typeof(double_x) # the vector type
is.numeric(double_x)


## -------------------------------------------------------------------------------------------------------
integer_x <- 5L ## integer vector
class(integer_x)
typeof(integer_x)
is.numeric(integer_x)
is.double(integer_x)

# integer and double are both called 'numeric'


## -------------------------------------------------------------------------------------------------------
logical_x <- c(TRUE, FALSE, NA) ## logical vector
class(logical_x)
typeof(logical_x)
is.logical(logical_x)


## -------------------------------------------------------------------------------------------------------
## assume 'Dutch' format (dd-mm-yyyy)
date_x <- lubridate::as_datetime(
  "02/05/1990",   
  tz = "Europe/Amsterdam", # time-zone 
  format = "%d/%m/%y") # format in which the date is provided

date_x

class(date_x)
typeof(date_x)
is.recursive(date_x)

date_time_x <- lubridate::dmy_hms("02/05/1990 22:13:50",  
                                  ## date-time class
                                  tz = "Europe/Amsterdam")
class(date_time_x)
typeof(date_time_x)

is.recursive(date_time_x)


## -------------------------------------------------------------------------------------------------------
string_x <- "Hello there, are you still with me?" ## character vector
class(string_x)
typeof(string_x)
is.numeric(string_x)

## combining strings
string_combined <- c(
string_x, "Or do you feel like the sky will come crashing down on you?") %>% 
  print()

print("Anyway, I think it is time for a coffee break!!")



## -------------------------------------------------------------------------------------------------------
na_x <- NA ## missing value
class(na_x)
typeof(na_x)

null <- NULL ## empty value
class(null)


infinite <- 1/0 ## infinite number
class(infinite)

minus_infinite <- -1/0 ## minus infinite
not_a_number <- 0/0 ## not a number



## -------------------------------------------------------------------------------------------------------
months_var <- c("Dec", "Apr", "Jam", "Mar")



## -------------------------------------------------------------------------------------------------------
months_var
sort(months_var)


## -------------------------------------------------------------------------------------------------------
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)


## -------------------------------------------------------------------------------------------------------
months_var_valid <- factor(months_var, levels = month_levels)
months_var_valid

sort(months_var_valid)


## -------------------------------------------------------------------------------------------------------
tribble(
  ~ "name", ~"age", ~"sex", ~"bmi",
    "Jan",   23,     "Male", 34,
    "John",  34,     "M",    21,
    "Sue",   56,     "F",    28,
    "Kyra",  34,     "F",    21
  
) -> bmi

bmi$sex <- factor(bmi$sex, levels = c("F", "M"))

bmi

## or visually
bmi %>%
  ggplot(aes(x = sex, y = bmi)) +
  geom_point(aes(colour = sex))
  

## better:
## inspect levels of intended factor first
tribble(
  ~ "name", ~"age", ~"sex", ~"bmi",
    "Jan",   23,     "Male", 31,
    "John",  34,     "M",    28,
    "Sue",   56,     "F",    25,
    "Kyra",  34,     "F",    21
  
) -> bmi_better

unique(bmi_better$sex)

## or visually
bmi_better %>%
  ggplot(aes(x = sex, y = bmi)) +
  geom_point(aes(colour = sex))

## fix levels of intended factor with {dplyr} and {forcats}
bmi_better %>%
  dplyr::mutate(sex_new = forcats::fct_collapse(
    sex, 
    Male = c("Male", "M"),
    Female = c("F"))) %>%
  ggplot2::ggplot(aes(x = sex_new, y = bmi)) +
  ggplot2::geom_point(aes(colour = sex_new))
  



## ---- mixed---------------------------------------------------------------------------------------------
vector <- c(1:10, NA, NA, NA,  3, "Python is great!", "R is greater!")
vector
is.character(vector)


## -------------------------------------------------------------------------------------------------------
vector_with_true_NAs <- c(TRUE, NA, FALSE, NA, FALSE)

## how many NA
is.na(vector_with_true_NAs) 
sum(is.na(vector_with_true_NAs))


## ---- error=TRUE----------------------------------------------------------------------------------------
## Error sum on character
sum(vector) 


## -------------------------------------------------------------------------------------------------------
a <- c(1,3,5,7,9)
b <- c(2,4,6,8)

z1 <- a - b
z1

z2 <- b - a
z2
z3 <- a / b
z3


## -------------------------------------------------------------------------------------------------------
z4 <- sum(a)
z4
z5 <- max(a) - max(b)
z5


## -------------------------------------------------------------------------------------------------------
jedi <- rep("Luke", times = 10)
midichlorians <- rep("Force", length.out = 20)
I_am_your_Father <- c(
  paste(jedi, 
        paste("Use the", midichlorians), sep = ", ")
  ) %>% 
  rep(each = 3)

I_am_your_Father

## simple
rep(10, times = 2)
rep(c(10, 20), each = 2)
rep(c(10, 20), times = 2)
rep(c(10, 20), times = 2, each = 2)
rep(c(10, 20), each = 2, times = 2) ## same as previous
seq(from = 1, to = 4, length.out = 4)
seq(from = 1, to = 4, length.out = 8)
seq(from = 0, to = 4, length.out = 10)



## -------------------------------------------------------------------------------------------------------
set.seed(123)
hundred <- rnorm(100)
## I use the head function to get the first few values
head(hundred)


## -------------------------------------------------------------------------------------------------------
hundred[1]
hundred[c(1:10)]


## -------------------------------------------------------------------------------------------------------
hundred %>%
  enframe() %>%
  ggplot(aes(x = value)) +
  geom_density()


## -------------------------------------------------------------------------------------------------------
logical_smaller_than_zero <- hundred > 0
logical_smaller_than_zero[c(1:10)]


## -------------------------------------------------------------------------------------------------------
larger_than_zero_values <- hundred[logical_smaller_than_zero]
## again we ask for the first ten elements of our new >0 vector
larger_than_zero_values[c(1:10)]


## -------------------------------------------------------------------------------------------------------
larger_than_zero_values %>%
  enframe() %>%
  ggplot(aes(x = value)) +
  geom_density()

## or a scatter
larger_than_zero_values %>%
  enframe() %>%
  ggplot(aes(x = value, y = name)) +
  geom_point()


## -------------------------------------------------------------------------------------------------------
df <- larger_than_zero_values %>%
  enframe() 
## the `name` variable is equal to the position of the >0 vector  
df %>%  ggplot(aes(x = value, y = name)) +
  geom_point() +
  ## we add an additional geom_point for the data filtered for name == 40
  geom_point(data = df %>% dplyr::filter(name == 40),
             aes(x = value, y = name),
             fill = "red", 
             size = 4, 
             shape = 21, 
             alpha = 0.6)


## -------------------------------------------------------------------------------------------------------
## you see a value that is close to zero, but not equal to zero.
larger_than_zero_values[40]


## ---- include=FALSE-------------------------------------------------------------------------------------
options_exercises <- knitr::opts_chunk$set(echo = FALSE,
                          warning = FALSE,
                          error = FALSE,
                          message = FALSE,
                          results = 'hide',
                          fig.show = 'hide')


## ---- results='markup', echo=TRUE-----------------------------------------------------------------------
library(tidyverse)


## ---- echo=TRUE-----------------------------------------------------------------------------------------
set.seed(123)
vec_1 <- rnorm(10)
vec_2 <- as.integer(vec_1)
vec_3 <- c(rep(TRUE, 3), c(rep(FALSE, 4)), NA)
vec_4 <- as.numeric(vec_3)
vec_5 <- c("Marc", "Ronald", "Maarten")


## ---- answers_1-----------------------------------------------------------------------------------------
## convert to integer
as.integer(vec_1)
## convert to numeric
as.numeric(vec_3)
vec_2
vec_3
vec_4
class(vec_1)
class(vec_5)
## coercion of integer to double integer 1. Notice that integers are rounded as x.00000000...
vec_6 <- c(vec_1, vec_2) 
typeof(vec_6)
vec_6
## corcion to character (no other option: Marc, Ronald Maarten cannot be coerced into numeric)
vec_7 <- c(vec_4, vec_5)
vec_7


## ---- answer_2------------------------------------------------------------------------------------------
sum(3, 12, 250)
4902 - 3987
2^24
240/14
mean(c(12, 20))
## or
(12 + 20)
mean(c(10.8, 13.7, 15.9))


## -------------------------------------------------------------------------------------------------------
vec_8 <- c(10.5, 20.4, 30.5, 28.9, 5.4)
vec_9 <- c(50:-10)
vec_10 <- seq(-10, 50, 2)
vec_11 <- c(vec_10, 5)
vec_12 <- rep(c(0, 1), 500)
set.seed(123)
vec_13 <- runif(100, min= -1, max= 1)
vec_14 <- rnorm(100, mean = 2, sd = 0.3)
hist(vec_13)
hist(vec_14)
mean(vec_14)
vec_14[5] <- NA
vec_14[c(3:6)]
mean(vec_14, na.rm = TRUE)


## -------------------------------------------------------------------------------------------------------
matrix_1 <- matrix(1:12, nrow=3, byrow=TRUE)
matrix_1
matrix_2 <- matrix(rep(c(1, 2, 3, 4), 3), nrow=3, byrow=TRUE)
matrix_2
sum(matrix_1)


## ---- eval=FALSE----------------------------------------------------------------------------------------
## numbers <- c(1.8, 4.5, 10.1, 8.3)
## prime <- c(1, 3, 5, 7, 11)
## crazy <- c("abc1", "foo2", "bar3", "app5", "yepp7")
## valid <- c(TRUE, FALSE, FALSE, TRUE, FALSE)
## mylist <- (list(numbers,
##             prime,
##             crazy,
##             valid
##             ))
## mylist
## # Not all vectors are of equal length.
## mydata <- tibble(numbers, prime, crazy, valid)
## numbers <- c(numbers, NA)
## mydata <- tibble(numbers, prime, crazy, valid)
## ## CHANGE COLUMN HEADERS IN A, B, C, D
## names(mydata) <- LETTERS[1:4]
## mydata
## # You get an error, something like "only defined ..."
## # on data frame with all #numerical variables"
## sum(mydata)
## str(mydata)
## #The variable "C" is actually a factor, change the type of this variable to a factor
## mydata$C <- as.factor(mydata$C)
## levels(mydata$C)
## mydata

