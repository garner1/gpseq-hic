library(ggplot2)
library(Matrix)
library(dplyr)

# create a dataset
data_intra = read.table("/home/garner1/Work/dataset/gpseq+hic/layer-delta-medianCount.intra.symm.tsv",header=FALSE,col.names = c('centrality','layer_distance','HiC'))
data_intra$layer_distance <- as.factor(data_intra$layer_distance)
intra_perc <- group_by(data_intra, centrality) %>% mutate(percent = HiC/sum(HiC))

data_inter = read.table("/home/garner1/Work/dataset/gpseq+hic/layer-delta-medianCount.inter.symm.tsv",header=FALSE,col.names = c('centrality','layer_distance','HiC'))
data_inter$layer_distance <- as.factor(data_inter$layer_distance)
inter_perc <- group_by(data_inter, centrality) %>% mutate(percent = HiC/sum(HiC))

ggplot(data_intra, aes(fill=layer_distance, y=HiC, x=centrality)) + geom_col(aes(fill = layer_distance, group = layer_distance),position = "stack")+scale_fill_brewer(palette = "Set3")
ggsave(filename = "intra-chrom.hicVScentrality.pdf", device = cairo_pdf)
dev.off()
ggplot(intra_perc, aes(fill=layer_distance, y=percent, x=centrality)) + geom_col(aes(fill = layer_distance, group = layer_distance),position = "stack")+scale_fill_brewer(palette = "Set3")
ggsave(filename = "intra-chrom.hicVScentrality.percentage.pdf", device = cairo_pdf)
dev.off()

ggplot(data_inter, aes(fill=layer_distance, y=HiC, x=centrality)) + geom_col(aes(fill = layer_distance, group = layer_distance),position = "stack")+scale_fill_brewer(palette = "Set3")
ggsave(filename = "inter-chrom.hicVScentrality.pdf", device = cairo_pdf)
dev.off()
ggplot(inter_perc, aes(fill=layer_distance, y=percent, x=centrality)) + geom_col(aes(fill = layer_distance, group = layer_distance),position = "stack")+scale_fill_brewer(palette = "Set3")
ggsave(filename = "inter-chrom.hicVScentrality.percentage.pdf", device = cairo_pdf)
dev.off()

# cat bc48/intra/chr*-chr*.inter.observed.none.txt.bc48.tsv|awk '{print $4,$6,sqrt(($4-$6)**2),$3}'|tr ' .' '\t,'|datamash -s -g2,3 median 4 |cut -d',' -f-1 > layer-delta-medianCount.intra.transpose.tsv
# cat bc48/inter/chr*-chr*.inter.observed.none.txt.bc48.tsv|awk '{print $4,$6,sqrt(($4-$6)**2),$3}'|tr ' .' '\t,'|datamash -s -g1,3 median 4 |cut -d',' -f-1 > layer-delta-medianCount.inter.tsv
# insert zeros where appropriate
# paste layer-delta-medianCount.inter.transpose.tsv layer-delta-medianCount.inter.tsv |awk '$1>0'|awk '{print $1,$2,$3+$6}'|tr ' ' '\t' > layer-delta-medianCount.inter.symmetric.tsv
