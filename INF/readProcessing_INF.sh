#!/bin/bash

# create array with sequences that need to be trimmed
declare -a cutSeq=('AATGATACGGCGACCACCGAGATCTACAC' 'TCTTTCCCTACACGACGCTC' 'GTGACTGGAGTTCAGACGTG' \
'CAAGCAGAAGACGGCATACGAGATCGTGAT' 'CAAGCAGAAGACGGCATACGAGATATTGGC' 'CAAGCAGAAGACGGCATACGAGATTACAAG' \
'TCTTTCCCTACACGACGCTCTTCCGATCT' 'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT')

# make 2 files, one with the sequences that were not found
# one with the sequences that were found and their line number in the fastq
touch 028900_INF_cutSeq_EMPTY.txt
touch 028900_INF_cutSeq.txt

for i in "${cutSeq[@]}"
do
	out=$(grep -n $i 028900_INF-GROUP_S62_R1_filtered.fastq)
	if [[ -z $out ]]
		then
			printf "${i}\nNo Sequences Found\n" >> 028900_INF_cutSeq_EMPTY.txt
		else
			printf "${i}\n${out}\n" >> 028900_INF_cutSeq.txt
	fi
done

# find and trim all of the sequences from the fastq and save in new file
sed "s/${cutSeq[0]}//g;s/${cutSeq[1]}//g;s/${cutSeq[2]}//g;s/${cutSeq[3]}//g;s/${cutSeq[4]}//g;\
s/${cutSeq[5]}//g;s/${cutSeq[6]}//g;s/${cutSeq[7]}//g" \
028900_INF-GROUP_S62_R1_filtered.fastq > 028900_INF-GROUP_trimmed.fastq

# run python script for mean/std of each sequence
python score_INF.py

# collapse score file into one line and save as temporary file
sed -n "2~4p" score_INF.txt > tmp.txt
tr '\n' ' ' < tmp.txt |& tee > tmp1.txt

# run python script for mean/std of all reads
python totScore_INF.py

# remove temporay files
rm tmp.txt
rm tmp1.txt

set -B

len=$(wc -l < ../locus_seqs.txt)

declare -A id
declare -A locusPrimer

# Pull out primer information
for ((i=2; i<=${len}; i++))
do
	locus=$(sed -n "${i}p" ../locus_seqs.txt | awk '{printf $1}')
	seq=$(sed -n "${i}p" ../locus_seqs.txt | awk '{printf $2}')
	pos=$(($i - 1))
	id[$pos]=$locus
	locusPrimer[$pos]=$seq
done

mkdir loci

# Find sequences that contain primers
for ((i=1; i<=((${len} - 1)); i++ ))
do
	grep -A 2 -B 1 -E ${locusPrimer[${i}]} 028900_INF-GROUP_trimmed.fastq > loci/${id[${i}]}_INF.txt
	grep -A 2 -B 1 -E "^${locusPrimer[${i}]}" 028900_INF-GROUP_trimmed.fastq > loci/${id[${i}]}_start_INF.txt
done
