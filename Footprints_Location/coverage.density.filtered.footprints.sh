#!/bin/bash 

for tagExp in "phaseE"
do

fp="lessThan120bp/$tagExp.120.perBase.36.bed"
dens="../density/coverage.dens/$tagExp.120.bedmap.echocount.adjusted.header.bed"

awk '{print $1"\t"$2"\t"$3"\t"$5}' $fp > $tagExp.footprints.bed
sed '1d' $dens | bedops -n - $fp > $tagExp.out.footprints.bed
sed '1d' $dens | awk '{print $1"\t"$2"\t"$3"\tid-"NR"\t"$4}' > $tagExp.density.reference.bed

bar=`wc -l $tagExp.out.footprints.bed | cut -f1 | awk '{print int($1/100)}'`
filter=`sort -nrk4 $tagExp.out.footprints.bed | head -$bar | tail -1 | awk '{print $4}'`

bedmap --echo --max $tagExp.footprints.bed $tagExp.density.reference.bed \
| sed 's/|/     /g' - \
| awk '{if ($5>='$filter') print}' > lessThan120bp/$tagExp.footprints.adjusted.filtered.bed

rm $tagExp.footprints.bed $tagExp.out.footprints.bed $tagExp.density.reference.bed
done

for tagExp in "phaseS"
do

fp="lessThan120bp/$tagExp.120.perBase.36.bed"
dens="../density/coverage.dens/$tagExp.120.bedmap.echocount.header.bed"

awk '{print $1"\t"$2"\t"$3"\t"$5}' $fp > $tagExp.footprints.bed
sed '1d' $dens | bedops -n - $fp > $tagExp.out.footprints.bed
sed '1d' $dens | awk '{print $1"\t"$2"\t"$3"\tid-"NR"\t"$4}' > $tagExp.density.reference.bed

bar=`wc -l $tagExp.out.footprints.bed | cut -f1 | awk '{print int($1/100)}'`
filter=`sort -nrk4 $tagExp.out.footprints.bed | head -$bar | tail -1 | awk '{print $4}'`

bedmap --echo --max $tagExp.footprints.bed $tagExp.density.reference.bed \
| sed 's/|/     /g' - \
| awk '{if ($5>='$filter') print}' > lessThan120bp/$tagExp.footprints.filtered.bed

rm $tagExp.footprints.bed $tagExp.out.footprints.bed $tagExp.density.reference.bed
done


exit


