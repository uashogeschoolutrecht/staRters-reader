#' A self-written Bootstrap function
#' @import magrittr
#' @param x A vector of type nummeric (the sample data)
#' @param iter Number of bootstrapped samples to generate
#' @param mode Which statistic do you want to return - 
#' currently implemented are "mean", "median" and "sd"

bootstrap <- function(n = NULL,
                      x = NULL, 
                      iter = NULL, 
                      mode = "mean", 
                      as_tbl = FALSE){

  boots <- function(x){
    
    s <- sample(x = x, 
                size = n, 
                replace = TRUE)
    
    if(mode == "mean"){
      boot <- mean(s)
    }
    
    if(mode == "median"){
      boot <- median(s)
    }
    
    if(mode == "raw"){
      boot <- s
    }
    
    return(boot)
    
    }
    result <- replicate(n = iter, boots(x)) 
    
    if(as_tbl == TRUE){
      return(tibble::as_tibble(result))
    }
    if(as_tbl == FALSE){
      return(result)
    }
}

