## list columns

info <- list(vl5M = c(1:40),
             vl5D = c(1:25),
             vl5B = c(1:16)
)

names(info)

info[1]
year <- c(rep("2016",3)) 

students <- tibble(info, year)
students)
