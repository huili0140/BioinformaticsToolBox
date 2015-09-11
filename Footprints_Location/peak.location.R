#!/usr/local/R/bin/Rscript

data <- read.table("input.txt", header=FALSE)

png('motif.png', height=600, width=1600)

xx <- c(1:3000)
n <- 3000
yy <- data$V1
plot (yy~xx, type="n")
polygon(c(xx[1], xx, xx[n]), c(min(yy), yy, min(yy)),col=rgb(1, 0, 0,0.3))
yy <- data$V2
polygon(c(xx[1], xx, xx[n]), c(min(yy), yy, min(yy)),col=rgb(0, 1, 0,0.3))

dev.off()


