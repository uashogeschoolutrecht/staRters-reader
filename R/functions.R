## project specif functions

# all function definitions go here---->
# use Roxygen to document

#' @title Replace an arbitrary value for a true NA
#' @param x A vector of type numeric/double 
#' @param key The value that is supposed to be replaced
#' @return Returns the vector x with value == key replaced for NA
#' @export

replace_indicator_for_na <- function(x, key){
  
  x[x == key] <- NA
  
  return(x)
}


