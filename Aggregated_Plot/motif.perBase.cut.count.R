#!/usr/local/R/bin/Rscript

posfile <- read.table("perBase.Pos.txt", header=FALSE)
negfile <- read.table("perBase.Neg.txt", header=FALSE)

n <- length(posfile[1, ])
xx <- c(1:n)

#phaseE.60
#pos <- colMeans(posfile)*4639675/12964772
#neg <- colMeans(negfile)*4639675/12964772
#phaseE.2U.60
pos <- colMeans(posfile)*4639675/3657336
neg <- colMeans(negfile)*4639675/3657336

#DS29185.Trimmed.60
#pos <- colMeans(posfile)*4639675/2541494
#neg <- colMeans(negfile)*4639675/2541494

yy <- neg
scale1 <- min(c(pos, neg))
scale2 <- max(c(pos, neg))


png('motif.png', height=800, width=800)
plot (yy~xx, type="n", ylim=c(scale1, scale2))
polygon(c(xx[1], xx, xx[n]), c(min(yy), yy, min(yy)),col=rgb(0, 1, 0,0.3))
yy <- pos
polygon(c(xx[1], xx, xx[n]), c(min(yy), yy, min(yy)),col=rgb(1, 0, 0,0.3))

dev.off()


