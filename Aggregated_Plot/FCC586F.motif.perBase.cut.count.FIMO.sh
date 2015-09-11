#!/bin/bash

BedDir="/home/huili/BWA_Ecoli/FIMO/fimo_out/FIMOSiteSorted/"
#mkdir /home/huili/BWA_Ecoli/aggregatedPlot/FCC586F
OutDir="/home/huili/BWA_Ecoli/aggregatedPlot/FCC586F"
motifs="$BedDir/*.sorted.e4.bed"



for motif in $motifs
do

prefix=`basename $motif .sorted.e4.bed`
length=`head -1 $motif | awk '{print $3-$2}'`
range=`echo "40 - $length / 2" | bc`
echo "$prefix   $length   $range"

for tagExp in "DS29185e"
do

perBasePos="/home/huili/BWA_Ecoli/perBaseCutCount/$tagExp/$tagExp.pos.perBase.36.bed.starch"
perBaseNeg="/home/huili/BWA_Ecoli/perBaseCutCount/$tagExp/$tagExp.neg.perBase.36.bed.starch"

awk '{if (($4~/forward/)&& ($2>=40)) print $1"\t"$2"\t"$3}' $motif > temp.pos.bed
awk '{if (($4~/reverse/)&& ($2>=40)) print $1"\t"$2"\t"$3}' $motif > temp.neg.bed

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
| awk '{s=""; for (i=NF; i>=1; i--) s = s $i "\t"; print s}' \
> temp.neg.perbasePos

unstarch $perBaseNeg \
| bedmap --range $range --multidelim "\t" --echo-map-score temp.neg.bed  - \
| sed 's/.000000//g' -\
| awk '{s=""; for (i=NF; i>=1; i--) s = s $i "\t"; print s}' \
> temp.neg.perbaseNeg


cat temp.pos.perbasePos temp.neg.perbaseNeg \
> perBase.Pos.txt

cat temp.pos.perbaseNeg temp.neg.perbasePos \
>  perBase.Neg.txt

R CMD BATCH motif.perBase.cut.count.DS29185e.R
cp motif.png $OutDir/$prefix.$tagExp.fimo.motif.png
rm motif.png

#R CMD BATCH motif.perBase.cut.count.total.R
#cp motif.png $prefix.$tagExp.fimo.motif.total.png

done 
echo "$prefix is done."
done

rm temp.*
exit


