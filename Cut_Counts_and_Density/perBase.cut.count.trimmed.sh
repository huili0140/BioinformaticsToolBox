#!/bin/bash

chr="SacCer3HumanY"
tag="chrY"

#To generate density files

for tagExp in "DS35939" "DS35940" "DS35941" "DS35942" "DS35943" "DS35944"
do

chromBucket="../chromBuckets/$chr.chrom-buckets.1bp.bed"
inFile="../sortedBam/$tagExp.bwa.sorted.bam"
trimmed="../sortedBam/$tagExp.bwa.trimmed.sorted.bam"
mkdir ./$tagExp
outDir="./$tagExp"

#tag files generated here
samtools view $inFile \
| awk '{if ((($2==99)||($2==147)||($2==83)||($2==163)) && ($9>=33) && ($9<=300) && ($5 != 0)) print $3"\t"$4"\t"$4+1}' \
> $outDir/$tagExp.pos.tag.1

samtools view $trimmed \
| awk '{if (($4 == $8) && ($9 >= 6) && ($9 <= 37)) print $3"\t"$4"\t"$4+1}' \
> $outDir/$tagExp.pos.tag.2

cat $outDir/$tagExp.pos.tag.1 $outDir/$tagExp.pos.tag.2 \
| sort-bed - \
| awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"1}' \
>  $outDir/$tagExp.pos.tag.sorted.bed

rm $outDir/$tagExp.pos.tag.1 $outDir/$tagExp.pos.tag.2

samtools view $inFile \
| awk '{if ((($2==99)||($2==147)||($2==83)||($2==163)) && ($9<=-33) && ($9>=-300) && ($5 != 0)) print $3"\t"$4+36"\t"$4+37}' \
> $outDir/$tagExp.neg.tag.1

samtools view $trimmed \
| awk '{if (($4 == $8) && ($9 >= 6) && ($9 <= 37)) print $3"\t"$4+$9"\t"$4+$9+1}' \
> $outDir/$tagExp.neg.tag.2

cat $outDir/$tagExp.neg.tag.1 $outDir/$tagExp.neg.tag.2 \
| sort-bed - \
| awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"1}' \
> $outDir/$tagExp.neg.tag.sorted.bed

rm $outDir/$tagExp.neg.tag.1 $outDir/$tagExp.neg.tag.2


cat $outDir/$tagExp.pos.tag.sorted.bed $outDir/$tagExp.neg.tag.sorted.bed \
| sort-bed - \
| awk '{print $1"\t"$2"\t"$3"\t""id-"NR"\t"1}' \
> $outDir/$tagExp.tag.sorted.bed

#perBase cut count starch files generated here
bedmap --sum $chromBucket $outDir/$tagExp.pos.tag.sorted.bed \
| paste $chromBucket - \
| cut -f1-4 \
| sed -e 's/NAN/0/' \
| sed '1itrack type=wiggle_0 name='$tagExp'.pos.tag.trimmed color=106,90,205 visibility=full' \
> $outDir/$tagExp.pos.perBase.trimmed.wig

cat $outDir/$tagExp.pos.perBase.trimmed.wig \
| sed '1d' \
| awk '{print $1"\t"$2"\t"$3"\tid-"NR"\t"$4}' \
| starch - > $outDir/$tagExp.pos.perBase.trimmed.bed.starch

bedmap --sum $chromBucket $outDir/$tagExp.neg.tag.sorted.bed \
| paste $chromBucket - \
| cut -f1-4 \
| sed -e 's/NAN/0/' \
| sed '1itrack type=wiggle_0 name='$tagExp'.neg.tag.trimmed color=106,90,205 visibility=full' \
> $outDir/$tagExp.neg.perBase.trimmed.wig

cat $outDir/$tagExp.neg.perBase.trimmed.wig \
| sed '1d' \
| awk '{print $1"\t"$2"\t"$3"\tid-"NR"\t"$4}' \
| starch - > $outDir/$tagExp.neg.perBase.trimmed.bed.starch

bedmap --sum $chromBucket $outDir/$tagExp.tag.sorted.bed \
| paste $chromBucket - \
| cut -f1-4 \
| sed -e 's/NAN/0/' \
| awk '{print $1"\t"$2"\t"$3"\tid-"NR"\t"$4}' \
| starch - > $outDir/$tagExp.tag.perBase.trimmed.bed.starch

rm $outDir/$tagExp.*tag.sorted.bed

#separeate the yeast genome form human/mouse genome

for ori in "pos" "neg"
do

cat $outDir/$tagExp.$ori.perBase.trimmed.wig \
| sed '1d' \
| awk '{if ($1 == "'$tag'") print}' \
| sed '1itrack type=wiggle_0 name='$tagExp'.'$ori'.'$tag' color=106,90,205 visibility=full maxHeightPixels=40 viewLimits=0:50 autoScale=off' \
> $outDir/$tagExp.$ori.$tag.perBase.trimmed.wig

cat $outDir/$tagExp.$ori.perBase.trimmed.wig \
| sed '1d' \
| awk '{if ($1 != "'$tag'") print}' \
| sed '1itrack type=wiggle_0 name='$tagExp'.'$ori'.SacCer3 color=106,90,205 visibility=full maxHeightPixels=40 viewLimits=0:50 autoScale=off' \
> $outDir/$tagExp.$ori.SacCer3.perBase.trimmed.wig

rm $outDir/$tagExp.$ori.perBase.trimmed.wig
done

done
exit





