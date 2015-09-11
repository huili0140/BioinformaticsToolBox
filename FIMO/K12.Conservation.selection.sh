#!/bin/bash

motif="fimo_out/FIMOSiteSorted/Fur.sorted.e4.bed"
prefix=`basename $motif .sorted.e4.bed`

bedmap --mean $motif K12.Conservation.phastCons.bed \
| paste $motif - \
| sed 's/|/	/g' - \
> $prefix.cons.bed

awk '{if ($6 >= 0.7) print}' $prefix.cons.bed > $prefix.cons.0.7.bed
awk '{if ($6 >= 0.8) print}' $prefix.cons.bed > $prefix.cons.0.8.bed
awk '{if ($6 >= 0.9) print}' $prefix.cons.bed > $prefix.cons.0.9.bed

exit 
