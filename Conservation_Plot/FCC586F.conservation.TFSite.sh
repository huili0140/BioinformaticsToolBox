#!/bin/bash

BedDir="/home/huili/BWA_Ecoli/fragmentLengthVPlot/TFBindingSite"
mkdir FCC586F
OutDir="FCC586F"
#prefixs="Fur"
prefixs="ArgR Cra Fur GntR IHF NagC OxyR PurR"

for prefix in $prefixs
do

motif="$BedDir/$prefix.*.sorted.bed"
range=39

cons="K12.Conservation.phastCons.bed"

awk '{if (($4~/forward/)&& ($2>=40)) print "chrK12\t"int(($2+$3)/2 -1)"\t"int(($2+$3)/2 + 1)}' $motif > temp.pos.bed
awk '{if (($4~/reverse/)&& ($2>=40)) print "chrK12\t"int(($2+$3)/2 -1)"\t"int(($2+$3)/2 + 1)}' $motif > temp.neg.bed

cat $cons \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.pos.bed  - \
| sed 's/.000000//g' -\
> temp.pos.cons

cat $cons \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.neg.bed  - \
| sed 's/.000000//g' -\
| awk '{s=""; for (i=NF; i>=1; i--) s = s $i "\t"; print s}' \
> temp.neg.cons

cat temp.pos.cons temp.neg.cons \
| awk '{if (NF==80) print}' >  temp.cons

R CMD BATCH K12.conservation.plot.R
cp motif.png $OutDir/$prefix.conservation.png
rm motif.png

done 
exit


