#!/usr/local/R/bin/Rscript
args <- commandArgs(TRUE)
inDf <- read.table("perBase.txt", header=FALSE, row.names=1)
cols <- ncol(inDf)
rows <- nrow(inDf)
motifLength <- as.numeric(args[1])
#
# (C+1)(1/L + 1/R)
#
# C = cleavage sum of motif
# L = cleavage sum over left-flanking region
# R = cleavage sum over right-flanking region
#
# FDS is sorted in ascending order: smaller FDS scores highlight rows
# with a greater difference between motif and flanking regions. To avoid
# divide-by-zero errors, if L and/or R are zero (i.e. no cleavages) these
# go to the bottom of the sort.
#

modDf <- inDf
modDf["score"] <- 0

lMotifLength <- floor(motifLength/2)
rMotifLength <- motifLength - lMotifLength
midpointIdx <- floor(cols/2)

# define ranges for C, L and R elements

lMotifOffsetIdx <- midpointIdx - lMotifLength
rMotifOffsetIdx <- lMotifOffsetIdx + motifLength
lFlankEndIdx <- lMotifOffsetIdx - 1
lFlankStartIdx <- lFlankEndIdx - motifLength
rFlankStartIdx <- rMotifOffsetIdx + 1
rFlankEndIdx <- rFlankStartIdx + motifLength

for (idx in 1:nrow(inDf)) {
    row <- inDf[idx,]
    C <- sum(row[lMotifOffsetIdx:rMotifOffsetIdx])
    L <- sum(row[lFlankStartIdx:lFlankEndIdx])
    R <- sum(row[rFlankStartIdx:rFlankEndIdx])
    pseudoFds <- if ((L == 0) && (R == 0)) .Machine$integer.max else (C+1) * (1/L + 1/R)
    modDf$score[idx] = pseudoFds
}

sortDf <- inDf[with(modDf, order(score)), ]
write.table(file="perBase.sorted.txt", sortDf, sep="\t", row.names=FALSE, col.names=FALSE)

