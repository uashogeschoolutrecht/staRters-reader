
plot_packages <- function(){

## install pacman for easy instalation of other packages
if(!require("pacman")) install.packages("pacman")
library(pacman)

## install other packages
p_load(zoo,
       plotly,
       tidyverse,
       rvest,
       XML,
       plotly
       )

## get packages data url
url <- "https://cran.r-project.org/web/packages/available_packages_by_date.html"

## extract data from url
page <- read_html(url)

page %>%
  html_node("table") %>%
  html_table() %>%
  mutate(count = rev(1:nrow(.))) %>%
  mutate(Date = as.Date(Date)) %>%
  mutate(Month = format(Date, format="%Y-%m")) %>%
  group_by(Month) %>%
  summarise(published = min(count)) %>%
  mutate(Date = as.Date(as.yearmon(Month))) -> pkgs

## pkgs_summary
pkgs_summary <- pkgs %>%
  mutate(
  Year = lubridate::year(Date)
  ) %>%
  arrange(desc(Year)) %>%
  group_by(Year)


#%>%
#  summarize(total_pkgs_year = sum(published)) %>%
#  dplyr::filter(Year != "2019")

## plot
plot <- pkgs_summary %>%
  ggplot(aes(x = Year, y = published)) +
  geom_point(size = 2.5, colour = "darkblue") +
  geom_line(colour = "steelblue", size = 1.5) +
  theme_bw() +
  labs(title = paste("CRAN packages published from",
                     min(pkgs_summary$Year), "to", Sys.Date())) +
  xlab("Year") +
  ylab("Total packages/year") +
  scale_x_continuous(breaks=seq(2015, 2019, 2)) +
  scale_y_continuous(labels = function(x) format(x, scientific = FALSE))

# plot

#ggsave("./images/cran_pkgs_published.png", plot = plot)
#margins = list(l = 100, r = 100, b = 100, t = 100, pad = 4)

return(plot)

}
