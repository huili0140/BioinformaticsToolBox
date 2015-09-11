#!/usr/local/R/bin/Rscript

library(DESeq)

data <- read.table("K12.refseq.ncRNA.Rin", header=TRUE, row.names=1)
conds <- factor(c("phaseE4U", "phaseE4U", "phaseE4U", "phaseE4U", "phaseE8U", "phaseE8U", "phaseE8U", "phaseE8U", "phaseS4U", "phaseS4U"))

head(data)
cds <- newCountDataSet(data, conds)
head (counts(cds))

cds <- estimateSizeFactors(cds)
sizeFactors(cds)
head(counts(cds, normalized=TRUE))

cds <- estimateDispersions(cds, fitType="local")
str(fitInfo(cds))
head(fData(cds))
res <- nbinomTest(cds, "phaseE4U", "phaseS4U")
head(res)

plotDE5 <- function(res)
 plot(
 res$baseMean, 
 res$log2FoldChange,
 log="x", pch=20, cex=.3,
 col=ifelse(res$padj<0.05, "red", "blue"))

plotDE1 <- function(res)
 plot(
 res$baseMean,
 res$log2FoldChange,
 log="x", pch=20, cex=.3,
 col=ifelse(res$padj<0.01, "red", "blue"))

plotDE5(res)
plotDE1(res)
hist(res$pval, breaks=100, col="skyblue", border="slateblue")
write.table(res, file="K12.refseq.ncRNA.phaseE.4U.phaseS.4U.deseq.result.txt")







