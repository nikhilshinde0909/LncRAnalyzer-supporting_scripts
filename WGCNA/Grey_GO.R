library(org.Sbicolor.eg.db)
library(clusterProfiler)
library(enrichplot)
library(dplyr)
library(stringr)
pvalue_cutoff=0.05

setwd('/home/mpilab/sorghum_salt/WGCNA/')

data <- read.table('grey_module.TSV', header = T, sep = '\t')

x <- enrichGO(gene = data$gene_id,
              OrgDb = org.Sbicolor.eg.db,  pvalueCutoff=0.5, qvalueCutoff = 0.5,
              ont = "ALL",
              keyType = "GID")
head(x)

results <- x@result
results <- results[,c(1,3,10,13)]
rownames(results) <- NULL
results <- results[!duplicated(results$p.adjust),]
results$Description <- str_replace_all(pattern = 'oxidoreductase activity, acting on single donors with incorporation of molecular oxygen',
                                        replacement = 'oxidoreductase activity', string = results$Description)
library(ggplot2)

pdf('Grey_module_GO.pdf', width = 12, height = 8)
results %>% ggplot(aes(x = Description, y = Count, fill = p.adjust)) +
  geom_bar(stat = "identity") +
  facet_grid(. ~ ONTOLOGY, scales = 'free_y') +
  coord_flip() +
  scale_fill_gradient(high = '#cfe2f3', low  = '#2986cc', name = "p-value") +
  labs(x = "GO Terms", y = "Count") +
  theme(strip.text = element_text(size = 14), axis.title = element_text(size = 14), 
        axis.text = element_text(size = 12), legend.key.size = unit( 1, 'cm'),
        legend.text = element_text(size=10)) 
dev.off()
