## ?write.csv

rNames <- c("geneA", "geneB", "geneC")
write.csv(rNames, "rNames.txt")

cNames <- c("varA", "varB", "varC", "varD")
write.csv(cNames, "cNames.txt")

rows <- read.csv("rNames.txt", header = TRUE, row.names = 2)
columns <- read.csv("cNames.txt", header = TRUE, row.names = 2)

rows
columns

#row_names_m <- rows[,2]
#column_names_m <- columns[,2]

m <- matrix(rnorm(12, mean = 1.23, sd = 0.3), nrow = 3, ncol = 4)
m

rownames(m) <- c(rownames(rows))
colnames(m) <- c(rownames(columns))
m

m <- as.data.frame(m)
m


seq <- c("AAACCCGGCGCGCT.TTT
