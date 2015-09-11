#!/bin/bash
############################
#Generate tag files pos.minus.neg.bed and pos.plus.neg.bed
#Generate density files density.all, density.pos, density.neg
#Generate density files with reduced backgrounds density.signal.pos, density.signal.neg, density.background
############################

win="5"
binI="2"

for tagExp in "DS29185e"
do
InFile="/home/huili/BWA_Ecoli/sortedBam/$tagExp.bwa.sorted.bam"
trimmed="/home/huili/BWA_Ecoli/sortedBam/$tagExp.bwa.trimmed.sorted.bam"
mkdir /home/huili/BWA_Ecoli/perBaseCutCount/$tagExp
OutDir="/home/huili/BWA_Ecoli/perBaseCutCount/$tagExp"

#Bucket files generated here:

#awk -v binI=$binI -v win=$win \
#'{ for(i = $2 + win; i < $3; i += binI) { print $1"\t"i - win"\t"i + win }}' chromBuckets/chrK12.start.1.bed \
# > chromBuckets/chrK12.chrom-buckets.$win.$binI.bed

#Tag files geenrated here:
samtools view $InFile \
| awk '{if ($9 >= 33 && (($2==99)||($2==147)||($2==83)||($2==163))) print $3"\t"$4"\t"$4+1}' \
> $OutDir/$tagExp.pos.tag.1

samtools view $trimmed \
| awk '{if (($4 == $8) && ($9 >= 6) && ($9 <= 37)) print $3"\t"$4"\t"$4+1}' \
> $OutDir/$tagExp.pos.tag.2

cat $OutDir/$tagExp.pos.tag.1 $OutDir/$tagExp.pos.tag.2 \
| sort-bed - | awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"1}' >  $OutDir/$tagExp.pos.tag.sorted.bed

rm  $OutDir/$tagExp.pos.tag.1 $OutDir/$tagExp.pos.tag.2

samtools view $InFile \
| awk '{if ($9 <= -33 && (($2==99)||($2==147)||($2==83)||($2==163))) print $3"\t"$4+36"\t"$4+37}' \
> $OutDir/$tagExp.neg.tag.1

samtools view $trimmed \
| awk '{if (($4 == $8) && ($9 >= 6) && ($9 <= 37)) print $3"\t"$4+$9"\t"$4+$9+1}' \
> $OutDir/$tagExp.neg.tag.2

cat $OutDir/$tagExp.neg.tag.1 $OutDir/$tagExp.neg.tag.2 \
| sort-bed - | awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"1}' >  $OutDir/$tagExp.neg.tag.sorted.bed

rm $OutDir/$tagExp.neg.tag.1 $OutDir/$tagExp.neg.tag.2 

cat $OutDir/$tagExp.pos.tag.sorted.bed $OutDir/$tagExp.neg.tag.sorted.bed \
| sort-bed - | awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"1}' > $OutDir/$tagExp.tag.sorted.bed

#perBase cut count starch files generated here:
bedmap --sum ../chromBuckets/chrK12.chrom-buckets.1bp.bed $OutDir/$tagExp.pos.tag.sorted.bed \
| paste ../chromBuckets/chrK12.chrom-buckets.1bp.bed  - \
| cut -f1-4 \
| sed -e 's/NAN/0/' \
| awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"$4}' \
| starch - > $OutDir/$tagExp.pos.perBase.36.bed.starch

bedmap --sum ../chromBuckets/chrK12.chrom-buckets.1bp.bed $OutDir/$tagExp.neg.tag.sorted.bed \
| paste ../chromBuckets/chrK12.chrom-buckets.1bp.bed - \
| cut -f1-4 \
| sed -e 's/NAN/0/' \
| awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"$4}' \
| starch - > $OutDir/$tagExp.neg.perBase.36.bed.starch

bedmap --sum ../chromBuckets/chrK12.chrom-buckets.1bp.bed $OutDir/$tagExp.tag.sorted.bed \
| paste ../chromBuckets/chrK12.chrom-buckets.1bp.bed - \
| cut -f1-4 \
| sed -e 's/NAN/0/' \
| awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"$4}' \
| starch - > $OutDir/$tagExp.perBase.36.bed.starch

#perBase wig files generated here:
unstarch $OutDir/$tagExp.pos.perBase.36.bed.starch \
| awk '{print  $1"\t"$2"\t"$3"\t"$5}' \
| sed '1itrack type=wiggle_0 name='$tagExp'.pos color=106,90,205 visibility=full' - \
> $OutDir/$tagExp.pos.perBase.36.wig

unstarch $OutDir/$tagExp.neg.perBase.36.bed.starch \
| awk '{print  $1"\t"$2"\t"$3"\t"0-$5}' \
| sed '1itrack type=wiggle_0 name='$tagExp'.neg color=106,90,205 visibility=full' - \
> $OutDir/$tagExp.neg.perBase.36.wig

unstarch $OutDir/$tagExp.perBase.36.bed.starch \
| awk '{print  $1"\t"$2"\t"$3"\t"$5}' \
| sed '1itrack type=wiggle_0 name='$tagExp' color=106,90,205 visibility=full' - \
> $OutDir/$tagExp.perBase.36.wig

#Density based on original tags generated here:
unstarch $OutDir/$tagExp.perBase.36.bed.starch \
| bedmap --sum ../chromBuckets/chrK12.chrom-buckets.$win.$binI.bed -  \
| paste ../chromBuckets/chrK12.chrom-buckets.$win.$binI.bed - \
| cut -f1-4 \
| sed -e  's/NAN/0/' \
| awk -v binI=$binI -v win=$win \
  'BEGIN{halfBin= binI/2; shiftFactor= win-halfBin}{print $1"\t"$2+shiftFactor"\t"$3-shiftFactor"\t"$4}' \
| sed '1itrack type=wiggle_0 name='$tagExp'.density color=0,255,0 visibility=full' - \
>  $OutDir/$tagExp.$win.$binI.density.wig

rm $OutDir/$tagExp.*.sorted.bed
done
exit
