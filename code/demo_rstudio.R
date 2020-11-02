## demo RStudio

# string line, y = a * x + b

## on point example
## x = 0, should yield intercept with y-axis (intercept)
a <- 1
b <- 2
x <- 0

y <- (a * x) + b
y

plot(y)

## series
x <- c(0:10)
y = (a * x) + b

## plots
## base-R
plot (y ~ x)

## ggplot
tibble(
  x = x,
  y = y) %>%
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  geom_line() +
  ylim(c(0, 20)) +
  xlim(0, 10)

## function (assume we want to create multiple lines)
create_straight_line <- function(x, a, b, name){
  y <- (a * x) + b
  return(tibble(x = x, y = y, line_name = name))
}

## test function
df_test <- create_straight_line(x = c(0:10), a = 1, b = 2, name = "test")

## plot function
plot_line <- function(df){
  df %>%
    ggplot(aes(x = x, y = y)) +
    geom_point() +
    geom_line() +
    ggtitle(unique(df$line_name))
}

## test
plot_line(df = df_test)

## multiple combinations values for a
map2_df(
  .x = c(-5:5),
  .y = c(-5:5),
  .f = create_straight_line,
  b = 2,
  x = c(0:10)
) %>%
  mutate(line_name = as_factor(line_name)) %>%
  ggplot(aes(x = x, y = y)) +
  geom_point(aes(colour = line_name)) +
  geom_line(aes(colour = line_name))


## multiple combinations values for b
map2_df(
  .x = c(-5:5),
  .y = c(-5:5),
  .f = create_straight_line,
  a = 2,
  x = c(0:10)
) %>%
  mutate(line_name = as_factor(line_name)) %>%
  ggplot(aes(x = x, y = y)) +
  geom_point(aes(colour = line_name)) +
  geom_line(aes(colour = line_name))

