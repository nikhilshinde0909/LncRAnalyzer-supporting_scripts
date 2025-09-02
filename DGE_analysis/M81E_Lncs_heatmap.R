library(dplyr)
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
pvalue = 0.05
setwd('/home/mpilab/sorghum_salt/')

M81E <- read.table('M81E_DESeq2.TSV', header = TRUE, sep = '\t')
M81E <- M81E[M81E$padj < pvalue,]
M81E <- M81E[grep(pattern = 'SbiLnc', M81E$Transcript),]
M81E <- M81E[,c(1,8:ncol(M81E))]
M81E_design <- read.table('Experimental_design.TSV', header = T, sep = '\t')
M81E_design <- M81E_design[M81E_design$Genotype=='M81E',]
M81E <- M81E[,c('Transcript',M81E_design$Run)]
M81E <- M81E[order(M81E$SRR11147328, decreasing = T),]
rownames(M81E) <- M81E$Transcript
M81E <- M81E[,-1]
M81E <- as.matrix(M81E)
M81E <- t(M81E)
# costum color range 
colMain <- colorRamp2(c(0,15000), c("#c5e3ff","#035096"))

condition <- c(rep('Control', 3), rep('Salinity stress', 3))
condition_col <- c("Control" = "#2986cc", "Salinity stress" = "#ce7e00")

# Load the required package
library(ComplexHeatmap)
row_annotation <- rowAnnotation(Condition=condition, col = list(Condition = condition_col),
                                annotation_legend_param = list(title='Condition', title_gp = gpar(fontsize = 10),
                                                               labels_gp = gpar(fontsize = 8)))

pdf('M81E_Lncs.pdf', width = 15, height = 5)
Heatmap(M81E,
        col = colMain,
        cluster_columns = FALSE,
        cluster_rows = FALSE,
        show_column_names = TRUE,
        column_title_side = 'bottom',
        column_title = 'lncRNAs',
        row_title = 'Samples',
        show_row_names = TRUE,
        column_names_centered = TRUE,
        row_names_side = "left",
        row_names_gp = gpar(fontsize = 8),
        column_names_gp = gpar(fontsize = 5, angle = 90),
        column_names_rot = 90,
        border = FALSE, 
        left_annotation = row_annotation,
        heatmap_legend_param = list(
          title = "Expression", 
          title_gp = gpar(fontsize = 10),
          labels_gp = gpar(fontsize = 8))
)
dev.off()