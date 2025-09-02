library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('LncFinder/Fold_', i, '_LncFinder_sorghum.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

LncFinder_sorghum <- bind_rows(fold_data)
write.table(LncFinder_sorghum, 'LncFinder_sorghum.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

LncFinder_sorghum1 <- LncFinder_sorghum %>% group_by(Subset,Label) %>% summarise(Count=n())
LncFinder_sorghum1 <- LncFinder_sorghum1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
LncFinder_sorghum1 <- dcast(data = LncFinder_sorghum1, Subset ~ Label)
write.table(LncFinder_sorghum1, 'LncFinder_sorghum_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

LncFinder_sorghum2 <- LncFinder_sorghum %>% group_by(Label) %>% summarise(Count=n())
LncFinder_sorghum2 <- LncFinder_sorghum2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(LncFinder_sorghum2, 'LncFinder_sorghum_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)