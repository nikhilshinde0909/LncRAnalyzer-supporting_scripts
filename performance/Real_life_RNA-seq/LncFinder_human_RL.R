library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('LncFinder/Fold_', i, '_LncFinder_human.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

LncFinder_human <- bind_rows(fold_data)
write.table(LncFinder_human, 'LncFinder_human.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

LncFinder_human1 <- LncFinder_human %>% group_by(Subset,Label) %>% summarise(Count=n())
LncFinder_human1 <- LncFinder_human1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
LncFinder_human1 <- dcast(data = LncFinder_human1, Subset ~ Label)
write.table(LncFinder_human1, 'LncFinder_human_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

LncFinder_human2 <- LncFinder_human %>% group_by(Label) %>% summarise(Count=n())
LncFinder_human2 <- LncFinder_human2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(LncFinder_human2, 'LncFinder_human_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)