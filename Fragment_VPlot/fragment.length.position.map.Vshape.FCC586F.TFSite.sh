#!/bin/bash

BedDir="TFBindingSite"
prefixs="ArgR Cra Fur GntR IHF NagC OxyR PurR"
mkdir FCC586F
OutDir="FCC586F"

for prefix in $prefixs
do

motif="$BedDir/$prefix.*.sorted.bed"

for tagExp in "DS29185e"
do
	paired="/home/huili/BWA_Ecoli/density/coverage.dens/FCC586F/$tagExp.paired.location.bed"
	cat $motif \
	| awk '{print $1"\t"int(($2+$3)/2)"\t"$4}' \
	> temp.center.bed

	while read chr center ori
	do
		start=$(($center-200))
		end=$(($center+200))
		echo "chrK12	$start	$end" > temp.range.bed
		bedops -e -1 $paired temp.range.bed \
		| awk -v ori=$ori -v center=$center '{if ((ori == "+")||(ori=="forward")) print int(($2+$3)/2)-center"\t"$4; if ((ori == "-")||(ori=="reverse")) print center-int(($2+$3)/2)"\t"$4;}' \
		>> temp.pos.length.txt
	done < temp.center.bed

	cp temp.pos.length.txt $OutDir/$prefix.$tagExp.Trimmed.position.map.txt
	R CMD BATCH fragment.length.position.map.Vshape.R
	cp motif.png $OutDir/$prefix.$tagExp.Trimmed.Vshape.png
	rm motif.png temp.pos.length.txt

done
done

exit


