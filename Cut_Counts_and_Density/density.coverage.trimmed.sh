#!/bin/bash
chr="SacCer3HumanY"
tag="chrY"

for tagExp in "DS35939" "DS35940" "DS35941" "DS35942" "DS35943" "DS35944"
do

chromBucket="../chromBuckets/$chr.chrom-buckets.5bp.bed"
inFile="../sortedBam/$tagExp.bwa.sorted.bam"
trimmed="../sortedBam/$tagExp.bwa.trimmed.sorted.bam"
mkdir ./$tagExp
outDir="./$tagExp"

samtools view $inFile \
| awk '{if ((($2==99)||($2==147)||($2==83)||($2==163)) && ($9>=33) && ($9<=300) && ($5 != 0)) print $3"\t"$4"\t"$8+36"\t"$9}' \
> $outDir/$tagExp.paired.location.1

samtools view $trimmed \
| awk '{if (($4 == $8) && ($9 >= 6) && ($9 <= 37)) print $3"\t"$4"\t"$4+$9"\t"$9}' \
> $outDir/$tagExp.paired.location.2 

cat $outDir/$tagExp.paired.location.1 $outDir/$tagExp.paired.location.2 \
| sort-bed - \
| awk '{print $1"\t"$2"\t"$3"\tid-"NR"\t"$4}' \
> $outDir/$tagExp.paired.location.trimmed.bed

bedmap --echo --count $chromBucket $outDir/$tagExp.paired.location.trimmed.bed \
| sed 's/|/     /g' - \
| sed '1itrack type=wiggle_0 name='$tagExp'.trimmed.coverage color=0,255,0 visibility=full' - \
> $outDir/$tagExp.bedmap.echocount.trimmed.wig

rm $outDir/$tagExp.paired.location.2 $outDir/$tagExp.paired.location.1

#separeate the yeast genome form human/mouse genome

cat $outDir/$tagExp.bedmap.echocount.trimmed.wig \
| sed '1d' \
| awk '{if ($1 == "'$tag'") print}' \
| sed '1itrack type=wiggle_0 name='$tagExp'.'$tag' color=0,255,0 visibility=full maxHeightPixels=40 viewLimits=0:50 autoScale=off' \
> $outDir/$tagExp.$tag.bedmap.echocount.trimmed.wig

cat $outDir/$tagExp.bedmap.echocount.trimmed.wig \
| sed '1d' \
| awk '{if ($1 != "'$tag'") print}' \
| sed '1itrack type=wiggle_0 name='$tagExp'.SacCer3 color=0,255,0 visibility=full maxHeightPixels=40 viewLimits=0:50 autoScale=off' \
> $outDir/$tagExp.SacCer3.bedmap.echocount.trimmed.wig

rm $outDir/$tagExp.bedmap.echocount.trimmed.wig

done
exit







