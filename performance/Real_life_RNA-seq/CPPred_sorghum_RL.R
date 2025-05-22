library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPPred/Fold_', i, '_cppred_sorghum.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPPred_sorghum <- bind_rows(fold_data)
write.table(CPPred_sorghum, 'CPPred_sorghum.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPPred_sorghum1 <- CPPred_sorghum %>% group_by(Subset,Label) %>% summarise(Count=n())
CPPred_sorghum1 <- CPPred_sorghum1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
CPPred_sorghum1 <- dcast(data = CPPred_sorghum1, Subset ~ Label)
write.table(CPPred_sorghum1, 'CPPred_sorghum_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPPred_sorghum2 <- CPPred_sorghum %>% group_by(Label) %>% summarise(Count=n())
CPPred_sorghum2 <- CPPred_sorghum2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(CPPred_sorghum2, 'CPPred_sorghum_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)