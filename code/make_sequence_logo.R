## Workflow to create senquence logo's in R


https://davetang.org/muse/2013/01/30/sequence-logos-with-r/ 
  
library(Biostrings)  
# Create position weight matrix

## Example sequences
sequences <- c("GCCAAAAAAA",
               "CGCAAAAAAA",
               "TCATAAAAAC",
               "GCATTAAAAA",
               "TCGTAAAAAC")
               
?consensusMatrix

sequences <- DNAStringSet(sequences)
cmx <- consensusMatrix(sequences)
cmx

hasOnlyBaseLetters(sequences)

clean_cmx <- alphabetFrequency(sequences, baseOnly=TRUE)
               
#install if necessary
#source("http://bioconductor.org/biocLite.R")
#biocLite("seqLogo")

library(seqLogo)

#create data frame using the four vectors

#define function that divides the frequency by the row sum i.e. proportions
proportion <- function(x){
  rs <- sum(x);
  return(x / rs);
}



#create position weight matrix
clean_cmx <- t(clean_cmx)
clean_cmx <- as.data.frame(clean_cmx[c(1:4),])
clean_cmx

pwm <- apply(clean_cmx, 2, proportion)
pwm
pwm <- makePWM(pwm)

png("hunchback.png")
seqLogo(pwm)
dev.off()

