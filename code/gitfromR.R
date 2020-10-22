### Change Github Settings or Run Git commands from R
library(devtools)
devtools::install_github("uashogeschoolutrecht/gitr")

## add Git email and user.name to RStudio
library(gitr)
set_git_user(email = "marc.teunis@hu.nl",
             username = "maddocent")
