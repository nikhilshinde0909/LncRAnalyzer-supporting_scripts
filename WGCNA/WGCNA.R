library(WGCNA)
library(dplyr)
library(tidyverse)
allowWGCNAThreads(nThreads = 16) 

setwd('/home/mpilab/sorghum_salt/')
data <- read.table('WGCNA/DESeq2_normalized.TSV', header = T, sep = '\t')
data <- data %>% column_to_rownames(var = 'Transcript')

phenoData <- read.table('Experimental_design.TSV', header = T, sep = '\t')
phenoData <- phenoData %>% column_to_rownames(var = 'Run')
trait <- phenoData %>% mutate(Genotype = ifelse(grepl('M81E', Genotype), 1, 0),
                              Condition = ifelse(grepl('Salt stress', Condition), 1, 0))
data <- as.data.frame(data[,rownames(phenoData)])
data <- t(data)
powers = c(c(1:10), seq(from = 12, to = 20, by = 2))
sft <- pickSoftThreshold(
  data,             
  powerVector = powers,
  verbose = 5
)

par(mfrow = c(1,2));
cex1 = 0.9;
pdf('WGCNA/get_powers.pdf')
plot(sft$fitIndices[, 1],
     -sign(sft$fitIndices[, 3]) * sft$fitIndices[, 2],
     xlab = "Soft Threshold (power)",
     ylab = "Scale Free Topology Model Fit, signed R^2",
     main = paste("Scale independence")
)
text(sft$fitIndices[, 1],
     -sign(sft$fitIndices[, 3]) * sft$fitIndices[, 2],
     labels = powers, cex = cex1, col = "red"
)
abline(h = 0.85, col = "red")
plot(sft$fitIndices[, 1],
     sft$fitIndices[, 5],
     xlab = "Soft Threshold (power)",
     ylab = "Mean Connectivity",
     type = "n",
     main = paste("Mean connectivity")
)
text(sft$fitIndices[, 1],
     sft$fitIndices[, 5],
     labels = powers,
     cex = cex1, col = "red")
dev.off()

picked_power = 10
temp_cor <- cor       
cor <- WGCNA::cor      
netwk <- blockwiseModules(data,
                          power = picked_power,            
                          networkType = "signed",
                          deepSplit = 2,
                          pamRespectsDendro = F,
                          # detectCutHeight = 0.75,
                          minModuleSize = 30,
                          maxBlockSize = 14000,
                          reassignThreshold = 0,
                          mergeCutHeight = 0.25,
                          saveTOMs = T,
                          saveTOMFileBase = "ER",
                          numericLabels = T,
                          verbose = 3)
cor <- temp_cor
table(netwk$colors)
table(netwk$unmergedColors)
mergedColors = labels2colors(netwk$colors)
unmergedColors = labels2colors(netwk$unmergedColors)
pdf('WGCNA/cluster_dendrogram.pdf')
plotDendroAndColors(
  netwk$dendrograms[[1]], 
  cbind(mergedColors[netwk$blockGenes[[1]]],  
  unmergedColors[netwk$blockGenes[[1]]]),  
  c("Merged","Unmerged"), 
  dendroLabels = FALSE,  
  addGuide = TRUE,  
  hang = 0.03,  
  guideHang = 0.05 
)
dev.off()


module_df <- data.frame(
  gene_id = names(netwk$colors),
  colors = labels2colors(netwk$colors)
)

MEs0 <- moduleEigengenes(data, mergedColors)$eigengenes

MEs0 <- orderMEs(MEs0)
module_order = names(MEs0) %>% gsub("ME","", .)

MEs0$treatment = row.names(MEs0)

mME = MEs0 %>%
  pivot_longer(-treatment) %>%
  mutate(
    name = gsub("ME", "", name),
    name = factor(name, levels = module_order)
  )
write.table(mME, 'WGCNA/Module_trait.TSV', row.names = F,quote = F,
            col.names = T, sep = '\t')
pdf('WGCNA/Module-trait_relationships.pdf')
mME %>% ggplot(., aes(x=treatment, y=name, fill=value)) +
  geom_tile() +
  theme_bw() +
  scale_fill_gradient2(
    low = "blue",
    high = "red",
    mid = "white",
    midpoint = 0,
    limit = c(-1,1)) +
  theme(axis.text.x = element_text(angle=90)) +
  labs(title = "Module-trait Relationships", y = "Modules", fill="corr")
dev.off()

modules_of_interest = c("grey","brown")
submod = module_df %>%
  subset(colors %in% modules_of_interest)
row.names(module_df) = module_df$gene_id
subexpr = t(data)[submod$gene_id,]

submod_df = data.frame(subexpr) %>%
  mutate(
    gene_id = row.names(.)
  ) %>%
  pivot_longer(-gene_id) %>%
  mutate(
    module = module_df[gene_id,]$colors
  )
submod2 <- submod[submod$colors=='grey',]
write.table(submod2, 'WGCNA/grey_module.TSV',row.names = F, col.names = T, sep = '\t', quote = F)
pdf('WGCNA/normalized_expression.pdf', width = 5, height = 3)
submod_df %>% ggplot(., aes(x=name, y=value, group=gene_id)) +
  geom_line(aes(color = module),
            alpha = 0.2) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 90)
  ) +
  facet_grid(rows = vars(module)) +
  labs(x = "treatment",
       y = "normalized expression")
dev.off()

genes_of_interest = module_df %>%
  subset(colors %in% modules_of_interest)

expr_of_interest = t(data)[genes_of_interest$gene_id,]
expr_of_interest[1:5,1:5]

TOM = TOMsimilarityFromExpr(t(expr_of_interest),
                            power = picked_power)

row.names(TOM) = row.names(expr_of_interest)
colnames(TOM) = row.names(expr_of_interest)

edge_list = data.frame(TOM) %>%
  mutate(
    gene1 = row.names(.)
  ) %>%
  pivot_longer(-gene1) %>%
  dplyr::rename(gene2 = name, correlation = value) %>%
  unique() %>%
  subset(!(gene1==gene2)) %>%
  mutate(
    module1 = module_df[gene1,]$colors,
    module2 = module_df[gene2,]$colors
  )

head(edge_list)
colnames(edge_list) <- c("Source", "Target","Correlation","Module1","Modeule2")
nSamples <- nrow(data)
nGenes <- ncol(data)
gene.signf.corr <- cor(data, trait$Condition, use = 'p')
gene.signf.corr.pvals <- corPvalueStudent(gene.signf.corr, nSamples)
gene.signf.corr.pvals <- gene.signf.corr.pvals %>% 
  as.data.frame() %>% 
  arrange(V1)
gene.signf.corr.pvals <- gene.signf.corr.pvals %>% rownames_to_column('Transcript')
colnames(gene.signf.corr.pvals)[2] <- c('P-value')
gene.signf.corr.pvals <- gene.signf.corr.pvals[gene.signf.corr.pvals$`P-value` < 0.05,]
M81E_edgelist <- edge_list[edge_list$Module1=="grey",]
M81E_edgelist <- M81E_edgelist[M81E_edgelist$Source %in% gene.signf.corr.pvals$Transcript,]
Roma_edgelist <- edge_list[edge_list$Module1=="brown",]
Roma_edgelist <- Roma_edgelist[Roma_edgelist$Source %in% gene.signf.corr.pvals$Transcript,]
write.table(M81E_edgelist, "WGCNA/M81E_Edges.TSV", row.names = F, 
            col.names = T, sep = '\t', quote = F)
