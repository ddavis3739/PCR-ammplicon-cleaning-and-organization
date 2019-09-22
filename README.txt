The scripts below are to be used to clean up and organize sequence reads 

clean_INF.sh should be run first, with the only alteration needed is changing 
the fastq file that the grep is run on in line 25. Other than that file names can 
be changed at your discretion. The output of this script is a trimmed version of the 
original sequence read in .fastq format

The two other scripts can now be run simultaneously. 

phred_INF.sh converts the scores for each read into the numeric format of each ASCII
character. This script uses both score_INF.py and totScore_INF.py to execute so ensure 
these scripts are in the same folder as phred_INF.sh. score_INF.py converts each sequence's
score to numeric in the format of:

Line 1: sequence ID
Line 2: sequence score (numeric)
Line 3: mean of score
Line 4: std of score

locus_INF.sh creates a folder with the sequence reads for each locus according to their 
primer sequences. The sequence must start with its forward primer for it to be considered 
part of a locus. 2 folders are then contained within this filtering each sequence for each 
locus by whether or not it is of its expected length. Then within the expected length folder 
each locus is again filtered, this time by whether or not a sequence has the correct reverse 
primer. All files are in .fastq format.

This information is output to score_INF.txt. totScore_INF.py use that file to get the 
overall mean and standard deviation for all reads and appends them to the bottom of 
score_INF.txt.

A script has also been included that runs all of these in one step. This script is called
readProcessing.sh. 

--------------------------------------------------------------------------------------

TLR4_merge_INF.sh is designed to merge the TLR4-1 and TLR4-2 sequences. To do this it first
filters TLR4-1 and TLR4-2 to ensure they contain the primer sequences for the other locus. The sequences 
from TLR4-1 are then read line-by-line and compared to the sequences in TLR4-2 to find a sequence that shares 
the same overlapping region. These two sequences are then combined, with the phred scores being averged
in the oevrlapping region. The sequence from TLR4-2 that is merged is then removed from the pool so
it is not used more then once. The python file, merge_score.py, takes line numbers for each sequence and the 
sequences themselves as input as part of this to to generate the output for each line. 

Running this script yields TLR4_merge_INF.fastq which can be found in ./loci/expectedLength/reversePrimer.
The format of the file is in 5 line .fastq format. With the first 2 lines representing the 
sequence IDs for the 2 merged sequences, TLR4-1 and TLR4-2 in that order. 