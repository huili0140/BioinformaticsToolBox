#!/bin/bash
#$ -S /bin/bash
#$-q all.q
#$ -N spp
#$ -cwd
#$ -j Y
#$ -V
#$ -m be

R CMD BATCH spp.fdr0.01.r


