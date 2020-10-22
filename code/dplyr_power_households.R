
## ---- Packages-----------------------------------------------------------
# install.packages("downloader")
# install.packages("dplyr")
# install.packages("lubridate")
# install.packages("ggplot2")
# install.packages("gridExtra")
# install.packages("cowplot")

## loading the packages
library(rmarkdown)
library(downloader)
library(dplyr)
library(lubridate)
library(ggplot2)
library(grid)
library(gridExtra)
library(cowplot)
library(tidyverse)


## ---- DownloadingData----------------------------------------------------
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download(url, dest="project_dataset.zip", mode="wb") 
unzip("project_dataset.zip", exdir = "./data")

## ---- ReadingDataSet-----------------------------------------------------
## for help:
# ??read.table
data <- read_csv2(file = "./data/household_power_consumption.txt", 
                   sep = ";", header = TRUE, na.strings = "?")
data <- as_tibble(data)
## ---- SelectingCases-----------------------------------------------------
str(data)
tail(data)
## names to lower
names(data) <- tolower(names(data))
names(data)

data$date <- as.character(data$date)
head(data)
data_selected_1 <- data %>% filter(date == "1/2/2007")
data_selected_2 <- data %>% filter(date == "2/2/2007")

data_twoDays <- rbind(data_selected_1,data_selected_2)
head(data_twoDays)
tail(data_twoDays)

## ------------------------------------------------------------------------
# converting to "character"
data_twoDays$date <- as.character(data_twoDays$date)
data_twoDays$time <- as.character(data_twoDays$time)

# pasting date time together to be able to create a 
# "POSIXlt" class variable 
data_twoDays$date_time <- paste(data_twoDays$date,
                                data_twoDays$time,
                                sep = " ")
head(data_twoDays)

# converting $date_time to class "POSIXlt"
data_twoDays$date_time <- strptime(data_twoDays$date_time,
                                 "%d/%m/%Y %H:%M:%S")

# inspecting the just created variable "data_twoDays$date_time"
date_time_var <- data_twoDays$date_time
head(date_time_var)
typeof(date_time_var)


# The POSIXlt data type is a vector, and the entries in the vector have 
# the following meanings:
# [[1]] seconds
# [[2]] minutes
# [[3]] hours
# [[4]] day of month (1-31)
# [[5]] month of the year (0-11)
# [[6]] years since 1900
# [[7]] day of the week (0-6 where 0 represents Sunday)
# [[8]] day of the year (0-365)
# [[9]] Daylight savings indicator (positive if it is daylight 
#       savings)

## Question what day of the week is 1/2/2007?
date_time_var[1][[7]]

## the answer is four
## making a look-up table df
days_of_the_week <- c("Sunday", "Monday", "Thuesday", "Wednesday",
                    "Thursday", "Friday", "Saturday")
POSIXlt_code <- c(0:6)

dow_df <- cbind(days_of_the_week, POSIXlt_code)
dow_df <- as.data.frame(dow_df)
names(dow_df)
which_day <- dow_df %>% filter(POSIXlt_code == 4)

## The final answer:
which_day[1]


## ---- Plot1-------------------------------------------------------------

head(data_twoDays)

