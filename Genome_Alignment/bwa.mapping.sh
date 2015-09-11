#!/bin/bash

# Index E. coli K12 genome
bwa index K12.fna
samtools faidx K12.fna

# Prepare the fastq file
for tagExp in "DS29185"
do

pairR1="/net/monarch/vol2/tag/stamlab/flowcells/FCC586F_141106_tag/Project_Lab/Sample_$tagExp/*_R1_00*.fastq.gz"
pairR2="/net/monarch/vol2/tag/stamlab/flowcells/FCC586F_141106_tag/Project_Lab/Sample_$tagExp/*_R2_00*.fastq.gz"

for R1 in $pairR1
do
zcat $R1 >> $tagExp.R1.fastq
done

for R2 in $pairR2
do
zcat $R2 >> $tagExp.R2.fastq
done

# BWA mapping
bwa aln -l 36 -t 4 -n 1 K12.fna  $tagExp.R1.fastq > $tagExp.R1.sai
bwa aln -l 36 -t 4 -n 1 K12.fna  $tagExp.R2.fastq > $tagExp.R2.sai

bwa sampe -a 500 K12.fna $tagExp.R1.sai $tagExp.R2.sai $tagExp.R1.fastq $tagExp.R2.fastq > $tagExp.bwa.sam

# Convert sam to bam
samtools import K12.fna.fai $tagExp.bwa.sam $tagExp.bwa.bam
samtools sort $tagExp.bwa.bam $tagExp.bwa.sorted
samtools index $tagExp.bwa.sorted.bam

echo "**************$tagExp************"
samtools flagstat $tagExp.bwa.sorted.bam
echo " "

rm $tagExp.R1.sai $tagExp.R2.sai $tagExp.bwa.sam $tagExp.bwa.bam

done
exit

