library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPC2/Fold_', i, '_cpc2.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPC2 <- bind_rows(fold_data)
write.table(CPC2, 'CPC2.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPC21 <- CPC2 %>% group_by(Subset,Label) %>% summarise(Count=n())
CPC21 <- CPC21 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
CPC21 <- dcast(data = CPC21, Subset ~ Label)
write.table(CPC21, 'CPC2_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPC22 <- CPC2 %>% group_by(Label) %>% summarise(Count=n())
CPC22 <- CPC22 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(CPC22, 'CPC2_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)