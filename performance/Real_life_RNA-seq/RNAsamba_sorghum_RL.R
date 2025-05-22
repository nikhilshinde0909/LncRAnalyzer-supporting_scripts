library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('RNAsamba/Fold_', i, '_rnasamba_sorghum.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

RNAsamba_sorghum <- bind_rows(fold_data)
write.table(RNAsamba_sorghum, 'RNAsamba_sorghum.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

RNAsamba_sorghum1 <- RNAsamba_sorghum %>% group_by(Subset,Label) %>% summarise(Count=n())
RNAsamba_sorghum1 <- RNAsamba_sorghum1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
RNAsamba_sorghum1 <- dcast(data = RNAsamba_sorghum1, Subset ~ Label)
write.table(RNAsamba_sorghum1, 'RNAsamba_sorghum_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

RNAsamba_sorghum2 <- RNAsamba_sorghum %>% group_by(Label) %>% summarise(Count=n())
RNAsamba_sorghum2 <- RNAsamba_sorghum2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(RNAsamba_sorghum2, 'RNAsamba_sorghum_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)