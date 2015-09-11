#!/bin/bash

#motifs="*Database_fimo_out/fimo.txt"

#for motif in $motifs
#do
#	Dir=`dirname $motif`
#	sed '1d' $motif \
#	| awk '{if ($3 < $4) print $2"\t"$3"\t"$4+1"\t+\t"$1"\t"$6}' \
#	> temp.1.bed
#	sed '1d' $motif \
#        | awk '{if ($3 > $4) print $2"\t"$4"\t"$3+1"\t-\t"$1"\t"$6}' \
#        > temp.2.bed
#	cat temp.1.bed temp.2.bed \
#	| sort-bed - > $Dir/fimo.sorted.bed
#	rm temp.*.bed
#done

for tagExp in "DS35939" "DS35940" "DS35942" "DS35943" "DS35944"
do

beds="../$tagExp-final/$tagExp.fdr0.01.hot.bed
        ../$tagExp-final/$tagExp.fdr0.01.pks.bed"

for bed in $beds
do
        prefix=`basename $bed .bed`
	bedops -e humanDatabase_fimo_out/fimo.sorted.bed $bed > $prefix.human.bed
	bedops -e yeastDatabase_fimo_out/fimo.sorted.bed $bed > $prefix.yeast.bed
done

done
exit

