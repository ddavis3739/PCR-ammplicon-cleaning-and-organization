#!/usr/bin/env python

import numpy

# make function to get mean
def avg(x):
    return sum(x, 0.0) / len(x)

# get length of fastq file
def lineCount():
    file = open("028899_UNI-GROUP_trimmed.fastq",'r')
    count = 0
    for line in file:
            count+=1
    return count
fileLen = lineCount()

f=open('028899_UNI-GROUP_trimmed.fastq')
lines=f.readlines()

# create phred file
f1 = open("score_UNI.txt","w")

totScore = []

for i in range(3, int(fileLen), 4):
	# get line identifiers for later
	id = i-3
	id = lines[id]
	line = lines[i]  

	# convert ASCII characters to numberic
  	score = []
	for i in range(len(line)):
		x = int(ord(line[i]))
		score.append(x)
	
	# get average and std of scores for each seq
	mean = avg(score)
	std = numpy.std(score, ddof=1)

	# append the score file
	f1.write(id)
	f1.write(' '.join(map(str, score)) + '\n')
	f1.write(str(mean) + '\n')
	f1.write(str(std) + '\n')	