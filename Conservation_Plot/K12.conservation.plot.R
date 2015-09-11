#!/bin/bash

cons <- read.table("temp.cons", header=FALSE)
con <- colMeans(cons)

png('motif.png', height=800, width=800)
plot(con, type="n")
lines(con, col="blue")
dev.off()

