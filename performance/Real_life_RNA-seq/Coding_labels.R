setwd('/home/mpilab/Performance2/Real_life_RNAseq/')
library(dplyr)
library(tidyverse)
dataframes <- list()
for (i in c("CPAT_human", "CPAT_plants", "CPAT_sorghum", "CPC2", "FEELnc_arabidopsis", 
            "FEELnc_human", "FEELnc_sorghum", "LGC", "LncFinder_human", 
            "LncFinder_plants", "LncFinder_sorghum", "Pfamscan", "RNAsamba_fl",
            "RNAsamba_pl", "RNAsamba_sorghum")) {
  df <- read.table(paste0( i, '.TSV'), header = TRUE, sep = '\t')
  colnames(df)[2] <- paste0(i)
  df <- df[-3]
  dataframes[[i]] <- df
}

data <- dataframes %>% reduce(inner_join)
write.table(data,'Coding_labels.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
