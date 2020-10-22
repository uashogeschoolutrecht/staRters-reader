set.seed(0)
x <- rnorm(1000)

d <- density.default(x, n = 512, cut = 3)
str(d)

plot(d); abline(v = 1, col = 2)

xx <- d$x  ## 512 evenly spaced points on [min(x) - 3 * d$bw, max(x) + 3 * d$bw]
dx <- xx[2L] - xx[1L]  ## spacing / bin size
yy <- d$y  ## 512 density values for `xx`

C <- sum(yy) * dx  ## sum(yy * dx)
C
