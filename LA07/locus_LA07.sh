#!/bin/bash

#PBS -N INF-clean
#PBS -q standby
#PBS -l naccesspolicy=shared
#PBS -l nodes=1:ppn=20
#PBS -l walltime=4:00:00
#PBS -m abe
#PBS -M davis783@purdue.edu

cd $PBS_O_WORKDIR

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