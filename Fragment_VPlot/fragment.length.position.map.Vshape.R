#!/usr/local/R/bin/Rscript


#f <- print((commandArgs(TRUE)[1]))

data <- read.table("temp.pos.length.txt", header=FALSE)
data2 <- data[sample(nrow(data), 800000, replace=TRUE), ] 

png('motif.png', height=800, width=800)
plot(data2$V2~data2$V1, col=rgb(0,0,205,10,maxColorValue=255), pch=4, xlim=c(-80, 80), ylim=c(0, 133))

dev.off()



#png('motif.png', height=800, width=800)
#smoothScatter(data$V2~data$V1, 
#		xlim=c(-150, 150), 
#		colramp = colorRampPalette(c("white", "royal blue")), 
#		nrpoints = 100, pch = ".", cex = 0, col = "black", 
#		transformation = function(x) x)
#dev.off()

