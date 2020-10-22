## ---- eval=FALSE---------------------------------------------------------
## ## read list of course packages:
## 
## pkgs <- read.csv(here::here("course_packages.txt"), stringsAsFactors = FALSE)
## list <- as.list(pkgs$X...list.of.course.packages)
## lapply(list, install.packages)

