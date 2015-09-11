#!/bin/bash

win="5"
binI="5"
chr="SacCer3HumanY"

awk -v binI=$binI -v win=$win \
'{ for(i = $2 + win; i <= $3 - win; i += binI) { print $1"\t"i - win"\t"i + win }}' ../$chr.start.1.bed \
| sort-bed -  > $chr.chrom-buckets.$win.$binI.bed

awk -v binI=$binI -v win=$win \
'{ for(i = $2; i <= $3-1; i += 1) { print $1"\t"i"\t"i + 1 }}' ../$chr.start.1.bed \
| sort-bed - > $chr.chrom-buckets.1bp.bed

awk -v binI=$binI -v win=$win \
'{ for(i = $2; i <= $3-5; i += 5) { print $1"\t"i"\t"i + 5 }}' ../$chr.start.1.bed \
| sort-bed - > $chr.chrom-buckets.5bp.bed

exit



