setwd('/home/mpilab/sorghum_salt/')
pvalue1 = 0.05
pvalue2 = 0.01

# Roma
Roma <- read.table('Roma_DESeq2.TSV', header = T, sep = '\t')
Roma_cis <- Roma[Roma$padj < pvalue1,]
Roma_cis <- Roma_cis[,c(1,8:ncol(Roma_cis))]
Roma_cis_Lnc <- Roma_cis[grep(pattern = 'SbiLnc',Roma_cis$Transcript),]
Roma_cis_PCG <- Roma_cis[grep(pattern = 'SbiLnc',Roma_cis$Transcript, invert = T),]
write.table(Roma_cis_Lnc,'Targets/Roma/Cis_Lnc.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
write.table(Roma_cis_PCG,'Targets/Roma/Cis_PCG.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
Roma_trans <- Roma[Roma$padj < pvalue2,]
Roma_trans <- Roma_trans[,c(1,8:ncol(Roma_trans))]
Roma_trans_Lnc <- Roma_trans[grep(pattern = 'SbiLnc',Roma_trans$Transcript),]
Roma_trans_PCG <- Roma_trans[grep(pattern = 'SbiLnc',Roma_trans$Transcript, invert = T),]
write.table(Roma_trans_Lnc,'Targets/Roma/Trans_Lnc.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
write.table(Roma_trans_PCG,'Targets/Roma/Trans_PCG.TSV', row.names = F, col.names = T, sep = '\t', quote = F)

# M81-E
M81E <- read.table('M81E_DESeq2.TSV', header = T, sep = '\t')
M81E_cis <- M81E[M81E$padj < pvalue1,]
M81E_cis <- M81E_cis[,c(1,8:ncol(M81E_cis))]
M81E_cis_Lnc <- M81E_cis[grep(pattern = 'SbiLnc',M81E_cis$Transcript),]
M81E_cis_PCG <- M81E_cis[grep(pattern = 'SbiLnc',M81E_cis$Transcript, invert = T),]
write.table(M81E_cis_Lnc,'Targets/M81E/Cis_Lnc.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
write.table(M81E_cis_PCG,'Targets/M81E/Cis_PCG.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
M81E_trans <- M81E[M81E$padj < pvalue2,]
M81E_trans <- M81E_trans[,c(1,8:ncol(M81E_trans))]
M81E_trans_Lnc <- M81E_trans[grep(pattern = 'SbiLnc',M81E_trans$Transcript),]
M81E_trans_PCG <- M81E_trans[grep(pattern = 'SbiLnc',M81E_trans$Transcript, invert = T),]
write.table(M81E_trans_Lnc,'Targets/M81E/Trans_Lnc.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
write.table(M81E_trans_PCG,'Targets/M81E/Trans_PCG.TSV', row.names = F, col.names = T, sep = '\t', quote = F)