#!/bin/bash

#PBS -N LAO7-clean
#PBS -q standby
#PBS -l naccesspolicy=shared
#PBS -l nodes=1:ppn=20
#PBS -l walltime=4:00:00
#PBS -m abe
#PBS -M davis783@purdue.edu

cd $PBS_O_WORKDIR

# create array with sequences that need to be trimmed
declare -a cutSeq=('AATGATACGGCGACCACCGAGATCTACAC' 'TCTTTCCCTACACGACGCTC' 'GTGACTGGAGTTCAGACGTG' \
'CAAGCAGAAGACGGCATACGAGATCGTGAT' 'CAAGCAGAAGACGGCATACGAGATATTGGC' 'CAAGCAGAAGACGGCATACGAGATTACAAG' \
'TCTTTCCCTACACGACGCTCTTCCGATCT' 'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT')

# make 2 files, one with the sequences that were not found 
# one with the sequences that were found and their line number in the fastq 
touch 028898_LA07_cutSeq.txt
touch 028898_LA07_cutSeq_EMPTY.txt

for i in "${cutSeq[@]}"
do
	out=$(grep -n $i 028898_LA07-GROUP_S60_R1_filtered.fastq)
	if [[ -z $out ]]
		then
			printf "${i}\nNo Sequences Found\n" >> 028898_LA07_cutSeq_EMPTY.txt
		else
			printf "${i}\n${out}\n" >> 028898_LA07_cutSeq.txt
	fi
done

# find and trim all of the sequences from the fastq and save in new file
sed "s/${cutSeq[0]}//g;s/${cutSeq[1]}//g;s/${cutSeq[2]}//g;s/${cutSeq[3]}//g;s/${cutSeq[4]}//g;\
s/${cutSeq[5]}//g;s/${cutSeq[6]}//g;s/${cutSeq[7]}//g" \
028898_LA07-GROUP_S60_R1_filtered.fastq > 028898_LA07-GROUP_trimmed.fastq

# run python script for mean/std of each sequence
python score_LA07.py

# collapse score file into one line and save as temporary file
sed -n "2~4p" score_LA07.txt > tmp.txt
tr '\n' ' ' < tmp.txt |& tee > tmp.txt 

# run python script for mean/std of all reads
python totScore_LA07.py

# remove temporay files
rm tmp.txt

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

# Find Sequences that contain primers
for ((i=1; i<=((${len} - 1)); i++ ))
do
	grep -A 2 -B 1 -E ${locusPrimer[${i}]} 028898_LA07-GROUP_trimmed.fastq > loci/${id[${i}]}_LA07.txt
	grep -A 2 -B 1 -E "^${locusPrimer[${i}]}" 028898_LA07-GROUP_trimmed.fastq > loci/${id[${i}]}_start_LA07.txt
done