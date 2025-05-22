library(dplyr)
library(tidyverse)
library(ComplexHeatmap)
library(circlize)
pvalue = 0.05
setwd('/home/mpilab/sorghum_salt/')

Roma <- read.table('Roma_DESeq2.TSV', header = TRUE, sep = '\t')
Roma <- Roma[Roma$padj < pvalue,]
Roma <- Roma[grep(pattern = 'SbiLnc', Roma$Transcript),]
Roma <- Roma[,c(1,8:ncol(Roma))]
Roma_design <- read.table('Experimental_design.TSV', header = T, sep = '\t')
Roma_design <- Roma_design[Roma_design$Genotype=='Roma',]
Roma <- Roma[,c('Transcript',Roma_design$Run)]
Roma <- Roma[order(Roma$SRR11147334, decreasing = T),]
rownames(Roma) <- Roma$Transcript
Roma <- Roma[,-1]
Roma <- as.matrix(Roma)
Roma <- t(Roma)
# costum color range 
colMain <- colorRamp2(c(0,15000), c("#dcc7f1","#6a329f"))

condition <- c(rep('Control', 3), rep('Salinity stress', 3))
condition_col <- c("Control" = "#2986cc", "Salinity stress" = "#ce7e00")

# Load the required package
library(ComplexHeatmap)
row_annotation <- rowAnnotation(Condition=condition, col = list(Condition = condition_col),
                          annotation_legend_param = list(title='Condition', title_gp = gpar(fontsize = 10),
                                                         labels_gp = gpar(fontsize = 8)))

pdf('Roma_Lncs.pdf', width = 15, height = 5)
Heatmap(Roma,
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
     labels_gp = gpar(fontsize = 8)),
)
dev.off()