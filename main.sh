#!/usr/bin/env bash


# bash ~/Work/pipelines/aux.scripts/make-windows.sh 1000000 hg19 > hg19.binned.1M.bed

dir=$1			   # the directory where data can be found and where gpseq.${resolution}.chr${chr}.bincount is created
resolution=$2              # 1M or 100K
gpseq=$3		   # the gpseq bed file in the gpseq directory: ~/Work/dataset/gpseq+Hic/gpseq/BICRO48_TK77_10min_GG__cutsiteLoc-umiCount.transCorrected.bed
chr=$4			   # the chromosome: 1, 2, ...
hicfile=$5		   # fullpath to hic file

name=`echo ${gpseq}|rev|cut -d'/' -f1|rev`
present=$PWD
cd ${dir}

[ ! -d "gpseq" ] && echo "gpseq directory with bed files does not exists!"
mkdir -p gpseq.${resolution}.chr${chr}.bincount

echo "Intersect HiC and GPseq dataset: 4DNFI1E6NJQJ.hic and ${name} ..."

res=`numfmt --from=si ${resolution}`
java -jar ~/tools/juicer/scripts/juicer_tools.jar dump observed KR ${hicfile} ${chr} ${chr} BP ${res} chr${chr}_${resolution}.txt # generate observed HiC matrix (normalized)
bash ~/Work/pipelines/aux.scripts/make-windows.sh ${res} hg19 > hg19.binned.${resolution}.bed # bin the genome

bedtools intersect -a hg19.binned.${resolution}.bed -b ${gpseq} -wa -wb | grep -w ^chr${chr} |
    datamash -s -g 1,2,3 sum 8 | cut -f2,4 | LOCALE=C sort -k1,1 > ${gpseq}.${resolution}.chr${chr}.bincount # bin the gpseq data
mv  ${gpseq}.${resolution}.chr${chr}.bincount gpseq.${resolution}.chr${chr}.bincount

LOCALE=C sort -k1,1 -o chr${chr}_${resolution}.txt chr${chr}_${resolution}.txt
LOCALE=C join -o1.1,1.2,1.3,2.1,2.2 chr${chr}_${resolution}.txt gpseq.${resolution}.chr${chr}.bincount/${name}.${resolution}.chr${chr}.bincount |
    tr ' ' '\t' > gpseq.${resolution}.chr${chr}.bincount/${name}.${resolution}.chr${chr}.bincount.join-1 # join gpseq and hic row-wise

LOCALE=C sort -k2,2 -o chr${chr}_${resolution}.txt chr${chr}_${resolution}.txt
LOCALE=C join -1 2 -2 1 -o1.1,1.2,1.3,2.1,2.2 chr${chr}_${resolution}.txt gpseq.${resolution}.chr${chr}.bincount/${name}.${resolution}.chr${chr}.bincount |
    tr ' ' '\t' > gpseq.${resolution}.chr${chr}.bincount/${name}.${resolution}.chr${chr}.bincount.join-2 # join gpseq and hic col-wise

parallel "sed -i.bak 's/\t/_/' {}" ::: gpseq.${resolution}.chr${chr}.bincount/${name}.${resolution}.chr${chr}.bincount.join-{1,2}
parallel "LOCALE=C sort -k1,1 -o {} {}" ::: gpseq.${resolution}.chr${chr}.bincount/${name}.${resolution}.chr${chr}.bincount.join-{1,2}
LOCALE=C join gpseq.${resolution}.chr${chr}.bincount/${name}.${resolution}.chr${chr}.bincount.join-{1,2} |
    awk '{print $3,$6,$2,$4,$7,log($2/($4*$7))}' | tr ' ' '\t' > gpseq.${resolution}.chr${chr}.bincount/${name}.${resolution}.chr${chr}.dat # joined gpseq and hic 

echo Cleaning ...
rm gpseq.${resolution}.chr${chr}.bincount/*bincount*

cd ${present}
echo Done!
###########################################
