#!/usr/bin/env python

from __future__ import print_function
import sys
id = sys.argv[1]
id2 = sys.argv[2]
p1 = sys.argv[3]
p2 = sys.argv[4]
i = sys.argv[5]

def avg(x):
    return sum(x, 0.0) / len(x)

TLR4_1 = open("4_1.fastq", 'r')
TLR4_2 = open("4_2.fastq", 'r')

line4_1 = TLR4_1.readlines()
line4_2 = TLR4_2.readlines()

# add on id lines
print(line4_1[int(id) - 1], end="")
print(line4_2[int(id2) - 2], end="")

# add merged sequence and "+" line
print(p1 + p2)
print("+")

# get average of phred scores in overlap region and output merged score

score1 = line4_1[int(i) + 1]
score2 = line4_2[int(id2) + 1]

print(score1[:96], end="")
#convert ascii to number, avg, and convert back
for j in range(96, 412):
	s1 = ord(score1[j])
	s2 = ord(score2[j-96])
	
	list = [int(s1), int(s2)]
	avgSc = int(round(avg(list)))
	print(chr(avgSc), end="")
print(score2[317:429])










