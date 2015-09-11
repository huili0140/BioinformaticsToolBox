#!/bin/bash

for fd in "lessThan60bp" "lessThan120bp"
do

for tagExp in "phaseE.footprints.adjusted" "phaseS.footprints"
do
	paste $fd/$tagExp.1bp.peak.location.geneStart.geneEnd.txt $fd/$tagExp.1bp.peak.location.TSS.txt \
	| awk '{print $1"\t"$2"\t"$3"\t"NR}' > $fd/$tagExp.1bp.peak.location.temp
	
	sumgs=0
	sumge=0
	sumtss=0
	count=0
	while read gs ge tss line; do
		sumgs=$(($sumgs + $gs))
                sumge=$(($sumge + $ge))
                sumtss=$(($sumtss + $tss))
		count=$(($count + 1))
		if [[ $count == 50 ]]; then
			echo "$sumgs	$sumge	$sumtss" >> $fd/$tagExp.peak.location.50.txt
			sumgs=0
			sumge=0
			sumtss=0
			count=0
		fi

	done < $fd/$tagExp.1bp.peak.location.temp
	rm $tagExp.1bp.peak.location.temp
done

done

exit



