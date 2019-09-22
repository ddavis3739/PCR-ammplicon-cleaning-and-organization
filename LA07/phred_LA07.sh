#!/bin/bash

python score_LA07.py

sed -n "2~4p" score_LA07.txt > tmp.txt
tr '\n' ' ' < tmp.txt |& tee > tmp.txt

python totScore_LA07.py

rm tmp.txt
