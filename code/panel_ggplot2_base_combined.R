####
# panel with ggplot2 and base plot combined
###


library(grid)
library(ggplot2)
library(gridBase)

ggplot_example <- ggplot(data = tbl_df, aes(x = x, y = y)) +
  geom_point(colour = "darkred", size = 3) +
  geom_smooth(method = "lm", se = FALSE, formula = y ~ x, colour = "darkblue") +
  ggtitle("Regression Example") + xlab("Terms") + ylab("Response")

plot.new()
grid.newpage()
pushViewport(viewport(layout = grid.layout(1, 2)))

#Draw ggplot
pushViewport(viewport(layout.pos.col = 1))
print(ggplot_example, newpage = FALSE)
popViewport()

#Draw base plot
pushViewport(viewport(layout.pos.col = 2))
par(fig = gridFIG(), new = TRUE)
with(cars, plot(d, c, ylim=c(0,13), abline(m1), 
                main = "Regression Example",
                xlab = "Terms", ylab = "Response"))
popViewport()

