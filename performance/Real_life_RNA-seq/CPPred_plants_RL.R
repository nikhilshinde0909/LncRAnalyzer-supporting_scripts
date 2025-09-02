library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPPred/Fold_', i, '_cppred_plants.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPPred_plants <- bind_rows(fold_data)
write.table(CPPred_plants, 'CPPred_plants.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPPred_plants1 <- CPPred_plants %>% group_by(Subset,Label) %>% summarise(Count=n())
CPPred_plants1 <- CPPred_plants1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
CPPred_plants1 <- dcast(data = CPPred_plants1, Subset ~ Label)
write.table(CPPred_plants1, 'CPPred_plants_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPPred_plants2 <- CPPred_plants %>% group_by(Label) %>% summarise(Count=n())
CPPred_plants2 <- CPPred_plants2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(CPPred_plants2, 'CPPred_plants_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)