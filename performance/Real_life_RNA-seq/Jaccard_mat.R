setwd('/home/mpilab/Performance2/Real_life_RNAseq/')
library(pheatmap)
library(RColorBrewer)
library(stringr)
data <- read.table('Jaccard_distance.TSV', header = T, sep = '\t', row.names = 1)
colnames(data) <- str_replace_all(pattern = '\\.',replacement  = '-', colnames(data))
names(data) <- str_replace_all(pattern = '-length',replacement  = ' length', colnames(data))
data <- as.matrix(data)
col_pal <- brewer.pal(name = 'Reds',9)
tiff('Jaccard_dist.tiff', width = 17.5, height = 17.5, units = 'cm', res = 300)
pheatmap(
  mat = data, 
  color = rev(col_pal), 
  border_color = NA, 
  fontsize_row = 8,
  fontsize = 8, 
  display_numbers = TRUE, 
  number_color = 'black',     
  number_format = "%.3f", 
  fontsize_number = 6
)
dev.off()
