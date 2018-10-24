#!/usr/bin/env bash

#GIVEN THE GPSEQ CENTRALITY SCORE, IT LABELS GENOME BINS WITH 4 DISCRETE CENTRALITY TAGS

# bash ~/Work/pipelines/aux.scripts/make-windows.sh 1000000 hg19 > hg19.binned.1M.bed

file=$1				# B48_transCorrected/10-ON/B48_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv
binnedGenome=$2			# hg19.binned.1M.bed

bedtools intersect -a ${binnedGenome} -b ${file} -wa -wb | grep -v nan | tr '.' ',' | datamash -s -g 1,2,3 median 7 | tr ',' '.' > ${file}.binned # bin the gpseq data,take the median of the centralities
min=`cat  ${file}.binned | tr '.' ',' | datamash min 4 | tr ',' '.'`
step=`cat  ${file}.binned | tr '.' ',' | datamash min 4 max 4 |tr ',' '.'| awk '{print ($2-$1)/10}'`
d1=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -1 | tail -1`
d2=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -2 | tail -1`
d3=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -3 | tail -1`
d4=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -4 | tail -1`
d5=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -5 | tail -1`
d6=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -6 | tail -1`
d7=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -7 | tail -1`
d8=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -8 | tail -1`
d9=`seq 1 10 | awk -v min=${min} -v step=${step} '{print min+$1*0.7}' | head -9 | tail -1`
cat ${file}.binned | awk -v min=${min} -v d1=${d1} -v d2=${d2} -v d3=${d3} -v d4=${d4} -v d5=${d5} -v d6=${d6} -v d7=${d7} -v d8=${d8} -v d9=${d9}   '{if ($4<d1) print $0,"1";else if (($4>=d1)&&($4<d2)) print $0,"2";else if (($4>=d2)&&($4<d3)) print $0,"3";else if (($4>=d3)&&($4<d4)) print $0,"4";else if (($4>=d4)&&($4<d5)) print $0,"5";else if (($4>=d5)&&($4<d6)) print $0,"6";else if (($4>=d6)&&($4<d7)) print $0,"7";else if (($4>=d7)&&($4<d8)) print $0,"8";else if (($4>=d8)&&($4<d9)) print $0,"9";else if ($4>=d9) print $0,"10"}' > ${file}.tagged.tsv # discretize WRT 10 values the centrality of each bin, 1=periphery and 10=central

# # statistics=`tail -n+2 ${file}.binned | grep -v nan | tr '.' ',' | datamash q1 4 median 4 q3 4 | tr ',' '.'`
# # q1=`echo ${statistics}|cut -d' ' -f1`
# # median=`echo ${statistics}|cut -d' ' -f2`
# # q3=`echo ${statistics}|cut -d' ' -f3`
# # cat ${file}.binned | awk -v q1=${q1} -v median=${median} -v q3=${q3} '{if ($4<q1) print $0,"1";else if (($4>=q1)&&($4<median)) print $0,"2";else if (($4>=median)&&($4<q3)) print $0,"3";else if ($4>=q3) print $0,"4"}' > ${file}.tagged.tsv # discretize WRT 4 values the centrality of each bin, 1=periphery and 4=central

# statistics=`tail -n+2 ${file}.binned | grep -v nan | cut -f4 | sta -p 10,20,30,40,50,60,70,80,90`
# d1=`echo $statistics|cut -d' ' -f10`
# d2=`echo $statistics|cut -d' ' -f11`
# d3=`echo $statistics|cut -d' ' -f12`
# d4=`echo $statistics|cut -d' ' -f13`
# d5=`echo $statistics|cut -d' ' -f14`
# d6=`echo $statistics|cut -d' ' -f15`
# d7=`echo $statistics|cut -d' ' -f16`
# d8=`echo $statistics|cut -d' ' -f17`
# d9=`echo $statistics|cut -d' ' -f18`
# cat ${file}.binned | awk -v d1=${d1} -v d2=${d2} -v d3=${d3} -v d4=${d4} -v d5=${d5} -v d6=${d6} -v d7=${d7} -v d8=${d8} -v d9=${d9}   '{if ($4<d1) print $0,"1";else if (($4>=d1)&&($4<d2)) print $0,"2";else if (($4>=d2)&&($4<d3)) print $0,"3";else if (($4>=d3)&&($4<d4)) print $0,"4";else if (($4>=d4)&&($4<d5)) print $0,"5";else if (($4>=d5)&&($4<d6)) print $0,"6";else if (($4>=d6)&&($4<d7)) print $0,"7";else if (($4>=d7)&&($4<d8)) print $0,"8";else if (($4>=d8)&&($4<d9)) print $0,"9";else if ($4>=d9) print $0,"10"}' > ${file}.tagged.tsv # discretize WRT 10 values the centrality of each bin, 1=periphery and 10=central

rm ${file}.binned
mkdir -p /home/garner1/Work/dataset/gpseq+hic/tagged_with_centrality
mv ${file}.tagged.tsv /home/garner1/Work/dataset/gpseq+hic/tagged_with_centrality
cd /home/garner1/Work/dataset/gpseq+hic/tagged_with_centrality
cat B48* | awk '{print $2/1000000"\t"$5"\t"$4 > $1".bc48"}'
cat B52* | awk '{print $2/1000000"\t"$5"\t"$4 > $1".bc52"}'
cat B58* | awk '{print $2/1000000"\t"$5"\t"$4 > $1".bc58"}'
