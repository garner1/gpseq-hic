#!/usr/bin/env bash

#GIVEN THE GPSEQ CENTRALITY SCORE, IT LABELS GENOME BINS WITH 4 DISCRETE CENTRALITY TAGS

# bash ~/Work/pipelines/aux.scripts/make-windows.sh 1000000 hg19 > hg19.binned.1M.bed

file=$1				# B48_transCorrected/10-ON/B48_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv
binnedGenome=$2			# hg19.binned.1M.bed

bedtools intersect -a ${binnedGenome} -b ${file} -wa -wb | grep -v nan | tr '.' ',' | datamash -s -g 1,2,3 median 7 | tr ',' '.' > ${file}.binned # bin the gpseq data,take the median of the centralities

statistics=`tail -n+2 ${file}.binned | grep -v nan | tr '.' ',' | datamash q1 4 median 4 q3 4 | tr ',' '.'`
q1=`echo ${statistics}|cut -d' ' -f1`
median=`echo ${statistics}|cut -d' ' -f2`
q3=`echo ${statistics}|cut -d' ' -f3`

cat ${file}.binned | awk -v q1=${q1} -v median=${median} -v q3=${q3} '{if ($4<q1) print $0,"1";else if (($4>=q1)&&($4<median)) print $0,"2";else if (($4>=median)&&($4<q3)) print $0,"3";else if ($4>=q3) print $0,"4"}' > ${file}.tagged.tsv # discretize WRT 4 values the centrality of each bin, 1=periphery and 4=central

rm ${file}.binned
mkdir -p /home/garner1/Work/dataset/gpseq+hic/tagged_with_centrality
mv ${file}.tagged.tsv /home/garner1/Work/dataset/gpseq+hic/tagged_with_centrality
cd /home/garner1/Work/dataset/gpseq+hic/tagged_with_centrality
cat B48* | awk '{print $2/1000000"\t"$5 > $1".bc48"}'
cat B52* | awk '{print $2/1000000"\t"$5 > $1".bc52"}'
cat B58* | awk '{print $2/1000000"\t"$5 > $1".bc58"}'
