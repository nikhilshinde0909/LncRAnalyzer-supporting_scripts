library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPAT/Fold_', i, '_cpat_sorghum.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPAT_Sorghum <- bind_rows(fold_data)
write.table(CPAT_Sorghum, 'CPAT_sorghum.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPAT_Sorghum1 <- CPAT_Sorghum %>% group_by(Subset,Label) %>% summarise(Count=n())
CPAT_Sorghum1 <- CPAT_Sorghum1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
CPAT_Sorghum1 <- dcast(data = CPAT_Sorghum1, Subset ~ Label)
write.table(CPAT_Sorghum1, 'CPAT_sorghum_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPAT_Sorghum2 <- CPAT_Sorghum %>% group_by(Label) %>% summarise(Count=n())
CPAT_Sorghum2 <- CPAT_Sorghum2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(CPAT_Sorghum2, 'CPAT_sorghum_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)