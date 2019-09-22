#!/bin/bash

#PBS -N INF-clean
#PBS -q standby
#PBS -l naccesspolicy=shared
#PBS -l nodes=1:ppn=20
#PBS -l walltime=4:00:00
#PBS -m abe
#PBS -M davis783@purdue.edu

cd $PBS_O_WORKDIR

python score_UNI.py

sed -n "2~4p" score_UNI.txt > tmp.txt
tr '\n' ' ' < tmp.txt |& tee > tmp1.txt 

python totScore_UNI.py

rm tmp.txt
rm tmp1.txt
