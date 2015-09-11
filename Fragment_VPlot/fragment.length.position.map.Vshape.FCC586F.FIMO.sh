#!/bin/bash

BedDir="/home/huili/BWA_Ecoli/FIMO/fimo_out/FIMOSiteSorted/"
prefixs="AgaR ArcA ArgR CpxR Cra CytR DcuR DgsA ExuR Fis Fur GadE GadW GadX GntR HNS IclR IHF NagC OmpR OxyR PhoP PurR"
#mkdir FCC586F
OutDir="FCC586F"

for prefix in $prefixs
do

motif="$BedDir/$prefix.sorted.e4.bed"

for tagExp in "DS29185e"
do
	paired="/home/huili/BWA_Ecoli/density/coverage.dens/FCC586F/$tagExp.paired.location.bed"
	cat $motif \
	| awk '{print $1"\t"int(($2+$3)/2)"\t"$4}' \
	> $OutDir/temp.center.bed

	while read chr center ori
	do
		start=$(($center-80))
		end=$(($center+80))
		echo "chrK12	$start	$end" > $OutDir/temp.range.bed
		bedops -e -1 $paired $OutDir/temp.range.bed \
		| awk -v ori=$ori -v center=$center '{if ((ori == "+")||(ori=="forward")) print int(($2+$3)/2)-center"\t"$4; if ((ori == "-")||(ori=="reverse")) print center-int(($2+$3)/2)"\t"$4;}' \
		>> $OutDir/temp.pos.length.txt
	done < $OutDir/temp.center.bed

	cp $OutDir/temp.pos.length.txt $OutDir/$prefix.$tagExp.FIMO.Trimmed.position.map.txt
	R CMD BATCH $OutDir/fragment.length.position.map.Vshape.R
	cp motif.png $OutDir/$prefix.$tagExp.FIMO.Trimmed.Vshape.png
	rm motif.png $OutDir/temp.pos.length.txt

done
done

exit


