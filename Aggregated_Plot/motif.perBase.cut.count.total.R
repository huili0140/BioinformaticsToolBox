#!/usr/local/R/bin/Rscript

posfile <- read.table("perBase.Pos.txt", header=FALSE, row.names=1)
negfile <- read.table("perBase.Neg.txt", header=FALSE, row.names=1)

xx <- c(1:200)
n <- 200
pos <- colMeans(posfile)
neg <- colMeans(negfile)
yy <- neg + pos
range1 <- min(yy[61:140])
range2 <- max(yy[61:140])


png('motif.png', height=600, width=1200)
plot (yy~xx, ylim=c(range1, range2), type="n")
polygon(c(xx[1], xx, xx[n]), c(min(yy), yy, min(yy)),col=rgb(0, 0, 1,0.3))

dev.off()


