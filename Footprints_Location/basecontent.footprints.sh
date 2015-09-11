#!/bin/bash

for sen in "insensitive" "sensitive"
do
	for n in "60" "120" "200"
	do
		bed="/home/huili/BWA_Ecoli/density/tag.dens/$sen.phaseE.$n.bed"
		bed2fasta $bed ../../K12.fna > temp.$sen.$n.fa
		perl basecontent2.pl temp.$sen.$n.fa basecontent.phaseE.$sen.$n.txt
	

	done
done

exit
