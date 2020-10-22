## ------------------------------------------------------------------------
library(tidyverse)


## ---- eval=FALSE---------------------------------------------------------
## df$var_a[df$var_a ==  999] <- NA
## df$var_b[df$var_b == -999] <- NA
## df$var_h[df$var_h == -999] <- NA
## df$var_i[df$var_j == -989] <- NA
## df$var_j[df$var_j == -999] <- NA
## df$var_o[df$var_n == -988] <- "NA"
## ## there are at least 5 errors in this code


## ------------------------------------------------------------------------
df <- tibble(a = c(1:9, -999), 
             b = c(1:5, -999, -999, 8:10),
             c = LETTERS[1:10])
df


## ------------------------------------------------------------------------
replace_x_for_na <- function(x){
  
  x[x == -999] <- NA
  return(x)
}


## ------------------------------------------------------------------------
df$a
replace_x_for_na(df$a)


## ------------------------------------------------------------------------
df_new <- purrr::modify_if(df, is.numeric, replace_x_for_na)
df_new

## or using the pipe %>%
df_new_pipe <- df %>%
  purrr::modify_if(is.numeric, replace_x_for_na) 
df_new_pipe

