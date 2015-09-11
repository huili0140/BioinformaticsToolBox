#!/bin/bash

for tagExp in "DS29185"
do

#get the initial trim candidates file
bam="sortedBam/$tagExp.bwa.sorted.bam"

samtools view $bam \
| awk '{if (($2!=99)&&($2!=147)&&($2!=83)&&($2!=163)) print $1"\t"$10}' \
| sort -k1 \
| awk '{print $1"\n"$2}' \
| awk 'BEGIN{i=1}{line[i++]=$0}END{j=1; 
		for (j=1; j<i; j=j+2) 
			if (line[j] == line[j+2]) 
				print line[j+2]"\t"line[j+3]"@\t"line[j]"\t"line[j+1]"@"}' \
> $tagExp.trim.candidates.txt

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27
do
        trima=`head -$i trim.adapter.list.txt | tail -1 - | cut -f1`
        trimb=`head -$i trim.adapter.list.txt | tail -1 - | cut -f2`
        trim=`head -$i trim.adapter.list.txt | tail -1 - | cut -f3`
        dist=$((36-$i))

        awk '{if (($0~/'$trima'/)||($0~/'$trimb'/)) print}' $tagExp.trim.candidates.txt \
        | sed 's/'$trim'//g' - \
        > $tagExp.trim.$i.txt

awk '{print "@"$1" 2:N:0:GGCTAC\n"$2"\n+\n"$2}' $tagExp.trim.$i.txt > $tagExp.trimmed.R2.fastq
awk '{print "@"$3" 1:N:0:GGCTAC\n"$4"\n+\n"$4}' $tagExp.trim.$i.txt > $tagExp.trimmed.R1.fastq
pairR1="$tagExp.trimmed.R1.fastq"
pairR2="$tagExp.trimmed.R2.fastq"

#BWA mapping:
bwa aln -t 4 -n 1 K12.fna $pairR1 > $tagExp.R1.sai
bwa aln -t 4 -n 1 K12.fna $pairR2 > $tagExp.R2.sai
bwa sampe -a $dist K12.fna $tagExp.R1.sai $tagExp.R2.sai $pairR1 $pairR2 > $tagExp.bwa.trimmed.$i.sam

#sam to bam:
samtools import K12.fna.fai $tagExp.bwa.trimmed.$i.sam $tagExp.bwa.trimmed.$i.bam
samtools sort $tagExp.bwa.trimmed.$i.bam $tagExp.bwa.trimmed.sorted.$i
samtools index $tagExp.bwa.trimmed.sorted.$i.bam
rm $tagExp.R1.sai $tagExp.R2.sai $tagExp.bwa.trimmed.$i.sam $tagExp.bwa.trimmed.$i.bam

echo "***************$i.trimmed**************"
wc -l $tagExp.trim.$i.txt
rm $tagExp.trim.$i.txt
samtools flagstat $tagExp.bwa.trimmed.sorted.$i.bam
echo " "

done

echo "@SQ       SN:chrK12       LN:4639675" > $tagExp.bwa.trimmed.sam
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27
do

j1=$((36-$i))
j2=$((36-$i))

samtools view $tagExp.bwa.trimmed.sorted.$i.bam \
| awk '{if ((($9 >= '$j1') && ($9 <= '$j2')) || (($9 <= -'$j1') && ($9 >= -'$j2'))) print}' \
>> $tagExp.bwa.trimmed.sam

rm $tagExp.bwa.trimmed.sorted.$i.bam $tagExp.bwa.trimmed.sorted.$i.bam.bai
done

samtools import K12.fna.fai $tagExp.bwa.trimmed.sam $tagExp.bwa.trimmed.bam
samtools sort $tagExp.bwa.trimmed.bam $tagExp.bwa.trimmed.sorted
samtools index $tagExp.bwa.trimmed.sorted.bam

rm $tagExp.bwa.trimmed.sam $tagExp.bwa.trimmed.bam

done

exit
