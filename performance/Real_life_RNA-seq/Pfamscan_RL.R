library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('Pfamscan/Fold_', i, '_pfamscan.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

Pfamscan <- bind_rows(fold_data)
write.table(Pfamscan, 'Pfamscan.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

Pfamscan1 <- Pfamscan %>% group_by(Subset,Label) %>% summarise(Count=n())
Pfamscan1 <- Pfamscan1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
Pfamscan1 <- dcast(data = Pfamscan1, Subset ~ Label)
write.table(Pfamscan1, 'Pfamscan_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

Pfamscan2 <- Pfamscan %>% group_by(Label) %>% summarise(Count=n())
Pfamscan2 <- Pfamscan2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(Pfamscan2, 'Pfamscan_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)