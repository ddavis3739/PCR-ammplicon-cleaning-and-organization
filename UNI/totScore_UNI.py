#!/usr/bin/env python

from __future__ import division
import numpy 

def avg(x):
    return sum(x, 0.0) / len(x)

# work with collapsed score file 
f=open('tmp1.txt')
lines=f.readlines()

# convert strings to integers so they can be worked with
totScore = lines[0]
totScore = map(int, totScore.split())

# open score file to append to the end
f1 = open("score_UNI.txt","a")

# take the mean and standard deviation of all scores and append to score file
totMean = avg(totScore)
totSTD = numpy.std(totScore, ddof=1)
f1.write('\n' + str(totMean) + '\n')
f1.write(str(totSTD) + '\n')
	

