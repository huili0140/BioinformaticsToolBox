#!/usr/local/R/bin/Rscript

library(bitops)
library(caTools)
library(spp, lib.loc="/home/huili/AddOn_Packages/R/lib")

chip.data <- read.bam.tags("/home/huili/BWA_Ecoli/sortedBam/unfixedF4withtrimmed.bwa.sorted.bam")
binding.characteristics <- get.binding.characteristics (chip.data, srange=c(40, 200), bin=1, cluster=NULL)

#print out binding peak separation distance
print (paste("binding peak separation distance = ", binding.characteristics$peak$x))

# plot corss-correlation profile
pdf(file="/home/huili/BWA_Ecoli/SPP/unfixedF4withtrimmed.crosscorrelation.pdf", width=5, height=5)
par (mar = c(3.5, 3.5, 1.0, 0.5), mgp = c(2, 0.65, 0), cex = 0.8)
plot (binding.characteristics$cross.correlation, type='l', xlab="strand shift", ylab="cross-correlation")
abline(v=binding.characteristics$peak$x, lty=2, col=2)
dev.off()

# simply accept all the tags
chip.data <- select.informative.tags(chip.data)
chip.data <- remove.local.tag.anomalies(chip.data)

# output smoothed tag density with re-scaled input into a wig file
tag.shift <- round (binding.characteristics$peak$x/2)
smoothed.density <- get.smoothed.tag.density(chip.data, bandwidth=200, step=100, tag.shift=tag.shift, scale.by.dataset.size=T)
writewig(smoothed.density, "/home/huili/BWA_Ecoli/SPP/unfixedF4withtrimmed.density.wig", "unfixedF4withtrimmed density")
rm (smoothed.density)

# detec point binding positions
fdr <- 1e-2
detection.window.halfsize <- binding.characteristics$whs
bp <- find.binding.positions(signal.data=chip.data, fdr=fdr, whs=detection.window.halfsize, cluster=NULL)
output.binding.results(bp, "/home/huili/BWA_Ecoli/SPP/unfixedF4withtrimmed.fdr0.01.WTD.binding.positions.txt")

fdr <- 1e-3
detection.window.halfsize <- binding.characteristics$whs
bp <- find.binding.positions(signal.data=chip.data, fdr=fdr, whs=detection.window.halfsize, cluster=NULL)
output.binding.results(bp, "/home/huili/BWA_Ecoli/SPP/unfixedF4withtrimmed.fdr0.001.WTD.binding.positions.txt")






