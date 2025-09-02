library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('LncFinder/Fold_', i, '_LncFinder_plants.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

LncFinder_plants <- bind_rows(fold_data)
write.table(LncFinder_plants, 'LncFinder_plants.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

LncFinder_plants1 <- LncFinder_plants %>% group_by(Subset,Label) %>% summarise(Count=n())
LncFinder_plants1 <- LncFinder_plants1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
LncFinder_plants1 <- dcast(data = LncFinder_plants1, Subset ~ Label)
write.table(LncFinder_plants1, 'LncFinder_plants_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

LncFinder_plants2 <- LncFinder_plants %>% group_by(Label) %>% summarise(Count=n())
LncFinder_plants2 <- LncFinder_plants2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(LncFinder_plants2, 'LncFinder_plants_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)