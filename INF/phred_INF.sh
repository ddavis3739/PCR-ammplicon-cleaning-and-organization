#!/bin/bash

python score_INF.py

sed -n "2~4p" score_INF.txt > tmp.txt
tr '\n' ' ' < tmp.txt |& tee > tmp1.txt

python totScore_INF.py

rm tmp.txt
rm tmp1.txt
