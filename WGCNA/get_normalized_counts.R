library(dplyr)
library(stringr)
library(genefilter)
library(tidyr)
library(ggplot2)
library(tidyverse)
setwd('/home/mpilab/sorghum_salt/')
exp_design <- 'Experimental_design.TSV'
PCG_count <- read.table('Sorghum_bicolor_PCG.TSV', header = T, sep = '\t', row.names = 1)
Lnc_count <- read.table('Sorghum_bicolor_Lnc.TSV', header = T, sep = '\t', row.names = 1)
count_matrix <- rbind(PCG_count,Lnc_count)

# read experimental design
coldata <- read.table(exp_design, header=TRUE, sep = '\t',
                      row.names=1)
coldata$Condition <- factor(coldata$Condition)
coldata$Genotype <- factor(coldata$Genotype)
# read count matrix
countdata <- count_matrix[,c(6:ncol(count_matrix))]
countdata <- as.matrix(countdata)
head(countdata)

library(DESeq2)

# DDS
dds <- DESeqDataSetFromMatrix(countData = countdata, colData = coldata, design = ~ Genotype + Condition)
dds <- DESeq(dds)
vsd <- varianceStabilizingTransformation(dds)
wpn_vsd <- getVarianceStabilizedData(dds)
rv_wpn <- rowVars(wpn_vsd, useNames = T)
summary(rv_wpn)
q75_wpn <- quantile( rowVars(wpn_vsd, useNames = T), .75)
expr_normalized <- wpn_vsd[ rv_wpn > q75_wpn, ]
expr_normalized[1:5,1:5]
dim(expr_normalized)
expr_normalized_df <- as.data.frame(expr_normalized)
expr_normalized_df <- expr_normalized_df %>% rownames_to_column('Transcript')
expr_normalized_df$Transcript <- str_replace_all(pattern = 'MSTRG',replacement = 'SbiLnc',string = expr_normalized_df$Transcript) 

write.table(expr_normalized_df, 'WGCNA/DESeq2_normalized.TSV', row.names = F,
            col.names = T, sep = '\t', quote = F)

expr_normalized_df <- data.frame(expr_normalized) %>%
  mutate(
    Transcript = row.names(expr_normalized)
  ) %>%
  pivot_longer(-Transcript)

pdf('WGCNA/Normalized_expression.pdf',width = 5,height = 5)
expr_normalized_df %>% ggplot(., aes(x = name, y = value)) +
  geom_violin() +
  geom_point() +
  theme_bw() +
  theme(
    axis.text.x = element_text( angle = 90)
  ) +
  ylim(0, NA) +
  labs(
    title = "Normalized and 75 quantile Expression",
    x = "treatment",
    y = "normalized expression"
  )
dev.off()