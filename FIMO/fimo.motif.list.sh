#!/bin/bash

beds="DS*.bed"

for bed in $beds
do
	prefix=`basename $bed .bed`
	mkdir $prefix
	cut -f5 $bed \
	| sort - \
	| uniq -c \
	| awk '{if ($1 >= 10) print $2}' > $prefix/fimo.motif.list.txt
	cp $bed $prefix/fimo.motif.bed
done

exit
