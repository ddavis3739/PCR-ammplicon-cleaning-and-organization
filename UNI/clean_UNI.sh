#!/bin/bash

#PBS -N UNI-clean
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
touch 028899_UNI_cutSeq.txt
touch 028899_UNI_cutSeq_EMPTY.txt

for i in "${cutSeq[@]}"
do
	out=$(grep -n $i 028899_UNI-GROUP_S61_R1_filtered.fastq)
	if [[ -z $out ]]
		then
			printf "${i}\nNo Sequences Found\n" >> 028899_UNI_cutSeq_EMPTY.txt
		else
			printf "${i}\n${out}\n" >> 028899_UNI_cutSeq.txt 
	fi
done

# find and trim all of the sequences from the fastq and save in new file
sed "s/${cutSeq[0]}//g;s/${cutSeq[1]}//g;s/${cutSeq[2]}//g;s/${cutSeq[3]}//g;s/${cutSeq[4]}//g;\
s/${cutSeq[5]}//g;s/${cutSeq[6]}//g;s/${cutSeq[7]}//g" \
028899_UNI-GROUP_S61_R1_filtered.fastq > 028899_UNI-GROUP_trimmed.fastq


