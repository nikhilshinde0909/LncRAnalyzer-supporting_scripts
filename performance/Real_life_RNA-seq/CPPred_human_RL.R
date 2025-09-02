library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPPred/Fold_', i, '_cppred_human.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPPred_human <- bind_rows(fold_data)
write.table(CPPred_human, 'CPPred_human.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPPred_human1 <- CPPred_human %>% group_by(Subset,Label) %>% summarise(Count=n())
CPPred_human1 <- CPPred_human1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
CPPred_human1 <- dcast(data = CPPred_human1, Subset ~ Label)
write.table(CPPred_human1, 'CPPred_human_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPPred_human2 <- CPPred_human %>% group_by(Label) %>% summarise(Count=n())
CPPred_human2 <- CPPred_human2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(CPPred_human2, 'CPPred_human_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)