#' @title Get dependcencies from an Rmd or list of Rmd files
#' @param path Character vector pointing to a path or list of paths
#' @param install Logical, defaults to FALSE, if set to TRUE,
#' @param type
#' dependencies that are not part of the base R installation will be attempted to be installed
#' @return A df_tbl object with information  on the dependencies found


get_dependencies <- function(path = NULL, install = FALSE, type = "Rmd"){


  if(type == "Rmd"){

    files_list <- list.files(
      path = path,
      pattern = "Rmd",
      full.names = TRUE
      )
 }

  dependencies <- map(files_list, requirements:::req_file)


  return(dependencies)


}





