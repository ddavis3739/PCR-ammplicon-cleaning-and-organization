#!/bin/bash

# merge based on identical sequences for pos 95 - 412 from TLR4-1 and pos 0 - 317 from TLR4-2

# only look at seqs with specific format
grep -A 2 -B 1 --no-group-separator '^.\{95\}AACCGAAGTTACATCCCAGTG' \
	loci/expectedLength/reversePrimer/TLR4-1_exLen_Rprimer_UNI.fastq > 4_1.fastq

grep -A 2 -B 1 --no-group-separator '^.\{297\}TGTTCTGTTGGACTCAGCCA' \
	loci/expectedLength/reversePrimer/TLR4-2_exLen_Rprimer_UNI.fastq > 4_2.fastq

touch loci/expectedLength/reversePrimer/TLR4_INF_merged.fastq

# get length of 4-1 for for loop
len=$(wc -l < 4_2.fastq)

for ((i=2; i<=${len}; i+=4))
do
	id=$((i -1))

	# find area that should overlap and line in 4-2 that has seq
	line=$(sed -n "${i}{p;q;}" 4_1.fastq)
	p1=${line:0:95}
	overlap=${line:95}
	p2=$(grep -n -m 1 $overlap 4_2.fastq)
	if [[ -n $p2 ]]
	then
		id2=$(cut -d ':' -f1 <<< $p2)
		p2=$(cut -d ':' -f2 <<< $p2)

		# run python script to get output
		python merge_score.py $id $id2 $p1 $p2 $i

		# delete 4-2 line so it is not read from again
		sed -i "${id2}d" 4_2.fastq
	fi
done > loci/expectedLength/reversePrimer/TLR4_INF_merged.fastq
