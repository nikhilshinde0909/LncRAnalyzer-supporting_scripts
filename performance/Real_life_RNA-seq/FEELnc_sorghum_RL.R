library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('FEELnc/Fold_', i, '_FEELnc_sorghum.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

FEELnc_sorghum <- bind_rows(fold_data)
write.table(FEELnc_sorghum, 'FEELnc_sorghum.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

FEELnc_sorghum1 <- FEELnc_sorghum %>% group_by(Subset,Label) %>% summarise(Count=n())
FEELnc_sorghum1 <- FEELnc_sorghum1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
FEELnc_sorghum1 <- dcast(data = FEELnc_sorghum1, Subset ~ Label)
FEELnc_sorghum1[is.na(FEELnc_sorghum1)] <- 0 
write.table(FEELnc_sorghum1, 'FEELnc_sorghum_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

FEELnc_sorghum2 <- FEELnc_sorghum %>% group_by(Label) %>% summarise(Count=n())
FEELnc_sorghum2 <- FEELnc_sorghum2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(FEELnc_sorghum2, 'FEELnc_sorghum_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)