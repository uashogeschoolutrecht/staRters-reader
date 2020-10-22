
## add Git credentials to RStudio

devtools::install_github("uashogeschoolutrecht/gitr")
library(gitr)

## Set Github.com email and user name in RStudio
gitr::set_git_user(email = "Your.Github.com.email-address", 
                   username = "Your.Github.com.username")

