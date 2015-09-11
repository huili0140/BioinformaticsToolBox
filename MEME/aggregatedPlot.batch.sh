#!/bin/bash

tagExp="DS35939"
genome="hg19_chrY"
group="hotspots"

#genetate the motif.txt files

cat meme.txt \
| awk '{if ($0~/sites sorted by position p-value/ || $2 == "-" || $2 == "+") print}' \
> meme.sorted.sites.txt 

n=0
out="$tagExp.$group.motif.0.txt"
rm $tagExp.$group.motif.*.txt

while read line; do
	if [[ $line =~ "sites sorted by position p-value" ]]; then
		n=`echo $line | head -1 | awk '{print $2}'`
		out="$tagExp.$group.motif.$n.txt"
	else 
		echo $line >> $out
	fi	
done < meme.sorted.sites.txt

#Generate the aggregated plot 

for n in {1..25}
do

motif="$tagExp.$group.motif.$n.txt"
string=`head -1 $motif | awk '{print $6}'`
length=${#string}
range=`echo "40 - $length / 2" | bc`
perBasePos="/home/huili/BWA_YAC/$genome/perBaseCount/$tagExp/$tagExp.pos.perBase.trimmed.bed.starch"
perBaseNeg="/home/huili/BWA_YAC/$genome/perBaseCount/$tagExp/$tagExp.neg.perBase.trimmed.bed.starch"
prefix=`basename $motif .txt`

awk '{print $1}' $motif \
| sed 's/:/	/g' - \
| sed 's/-/	/g' - \
| paste - $motif \
| awk '{print $1"\t"$2"\t"$3"\t"$5"\t"$6}' \
| awk '{if ($4~/+/) print $1"\t"$2+$5-1"\t"$2+$5-1+'$length'"\t"$4; if ($4~/-/) print $1"\t"$2+$5-1"\t"$2+$5-1+'$length'"\t"$4}' \
| sort-bed - > $prefix.sorted.bed

awk '{if ($4~/+/) print $1"\t"$2"\t"$3}'  $prefix.sorted.bed > temp.pos.bed
awk '{if ($4~/+/) print $1":"$2"-"$3}'  $prefix.sorted.bed > temp.pos.index
awk '{if ($4~/-/) print $1"\t"$2"\t"$3}'  $prefix.sorted.bed > temp.neg.bed
awk '{if ($4~/-/) print $1":"$2"-"$3}'  $prefix.sorted.bed > temp.neg.index

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
cp motif.png $motif.png
rm motif.png

done

exit


