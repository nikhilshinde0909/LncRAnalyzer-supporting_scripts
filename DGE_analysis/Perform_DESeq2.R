library(dplyr)
library(stringr)
exp_design <- 'Experimental_design.TSV'
PCG_count <- read.table('Sorghum_bicolor_PCG.TSV', header = T, sep = '\t', row.names = 1)
Lnc_count <- read.table('Sorghum_bicolor_Lnc.TSV', header = T, sep = '\t', row.names = 1)
count_matrix <- rbind(PCG_count,Lnc_count)

# read experimental design
coldata <- read.table(exp_design, header=TRUE, sep = '\t',
                      row.names=1)
coldata$Condition <- factor(coldata$Condition)
coldata$Genotype <- factor(coldata$Genotype)
Roma <- coldata[coldata$Genotype=='Roma',]
M81E <- coldata[coldata$Genotype=='M81E',]
# read count matrix
countdata <- count_matrix[,c(6:ncol(count_matrix))]
countdata_roma <- countdata[,rownames(Roma)]
countdata_roma <- as.matrix(countdata_roma)
countdata_m81e <- countdata[,rownames(M81E)]
countdata_m81e <- as.matrix(countdata_m81e)
head(countdata)

library(DESeq2)

# Roma
dds_roma <- DESeqDataSetFromMatrix(countData = countdata_roma, colData = Roma, design = ~ Condition )
dds_roma
dds_roma <- DESeq(dds_roma)
rld <- rlogTransformation(dds_roma)
head(assay(rld))
hist(assay(rld))
res <- results(dds_roma)
table(res$padj<0.05)
res <- res[order(res$padj), ]
resdata <- merge(as.data.frame(res), as.data.frame(counts(dds_roma, normalized=TRUE)), by="row.names", sort=FALSE)
names(resdata)[1] <- "Transcript"
head(resdata)
resdata <- resdata[!is.na(resdata$padj),]
resdata$Transcript <- str_replace_all(pattern = 'MSTRG',replacement = 'SbiLnc',string = resdata$Transcript) 
write.table(resdata, 'Roma_DESeq2.TSV', row.names = F,
            col.names = T, sep = '\t', quote = F)

# M81E
dds_m81e <- DESeqDataSetFromMatrix(countData = countdata_m81e, colData = M81E, design = ~ Condition )
dds_m81e
dds_m81e <- DESeq(dds_m81e)
rld <- rlogTransformation(dds_m81e)
head(assay(rld))
hist(assay(rld))
res <- results(dds_m81e)
table(res$padj<0.05)
res <- res[order(res$padj), ]
resdata <- merge(as.data.frame(res), as.data.frame(counts(dds_m81e, normalized=TRUE)), by="row.names", sort=FALSE)
names(resdata)[1] <- "Transcript"
head(resdata)
resdata <- resdata[!is.na(resdata$padj),]
resdata$Transcript <- str_replace_all(pattern = 'MSTRG',replacement = 'SbiLnc',string = resdata$Transcript) 
write.table(resdata, 'M81E_DESeq2.TSV', row.names = F,
            col.names = T, sep = '\t', quote = F)