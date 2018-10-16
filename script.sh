#!/usr/bin/env bash

echo Generate discretized centrality bins ...
parallel "bash centralityParsing.sh {} ~/Work/dataset/gpseq+hic/hg19.binned.1M.bed" ::: /home/garner1/Work/dataset/gpseq+hic/B48_transCorrected/10-ON/B48_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv /home/garner1/Work/dataset/gpseq+hic/B52_transCorrected/10-ON/B52_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv /home/garner1/Work/dataset/gpseq+hic/B58_transCorrected/10-ON/B58_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv

echo Tag the interactions counts obtained from Jucier with the discretized centralities ...
rm -f inter.none.observed/*sorted*
rm -f ~/Work/dataset/gpseq+hic/tagged_with_centrality/*sorted*
echo bc58
parallel "bash tag_interactions.sh /home/garner1/Work/dataset/gpseq+hic/inter.none.observed/chr{1}-chr{2}.inter.observed.none.txt 58" ::: 1 2 3 4 5 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21 X ::: 1 2 3 4 5 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21 X
echo bc52
parallel "bash tag_interactions.sh /home/garner1/Work/dataset/gpseq+hic/inter.none.observed/chr{1}-chr{2}.inter.observed.none.txt 52" ::: 1 2 3 4 5 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21 X ::: 1 2 3 4 5 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21 X
echo bc48
parallel "bash tag_interactions.sh /home/garner1/Work/dataset/gpseq+hic/inter.none.observed/chr{1}-chr{2}.inter.observed.none.txt 48" ::: 1 2 3 4 5 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21 X ::: 1 2 3 4 5 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21 X

rm ~/Work/dataset/gpseq+hic/tagged_with_centrality/*sorted*
