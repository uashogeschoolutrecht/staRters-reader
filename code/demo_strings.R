## Strings demo

## defining special characters and explain escaping

literal_qoute <- c("\"")
literal_qoute
writeLines(literal_qoute)

literal_back_slash <- c("\\")
literal_back_slash
writeLines(literal_back_slash)

## tab
tab <- c("A\tB")
tab_escaped <- c("A\\tB")
writeLines(tab)
writeLines(tab_escaped)

## symbols
pi <- c("\u00b5")
writeLines(pi)

