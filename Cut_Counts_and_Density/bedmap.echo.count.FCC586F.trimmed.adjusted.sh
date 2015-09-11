#!/bin/bash

mkdir FCC586F
Dir="/home/huili/BWA_Ecoli/density/coverage.dens/FCC586F"

for tagExp in "DS29185e"
do

# Generate chrom buckets
#awk '{ for(i = $2; i < $3; i += 5) { print $1"\t"i"\t"i + 5 }}' $Dir/chrK12.bed \
# > $Dir/chrK12.chrom-buckets.5bp.bed

# Sork the paired location file according to fragment length

samtools view ../../sortedBam/$tagExp.bwa.sorted.bam \
| awk '{if ($9 >=33 && $9 <= 300 && (($2=99)||($2=147)||($2=83)||($2=163))) print $3"\t"$4"\t"$8+36"\t"$9}' \
> $Dir/$tagExp.paired.location.1

samtools view ../../sortedBam/$tagExp.bwa.trimmed.sorted.bam \
| awk '{if (($4 = $8) && ($9 >= 6) && ($9 <= 37)) print $3"\t"$4"\t"$4+$9"\t"$9}' \
> $Dir/$tagExp.paired.location.2

cat $Dir/$tagExp.paired.location.1 $Dir/$tagExp.paired.location.2 \
| sort-bed - > $Dir/$tagExp.paired.location.bed

rm $Dir/$tagExp.paired.location.1 $Dir/$tagExp.paired.location.2

bedmap --echo --count chrK12.chrom-buckets.5bp.bed $Dir/$tagExp.paired.location.bed \
| sed 's/|/	/g' - \
| sed '1itrack type=wiggle_0 name='$tagExp'.trimmed color=106,90,205 visibility=full' - \
> $Dir/$tagExp.bedmap.echocount.header.bed

sed '1d' $Dir/$tagExp.bedmap.echocount.header.bed \
| bedmap --echo --max - chrK12.chrom-buckets.50.100.ratio.5column.bed \
| sed 's/|/     /g' - \
| awk '{print $1"\t"$2"\t"$3"\t"$4/$5}' \
| sed '1itrack type=wiggle_0 name='$tagExp'.trimmed.adjusted color=0,255,0 visibility=full' \
> $Dir/$tagExp.bedmap.echocount.adjusted.header.bed


done
exit


