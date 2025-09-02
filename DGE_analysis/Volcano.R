library(EnhancedVolcano)
setwd("/home/mpilab/sorghum_salt/")
FDR=0.05
log2foldchange=2
# Roma
Roma <- read.table("Roma_DESeq2.TSV", header = T, sep = '\t')
#Roma <- Roma[grep(pattern = 'SbiLnc', Roma$Transcript),]
Roma <- Roma[Roma$padj < FDR,]
Roma <- Roma[!is.na(Roma$padj),]
L1 <- EnhancedVolcano(Roma,
                      lab = Roma$Transcript,
                      x = 'log2FoldChange',
                      y = 'pvalue',
                      title = 'Roma',
                      subtitle = NULL,
                      caption = paste0("total = ",length(Roma$Transcript[abs(Roma$log2FoldChange) > log2foldchange]) , " DEGs"),
                      captionLabSize = 18,
                      pCutoff = 10e-04,
                      ylim = c(0,100),
                      xlim = c(-10,10),
                      labSize = 4,
                      legendLabSize = 10,
                      FCcutoff = 2)

# M81E
M81E <- read.table("M81E_DESeq2.TSV", header = T, sep = '\t')
#M81E <- M81E[grep(pattern = 'SbiLnc', M81E$Transcript),]
M81E <- M81E[M81E$padj < FDR,]
#M81E <- M81E[abs(M81E$log2FoldChange) > log2foldchange,]
M81E <- M81E[!is.na(M81E$padj),]

L2 <- EnhancedVolcano(M81E,
                      lab = M81E$Transcript,
                      x = 'log2FoldChange',
                      y = 'pvalue',
                      title = 'M-81E',
                      subtitle = NULL,
                      caption = paste0("total = ", length(M81E$Transcript[abs(M81E$log2FoldChange) > log2foldchange]), " DEGs"),
                      captionLabSize = 18,
                      pCutoff = 10e-04,
                      ylim = c(0,100),
                      xlim = c(-10,10),
                      labSize = 4,
                      legendLabSize = 10,
                      FCcutoff = 2)

library(cowplot)

pdf("Roma_vs_M81E_volcano.pdf", width = 12, height=7)
cowplot::plot_grid(L1, L2, ncol=2, labels= NULL)
dev.off()