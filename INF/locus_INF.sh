#!/bin/bash

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
