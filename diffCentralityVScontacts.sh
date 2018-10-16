#!/usr/bin/env bash

##################
chr=$1
cd /home/garner1/Work/dataset/gpseq+hic
mkdir -p hic.observed.KR.1M
java -jar ~/tools/juicer/scripts/juicer_tools.jar dump observed KR 4DNFI1E6NJQJ.hic $chr $chr BP 1000000 ./hic.observed.KR.1M/chr${chr}_1M.txt # generate HiC matrix
##################
# cd /home/garner1/Work/dataset/gpseq+hic/hic.observed.KR.1M
# parallel "cat chr{}_1M.txt|awk -v chr=chr{} '{print chr,\$1,\$1+1000000,\$2,\$2+1000000,\$3}'|tr ' ' '\t' > chr{}.bed" ::: $(seq 1 22)
# cd ..
# #################
# parallel "bedtools intersect -a {} -b tagged_with_centrality/B58_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {.}.bc58.bed" ::: hic.observed.none.1M/bedfiles/chr*.bed
# mkdir -p hic.observed.KR.1M/bedfiles/bc48
# mv hic.observed.KR.1M/bedfiles/*bc*bed hic.observed.KR.1M/bedfiles/bc48

# parallel "bedtools intersect -a {} -b tagged_with_centrality/B52_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {.}.bc52.bed" ::: hic.observed.none.1M/bedfiles/chr*.bed
# mkdir -p hic.observed.KR.1M/bedfiles/bc52
# mv hic.observed.KR.1M/bedfiles/*bc*bed hic.observed.KR.1M/bedfiles/bc52

# parallel "bedtools intersect -a {} -b tagged_with_centrality/B48_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {.}.bc48.bed" ::: hic.observed.none.1M/bedfiles/chr*.bed
# mkdir -p hic.observed.KR.1M/bedfiles/bc58
# mv hic.observed.KR.1M/bedfiles/*bc*bed hic.observed.KR.1M/bedfiles/bc58

# #################
# parallel "cat {} | awk '{print \$1,\$4,\$5,\$0}'|tr ' ' '\t'|cut -f-3,5,6,9- > {}.transposed" ::: hic.observed.KR.1M/bedfiles/bc48/chr*bed
# parallel "cat {} | awk '{print \$1,\$4,\$5,\$0}'|tr ' ' '\t'|cut -f-3,5,6,9- > {}.transposed" ::: hic.observed.KR.1M/bedfiles/bc52/chr*bed
# parallel "cat {} | awk '{print \$1,\$4,\$5,\$0}'|tr ' ' '\t'|cut -f-3,5,6,9- > {}.transposed" ::: hic.observed.KR.1M/bedfiles/bc58/chr*bed
################
# parallel "bedtools intersect -a {} -b tagged_with_centrality/B48_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {}.bed" ::: hic.observed.none.1M/bedfiles/bc48/*transposed
# parallel "bedtools intersect -a {} -b tagged_with_centrality/B52_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {}.bed" ::: hic.observed.none.1M/bedfiles/bc52/*transposed
# parallel "bedtools intersect -a {} -b tagged_with_centrality/B58_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {}.bed" ::: hic.observed.none.1M/bedfiles/bc58/*transposed
# #################
