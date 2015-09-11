#!/bin/bash

win="5000"
binI="10000"

awk -v binI=$binI -v win=$win \
'{ for(i = $2 + win; i < $3; i += binI) { print $1"\t"i - win"\t"i + win }}' chrK12.start.1.bed \
 > chrK12.chrom-buckets.$win.$binI.bed

exit



