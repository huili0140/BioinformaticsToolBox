#!/bin/bash

dens="DS29185e.100.100.density.all.bed"

cat $dens \
| sort -nk4 - \
| tail -4640 \
| sort-bed - \
| bedops --range 100 -m - \
| awk '{if (($3-$2)>=1200) print $1"\t"$2+100"\t"$3-100}' \
> DS29185e.sensitive.top10pct.bed

cat DS29185e.sensitive.top10pct.bed \
| sed '1itrack name=DS29185e.sensitive.top10pct color=106,90,205' \
> DS29185e.sensitive.top10pct.header.bed

cat $dens \
| sort -nk4 - \
| tail -9280 \
| sort-bed - \
| bedops --range 100 -m - \
| awk '{if (($3-$2)>=1200) print $1"\t"$2+100"\t"$3-100}' \
> DS29185e.sensitive.top20pct.bed

cat DS29185e.sensitive.top20pct.bed \
| sed '1itrack name=DS29185e.sensitive.top20pct color=106,90,205' \
> DS29185e.sensitive.top20pct.header.bed

cat $dens \
| sort -nk4 - \
| tail -9280 \
| sort-bed - \
| bedops --range 100 -m - \
| awk '{if (($3-$2)>=800) print $1"\t"$2+100"\t"$3-100}' \
> DS29185e.sensitive.top20pct.short.bed

cat DS29185e.sensitive.top20pct.short.bed \
| sed '1itrack name=DS29185e.sensitive.top20pct.short color=106,90,205' \
> DS29185e.sensitive.top20pct.short.header.bed

exit


