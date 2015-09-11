#!/bin/bash

tagExp="DS35944"
region="pks"
data="yeast"
genome="hg19_chrY"

while read line
do

awk '{if ($5 == "'$line'") print}' fimo.motif.bed > fimo.$line.motif.bed

motif="fimo.$line.motif.bed"
length=`awk '{print $3-$2}' $motif | head -1`
range=`echo "40 - $length / 2" | bc`
perBasePos="/home/huili/BWA_YAC/$genome/perBaseCount/$tagExp/$tagExp.pos.perBase.trimmed.bed.starch"
perBaseNeg="/home/huili/BWA_YAC/$genome/perBaseCount/$tagExp/$tagExp.neg.perBase.trimmed.bed.starch"

awk '{if ($4~/+/) print $1"\t"$2"\t"$3}'  $motif > temp.pos.bed
awk '{if ($4~/-/) print $1"\t"$2"\t"$3}'  $motif > temp.neg.bed

unstarch $perBasePos \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.pos.bed  - \
| sed 's/.000000//g' -\
> temp.pos.perbasePos

unstarch $perBaseNeg \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.pos.bed  - \
| sed 's/.000000//g' -\
> temp.pos.perbaseNeg

unstarch $perBasePos \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.neg.bed  - \
| sed 's/.000000//g' -\
|  awk '{s=""; for (i=NF; i>=1; i--) s = s $i "\t"; print s}' \
> temp.neg.perbasePos

unstarch $perBaseNeg \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.neg.bed  - \
| sed 's/.000000//g' -\
|  awk '{s=""; for (i=NF; i>=1; i--) s = s $i "\t"; print s}' \
> temp.neg.perbaseNeg


cat temp.pos.perbasePos temp.neg.perbaseNeg \
> perBase.Pos.txt

cat temp.pos.perbaseNeg temp.neg.perbasePos \
>  perBase.Neg.txt

rm temp.*
R CMD BATCH aggregatedPlot.R
cp motif.png $tagExp.$region.$data.$line.png
rm motif.png

done < fimo.motif.list.txt

exit


