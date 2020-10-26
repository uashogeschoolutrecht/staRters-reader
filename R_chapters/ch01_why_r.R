## ---- warning=FALSE, error=FALSE, message=FALSE---------------------------------------------------------
library(tidyverse)
library(nlme)


## ---- dpi = 80------------------------------------------------------------------------------------------
knitr::include_graphics(
  here::here(
    "images",
    "gollum_climbing.jpg"
  )
)


## ---- dpi = 80------------------------------------------------------------------------------------------
knitr::include_graphics(
  here::here(
    "images",
    "messy_steps.jpg"
  )
)


## -------------------------------------------------------------------------------------------------------
knitr::include_graphics(here::here("images","rmd_printscr.png"))


## ---- echo=TRUE-----------------------------------------------------------------------------------------
library(nlme)
ergoStool %>% as_tibble()


## -------------------------------------------------------------------------------------------------------
set.seed(123)
plot_ergo <- ergoStool %>%
  ggplot(aes(x = reorder(Type, effort), y = effort)) + 
  geom_boxplot(colour = "darkgreen", outlier.shape = NA) + 
  geom_jitter(aes(colour = reorder(Subject, -effort)), 
              width = 0.2, size = 3) +
  scale_colour_manual(values = c("red","blue", "green", "darkblue", "darkgreen", "purple", "grey", "black", "darkgrey")) +
  ylab("Effort (Borg scale score)") +
  xlab("Chair type") + 
  guides(colour=guide_legend(title="Subject id")) +
  theme_bw()
plot_ergo


## ---- fig.width=5, fig.height=3-------------------------------------------------------------------------
plot_ergo


## ---- echo=TRUE, eval=FALSE-----------------------------------------------------------------------------
## library(nlme)

## ---- echo=TRUE-----------------------------------------------------------------------------------------
ergo_model <- lme(
  data = ergoStool, # the data to be used for the model
  fixed = effort ~ Type, # the dependent and fixed effects variables
  random = ~1 | Subject # random intercepts for Subject variable
)


## -------------------------------------------------------------------------------------------------------
result <- ergo_model %>% summary() 
result$tTable %>% as.data.frame() %>% knitr::kable()


## ---- echo=TRUE-----------------------------------------------------------------------------------------
plot(ergo_model) ## type = 'pearson' (standardized residuals)


## -------------------------------------------------------------------------------------------------------
# install.packages("ggsignif")
library(ggsignif)
p_values <- result$tTable %>% as.data.frame()
annotation_df <- data.frame(Type=c("T1", "T2"), 
                            start=c("T1", "T1"), 
                            end=c("T2", "T3"),
                            y=c(16, 14),
                            label=
                              paste("p-value:",
                              c(
                              formatC(
                                p_values$`p-value`[2], digits = 3),
                              formatC(
                                p_values$`p-value`[3], digits = 3)
                              )
                            )
                          )
                            
set.seed(123)
ergoStool %>%
  ggplot(aes(x = reorder(Type, effort), 
             y = effort)) + 
  geom_boxplot(colour = "darkgreen", 
               outlier.shape = NA) + 
  geom_jitter(aes(
    colour = reorder(Subject, -effort)), 
    width = 0.2, 
    size = 3) +
  scale_colour_manual(
    values = c(
      "red", "blue","green", 
      "darkblue", "darkgreen", 
      "purple", "grey", "black", 
      "darkgrey")) +
  ylab("Effort (Borg scale score)") +
  xlab("Chair type") + 
  guides(colour=guide_legend(title="Subject id")) +
  ylim(c(4,20)) +
  geom_signif(
    data=annotation_df,
    aes(xmin=start, 
    xmax=end, 
    annotations=label, 
    y_position=y),
    textsize = 5, vjust = -0.2,
    manual=TRUE) +
  theme_bw() -> plot_ergo
plot_ergo

