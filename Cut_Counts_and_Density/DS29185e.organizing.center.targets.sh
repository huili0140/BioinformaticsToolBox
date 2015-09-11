#!/bin/bash

for tagExp in "top10pct" "top20pct" "top20pct.short"
do

sen1="DS29185e.sensitive.$tagExp.bed"
sen2="unfixedF4.sensitive.$tagExp.bed"

bedops -e -1 $sen1 $sen2 > temp.1
bedops -e -1 $sen2 $sen1 > temp.2
cat temp.1 temp.2 | sort-bed - | bedops -m - > DS29185e.organizing.center.$tagExp.bed

cat DS29185e.organizing.center.$tagExp.bed \
| sed '1itrack name=DS29185e.organizing.center.'$tagExp' color=0,255,0' \
> DS29185e.organizing.center.$tagExp.header.bed

done
exit


