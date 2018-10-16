#!/usr/bin/env bash

#To generate the contacts:
#Remember that the output makes sense only for chr_i <= chr_j, the other are transposed and need to be discarded
#parallel "java -jar ~/tools/juicer/scripts/juicer_tools.jar dump observed none 4DNFI1E6NJQJ.hic {1} {2} BP 1000000 ./inter/chr{1}-chr{2}.inter.observed.none.txt" ::: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y ::: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y
# rm tagged_with_centrality/*.sorted  inter.none.observed/*sorted*  inter.none.observed/*.final

export LC_ALL=C

interactions=$1			# inter.none.observed/chr10-chr11.inter.observed.none.txt
run=$2				# 48/52/58

chrI=`echo $interactions | rev | cut -d'/' -f1|rev|cut -d'.' -f1|cut -d'-' -f1`
chrJ=`echo $interactions | rev | cut -d'/' -f1|rev|cut -d'.' -f1|cut -d'-' -f2`

centralityI=/home/garner1/Work/dataset/gpseq+hic/tagged_with_centrality/${chrI}.bc${run} 
centralityJ=/home/garner1/Work/dataset/gpseq+hic/tagged_with_centrality/${chrJ}.bc${run}
[ -f ${interactions} ] && [ ! -f ${interactions}.sortedK1 ] && cat ${interactions} | awk '{print $1/1000000,$2/1000000,$3}' | tr ' ' '\t' |  sort -k1,1 > ${interactions}.sortedK1
[ -f ${interactions} ] && [ ! -f ${interactions}.sortedK2 ] && cat ${interactions} | awk '{print $1/1000000,$2/1000000,$3}' | tr ' ' '\t' |  sort -k2,2 > ${interactions}.sortedK2
[ ! -f ${centralityI}.sorted ] && cat ${centralityI} | tr ' ' '\t' |  sort -k1,1 > ${centralityI}.sorted
[ ! -f ${centralityJ}.sorted ] && cat ${centralityJ} | tr ' ' '\t' |  sort -k1,1 > ${centralityJ}.sorted
[ -f ${interactions} ] && join -o1.1,1.2,1.3,2.2 ${interactions}.sortedK1 ${centralityI}.sorted | awk '{print $1"_"$2,$3,$4}' | tr ' ' '\t' | sort > ${interactions}.sortedK1.joinedI
[ -f ${interactions} ] && join -o1.1,1.2,1.3,2.2 -1 2 -2 1 ${interactions}.sortedK2 ${centralityJ}.sorted | awk '{print $1"_"$2,$3,$4}' | tr ' ' '\t' | sort > ${interactions}.sortedK2.joinedJ
[ -f ${interactions} ] && join ${interactions}.sortedK1.joinedI ${interactions}.sortedK2.joinedJ | tr '_ ' '\t\t' | cut -f-4,6 > ${interactions}.bc${run}.tsv

[ -f ${interactions} ] && rm -f ${interactions}.sortedK1 ${interactions}.sortedK2 ${interactions}.sortedK1.joinedI ${interactions}.sortedK2.joinedJ

mkdir -p /home/garner1/Work/dataset/gpseq+hic/bc${run}
[ -f ${interactions} ] && mv ${interactions}.bc${run}.tsv /home/garner1/Work/dataset/gpseq+hic/bc${run}
