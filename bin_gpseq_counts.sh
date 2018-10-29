#!/usr/bin/env bash


# bash ~/Work/pipelines/aux.scripts/make-windows.sh 1000000 hg19 > hg19.binned.1M.bed

dir=$1			   # the directory where data can be found and where gpseq.${resolution}.chr${chr}.bincount is created
resolution=$2              # 1M or 100K
gpseq=$3		   # the gpseq bed file in the gpseq directory: ~/Work/dataset/gpseq+Hic/gpseq/BICRO48_TK77_10min_GG__cutsiteLoc-umiCount.transCorrected.bed

name=`echo ${gpseq}|rev|cut -d'/' -f1|rev`
present=$PWD
cd ${dir}

[ ! -d "gpseq" ] && echo "gpseq directory with bed files does not exists!"
mkdir -p gpseq.${resolution}.bincount

echo "Intersect HiC and GPseq dataset: 4DNFI1E6NJQJ.hic and ${name} ..."

bedtools intersect -a hg19.binned.${resolution}.bed -b ${gpseq} -wa -wb | 
    datamash -s -g 1,2,3 mean 8 | cut -f-2,4 | LOCALE=C sort -k1,1 | tr ',' '.' > ${gpseq}.${resolution}.bincount # bin the gpseq data
mv  ${gpseq}.${resolution}.bincount  gpseq.${resolution}.bincount

echo output written in gpseq.${resolution}.bincount
# manually create time directories and mv files there and split them by chromosome

