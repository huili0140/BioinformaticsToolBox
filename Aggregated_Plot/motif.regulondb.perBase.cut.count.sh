#!/bin/bash

motif="TFBindingSiteSet.coordinates.uniq.5.sites.more.txt"
prefix="Fis"
length=14
range=93
perBasePos="DS21608.pos.perBase.36.bed.starch"
perBaseNeg="DS21608.neg.perBase.36.bed.starch"


awk '{if ($1~/'$prefix'/) print "chrK12\t"$2"\t"$3"\t"$4}' $motif \
| awk '{if (($3-$2) == '$length') print}' - \
| sort-bed - > $prefix.sorted.bed

awk '{if ($4 == "forward") print $1"\t"$2"\t"$3}'  $prefix.sorted.bed > temp.pos.bed
awk '{if ($4 == "forward") print $1":"$2"-"$3"-"NR}'  $prefix.sorted.bed > temp.pos.index
awk '{if ($4 == "reverse") print $1"\t"$2"\t"$3}'  $prefix.sorted.bed > temp.neg.bed
awk '{if ($4 == "reverse") print $1":"$2"-"$3"-"NR}'  $prefix.sorted.bed > temp.neg.index

#range=`awk '{print int(150-'$length'/2)}'`

unstarch $perBasePos \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.pos.bed  - \
| sed 's/.000000//g' -\
| paste temp.pos.index - > temp.pos.perbasePos

unstarch $perBaseNeg \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.pos.bed  - \
| sed 's/.000000//g' -\
| paste temp.pos.index - > temp.pos.perbaseNeg


unstarch $perBasePos \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.neg.bed  - \
| sed 's/.000000//g' -\
| rev \
| paste temp.neg.index - > temp.neg.perbasePos

unstarch $perBaseNeg \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.neg.bed  - \
| sed 's/.000000//g' -\
| rev \
| paste temp.neg.index - > temp.neg.perbaseNeg


cat temp.pos.perbasePos temp.neg.perbaseNeg \
> perBase.Pos.txt

cat temp.pos.perbaseNeg temp.neg.perbasePos \
>  perBase.Neg.txt

rm temp*

R CMD BATCH motif.perBase.cut.count.R

exit


