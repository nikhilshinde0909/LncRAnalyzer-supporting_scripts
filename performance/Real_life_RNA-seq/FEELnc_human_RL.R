library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('FEELnc/Fold_', i, '_FEELnc_human.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

FEELnc_human <- bind_rows(fold_data)
write.table(FEELnc_human, 'FEELnc_human.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

FEELnc_human1 <- FEELnc_human %>% group_by(Subset,Label) %>% summarise(Count=n())
FEELnc_human1 <- FEELnc_human1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
FEELnc_human1 <- dcast(data = FEELnc_human1, Subset ~ Label)
FEELnc_human1[is.na(FEELnc_human1)] <- 0 
write.table(FEELnc_human1, 'FEELnc_human_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

FEELnc_human2 <- FEELnc_human %>% group_by(Label) %>% summarise(Count=n())
FEELnc_human2 <- FEELnc_human2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(FEELnc_human2, 'FEELnc_human_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)