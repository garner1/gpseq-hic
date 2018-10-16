#!/usr/bin/env bash

##################
chr=$1
cd /home/garner1/Work/dataset/gpseq+hic
mkdir -p hic.observed.none.1M
java -jar ~/tools/juicer/scripts/juicer_tools.jar dump observed none 4DNFI1E6NJQJ.hic $chr $chr BP 1000000 ./hic.observed.none.1M/chr${chr}_1M.txt # generate HiC matrix
##################
cd /home/garner1/Work/dataset/gpseq+hic/hic.observed.none.1M
parallel "cat chr{}_1M.txt|awk -v chr=chr{} '{print chr,\$1,\$1+1000000,\$2,\$2+1000000,\$3}'|tr ' ' '\t' > chr{}.bed" ::: $(seq 1 22)
#################
parallel "bedtools intersect -a {} -b tagged_with_centrality/B58_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {.}.bc58.bed" ::: hic.observed.none.1M/bedfiles/chr*.bed
parallel "bedtools intersect -a {} -b tagged_with_centrality/B52_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {.}.bc52.bed" ::: hic.observed.none.1M/bedfiles/chr*.bed
parallel "bedtools intersect -a {} -b tagged_with_centrality/B48_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {.}.bc48.bed" ::: hic.observed.none.1M/bedfiles/chr*.bed
#################
parallel "cat {} | awk '{print \$1,\$4,\$5,\$0}'|tr ' ' '\t'|cut -f-3,5,6,9- > {}.transposed" ::: *bed
################
parallel "bedtools intersect -a {} -b tagged_with_centrality/B48_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {}.bed" ::: hic.observed.none.1M/bedfiles/bc48/*transposed
parallel "bedtools intersect -a {} -b tagged_with_centrality/B52_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {}.bed" ::: hic.observed.none.1M/bedfiles/bc52/*transposed
parallel "bedtools intersect -a {} -b tagged_with_centrality/B58_transCorrected.estimated.bins.size100000.step100000.group10000.csm3.rmOutliers_chi2.rmAllOutliers.tsv.tagged -wa -wb > {}.bed" ::: hic.observed.none.1M/bedfiles/bc58/*transposed
#################
parallel -k "cat bc48/*transposed.bed|tr '. ' ',\t'|awk -v c={} '\$11==c && \$16==c'|datamash sum 6" ::: 1 2 3 4
57783419
75214719
106786416
179563402
parallel -k "cat bc52/*transposed.bed|tr '. ' ',\t'|awk -v c={} '\$11==c && \$16==c'|datamash sum 6" ::: 1 2 3 4
59571681
75689956
116498068
172021893
parallel -k "cat bc58/*transposed.bed|tr '. ' ',\t'|awk -v c={} '\$11==c && \$16==c'|datamash sum 6" ::: 1 2 3 4
61852883
75345997
106270237
172748744
