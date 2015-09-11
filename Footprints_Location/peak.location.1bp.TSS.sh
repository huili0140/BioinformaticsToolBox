#!/bin/bash

chr="chrK12.start.1.bed"
gene="Cho.2009.STable4.TSS.all.signed.bed"

#how many peaks are located by gene start
for fd in "lessThan60bp" "lessThan120bp"
do

for tagExp in "phaseE.footprints.adjusted" "phaseS.footprints"
do
peak="$fd/$tagExp.filtered.bed"
i=100

awk '{center=int(($3+$2)/2); print $1"\t"center"\t"center+1}' $peak > peak.original.temp
cp peak.original.temp peak.temp

for i in  {1..1500}
do
        awk '{if ($5~/+/) print $1"\t"$2-'$i'"\t"$2+1-'$i'; if ($5~/-/) print $1"\t"$3-1+'$i'"\t"$3+'$i'}' $gene \
        | awk '{if ($2 >0) print $1"\t"$2"\t"$3"\taheadGeneStart"}' > range.ahead.temp

	awk '{if ($5~/+/) print $1"\t"$2-1+'$i'"\t"$2+'$i'; if ($5~/-/) print $1"\t"$3-'$i'"\t"$3+1-'$i'}' $gene \
        | awk '{if ($2 >0) print $1"\t"$2"\t"$3"\tafterGeneStart"}' > range.after.temp

        bedops -e peak.temp range.ahead.temp \
        | wc -l \
        | cut -f1 >> peak.location.aheadGeneStart.txt

	bedops -n peak.temp range.ahead.temp > peak.temp.2
        cp peak.temp.2 peak.temp

        bedops -e peak.temp range.after.temp \
        | wc -l \
        | cut -f1 >> peak.location.afterGeneStart.txt

        bedops -n peak.temp range.after.temp > peak.temp.2
        cp peak.temp.2 peak.temp

done

awk '{print $1"\t"NR}' peak.location.aheadGeneStart.txt \
| sort -nrk2 - \
| awk '{print $1}' - \
| cat - peak.location.afterGeneStart.txt \
> $fd/$tagExp.1bp.peak.location.TSS.txt
rm peak.location.aheadGeneStart.txt peak.location.afterGeneStart.txt

done

done

rm *temp* 
exit



