#!/bin/bash

python score_UNI.py

sed -n "2~4p" score_UNI.txt > tmp.txt
tr '\n' ' ' < tmp.txt |& tee > tmp1.txt

python totScore_UNI.py

rm tmp.txt
rm tmp1.txt
