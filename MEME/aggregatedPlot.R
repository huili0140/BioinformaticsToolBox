#!/usr/local/R/bin/Rscript

posfile <- read.table("perBase.Pos.txt", header=FALSE)
negfile <- read.table("perBase.Neg.txt", header=FALSE)
#conservfile <- read.table("conserv.txt",header=FALSE)
#covdensfile <- read.table("covdens.txt", header=FALSE)

n <- length(posfile[1, ])
xx <- c(1:n)

#pos <- colMeans(posfile)*4639675/18096514
#neg <- colMeans(negfile)*4639675/18096514

#pos <- colMeans(posfile)*4639675/42907713
#neg <- colMeans(negfile)*4639675/42907713

pos <- colMeans(posfile)
neg <- colMeans(negfile)
#conserv <- colMeans(conservfile)
#covdens <- colMeans(covdensfile)*4639675/12964772

yy <- neg
scale <- max(c(pos, neg))
#scale <- 4

png('motif.png', height=800, width=800)
plot (yy~xx, type="n", ylim=c(0, scale))
polygon(c(xx[1], xx, xx[n]), c(min(yy), yy, min(yy)),col=rgb(0, 1, 0,0.3))
yy <- pos
polygon(c(xx[1], xx, xx[n]), c(min(yy), yy, min(yy)),col=rgb(1, 0, 0,0.3))
dev.off()

#png('motif2.png', height=800, width=800)
#plot(conserv~xx, type="n")
#lines(conserv, col="blue", lwt=3)
#dev.off()

#png('motif3.png', height=800, width=800)
#yy <- covdens
#plot (yy~xx, type="n")
#polygon(c(xx[1], xx, xx[n]), c(min(yy), yy, min(yy)),col=rgb(0, 0, 1,0.3))
#dev.off()

