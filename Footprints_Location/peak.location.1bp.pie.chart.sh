#!/bin/bash

chr="chrK12.start.1.bed"
gene="chrK12.all.gene.bed"
#nucleotides of ORF, RNA, and 

awk '{if (($3-$2)<200) print}' $gene \
 >  pie.chart.gene.small.bed

awk '{if (($3-$2)>=200) print}' $gene \
  >  pie.chart.gene.big.bed

cat $gene \
| sort-bed - \
| bedops -m - \
| bedops -d $chr - > chrK12.intergenic.bed


inter="chrK12.intergenic.bed"

awk '{if (($3-$2)<200) print}' $inter \
| bedops -m - >  pie.chart.inter.small.bed

awk '{if (($3-$2)>=200) print}' $inter \
| bedops -m -  >  pie.chart.inter.big.bed

awk '{print $1"\t"$2-1"\t"$2}' pie.chart.inter.big.bed \
| bedops -e -1 $gene - > pie.chart.inter.partA.bed
awk '{print $1"\t"$3"\t"$3+1}' pie.chart.inter.big.bed \
| bedops -e -1 $gene - > pie.chart.inter.partB.bed
awk '{if ($5~/-/) print}' pie.chart.inter.partA.bed > head1.bed
awk '{if ($5~/+/) print}' pie.chart.inter.partA.bed > tail1.bed
awk '{if ($5~/-/) print}' pie.chart.inter.partB.bed > tail2.bed
awk '{if ($5~/+/) print}' pie.chart.inter.partB.bed > head2.bed
cat head1.bed head2.bed | sort-bed - > pie.chart.inter.head.bed
cat tail1.bed tail2.bed | sort-bed - > pie.chart.inter.tail.bed

rm head1.bed tail1.bed tail2.bed head2.bed pie.chart.inter.partA.bed pie.chart.inter.partB.bed


#how many peaks are located by gene start
for fd in "P75LessThan60bp" "P75LessThan120bp"
do


for tagExp in "phaseE.footprints"
do
peak="$fd/$tagExp.adjusted.filtered.0.75.bed"
i=100
pieChart="$fd/$tagExp.pie.chart.gene.location.result.txt"

echo "pie.chart.gene.start.txt" > $pieChart
awk '{if ($5~/+/) print $1"\t"$2"\t"$2+'$i'; if ($5~/-/) print $1"\t"$3-'$i'"\t"$3}' pie.chart.gene.big.bed \
| awk '{if ($2 >0) print}' \
| bedops -e -50% $peak - \
| wc -l >> $pieChart

echo "pie.chart.gene.end.txt" >> $pieChart
awk '{if ($5~/+/) print $1"\t"$3-'$i'"\t"$3; if ($5~/-/) print $1"\t"$2"\t"$2+'$i'}' pie.chart.gene.big.bed \
| awk '{if ($2 >0) print}' \
| bedops -e -50% $peak - \
| wc -l >> $pieChart

echo "pie.chart.gene.body.txt" >> $pieChart
awk '{if ($5~/+/) print $1"\t"$2+'$i'"\t"$3-'$i'; if ($5~/-/) print $1"\t"$2+'$i'"\t"$3-'$i'}' pie.chart.gene.big.bed \
| awk '{if ($2 >0) print}' \
| bedops -e -50% $peak - \
| wc -l >> $pieChart

echo "pie.chart.gene.small.txt" >> $pieChart
bedops -e -50% $peak pie.chart.gene.small.bed \
| wc -l >> $pieChart

echo "pie.chart.inter.start.txt" >> $pieChart
awk '{if ($5~/+/) print $1"\t"$2-'$i'"\t"$2; if ($5~/-/) print $1"\t"$3"\t"$3+'$i'}' pie.chart.inter.head.bed \
| awk '{if ($2 >0) print}' \
| bedops -e -50% $peak - \
| wc -l >> $pieChart

echo "pie.chart.inter.end.txt" >> $pieChart
awk '{if ($5~/+/) print $1"\t"$3"\t"$3+'$i'; if ($5~/-/) print $1"\t"$2-'$i'"\t"$2}' pie.chart.inter.tail.bed \
| awk '{if ($2 >0) print}' \
| bedops -e -50% $peak - \
| wc -l >> $pieChart

echo "pie.chart.inter.body.txt" >> $pieChart
awk '{print $1"\t"$2+'$i'"\t"$3-'$i'}' pie.chart.inter.big.bed \
| awk '{if ($2 >0) print}' \
| bedops -e -50% $peak - \
| wc -l >> $pieChart

echo "pie.chart.inter.small.txt" >> $pieChart
bedops -e -50% $peak pie.chart.inter.small.bed \
| wc -l >> $pieChart

#how many peaks are located by gene start
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
> peak.location.pie.chart.start.txt
rm peak.location.aheadGeneStart.txt peak.location.afterGeneStart.txt

#how may peaks are located by gene end
cp peak.original.temp peak.temp
for i in  {1..1500}
do
        awk '{if ($5~/+/) print $1"\t"$3-'$i'"\t"$3+1-'$i'; if ($5~/-/) print $1"\t"$2-1+'$i'"\t"$2+'$i'}' $gene \
        | awk '{if ($2 >0) print $1"\t"$2"\t"$3"\taheadGeneEnd"}' > range.ahead.temp

        awk '{if ($5~/+/) print $1"\t"$3-1+'$i'"\t"$3+'$i'; if ($5~/-/) print $1"\t"$2-'$i'"\t"$2+1-'$i'}' $gene \
        | awk '{if ($2 >0) print $1"\t"$2"\t"$3"\tafterGeneEnd"}'  > range.after.temp

        bedops -e peak.temp range.ahead.temp \
        | wc -l \
        | cut -f1 >> peak.location.aheadGeneEnd.txt

	bedops -n peak.temp range.ahead.temp > peak.temp.2
	cp peak.temp.2 peak.temp

        bedops -e peak.temp range.after.temp \
        | wc -l \
        | cut -f1 >> peak.location.afterGeneEnd.txt

        bedops -n peak.temp range.after.temp > peak.temp.2
        cp peak.temp.2 peak.temp
done

awk '{print $1"\t"NR}' peak.location.aheadGeneEnd.txt \
| sort -nrk2 - \
| awk '{print $1}' - \
| cat - peak.location.afterGeneEnd.txt \
> peak.location.pie.chart.end.txt
rm peak.location.aheadGeneEnd.txt peak.location.afterGeneEnd.txt

paste peak.location.pie.chart.start.txt peak.location.pie.chart.end.txt \
> $fd/$tagExp.1bp.peak.location.geneStart.geneEnd.txt
rm peak.location.pie.chart.start.txt peak.location.pie.chart.end.txt

cp $fd/$tagExp.1bp.peak.location.geneStart.geneEnd.txt input.txt
R CMD BATCH peak.location.R
cp motif.png $fd/$tagExp.1bp.peak.location.geneStart.geneEnd.png
rm input.txt motif.png
done
done
 
exit



