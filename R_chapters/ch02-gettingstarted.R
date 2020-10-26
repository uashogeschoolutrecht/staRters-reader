## ---- message=FALSE, error=FALSE, warning=FALSE---------------------------------------------------------
library(tidyverse)


## ---- eval = FALSE--------------------------------------------------------------------------------------
## devtools::install_github("uashogeschoolutrecht/gitr")
## ## use this to set your user name and email (you can make a dummy name,
## ## you do not need a github account)
## gitr::set_git_user(username = "some_username", email = "some_email_address")


## ---- include=FALSE-------------------------------------------------------------------------------------
urls <- read_csv(
        here::here(
                "urls"
        )
)

urls[3,1] %>% as.character() 


## ---- eval = FALSE, echo=TRUE, results='asis'-----------------------------------------------------------
## setRepositories(graphics=TRUE)


## ---- eval=FALSE, echo=TRUE-----------------------------------------------------------------------------
## install.packages("beanplot")


## ---- echo=TRUE, fig.show='asis', results='asis'--------------------------------------------------------
library(beanplot)
beanplot(runif(100))

