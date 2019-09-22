#!/bin/bash

#PBS -N INF-clean
#PBS -q standby
#PBS -l naccesspolicy=shared
#PBS -l nodes=1:ppn=20
#PBS -l walltime=4:00:00
#PBS -m abe
#PBS -M davis783@purdue.edu

cd $PBS_O_WORKDIR

python score_LA07.py

sed -n "2~4p" score_LA07.txt > tmp.txt
tr '\n' ' ' < tmp.txt |& tee > tmp.txt 

python totScore_LA07.py

rm tmp.txt
