#!/bin/bash

BedDir="/home/huili/BWA_Ecoli/fragmentLengthVPlot/TFBindingSite"
prefixs="ArgR Cra Fur GntR IHF NagC OxyR PurR"
#mkdir FCC586F
OutDir="FCC586F"

for prefix in $prefixs
do

motif="$BedDir/$prefix.*.sorted.bed"
range=49
length=`awk '{if ($3>$2) print $3-$2}' $motif | head -1`
echo "$prefix	$length"

for tagExp in "DS29185e"
do

perBase="/home/huili/BWA_Ecoli/perBaseCutCount/$tagExp/$tagExp.perBase.36.bed.starch"

awk '{if (($4~/forward/)&& ($2>=40)) print "chrK12\t"int(($2+$3)/2 -1)"\t"int(($2+$3)/2 + 1)}' $motif > temp.pos.bed
awk '{if (($4~/reverse/)&& ($2>=40)) print "chrK12\t"int(($2+$3)/2 -1)"\t"int(($2+$3)/2 + 1)}' $motif > temp.neg.bed

unstarch $perBase \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.pos.bed  - \
| sed 's/.000000//g' -\
> temp.pos.perbase

unstarch $perBase \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.neg.bed  - \
| sed 's/.000000//g' -\
| awk '{s=""; for (i=NF; i>=1; i--) s = s $i "\t"; print s}' \
> temp.neg.perbase

cat temp.pos.perbase temp.neg.perbase \
| awk '{print "id-"NR"\t"$0}' >  perBase.txt

Rscript ./motif.perBase.cut.heatmap.R $length
./graphMatrix.sh --inputFn="perBase.sorted.txt" --outputFn="$OutDir/$prefix.$tagExp.heatmap.png"

rm temp.* perBase.txt perBase.sorted.txt
done 
echo "$prefix is done."

done
exit


