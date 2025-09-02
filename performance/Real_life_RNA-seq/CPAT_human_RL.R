library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPAT/Fold_', i, '_cpat_human.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPAT_human <- bind_rows(fold_data)
write.table(CPAT_human, 'CPAT_human.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPAT_human1 <- CPAT_human %>% group_by(Subset,Label) %>% summarise(Count=n())
CPAT_human1 <- CPAT_human1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
CPAT_human1 <- dcast(data = CPAT_human1, Subset ~ Label)
write.table(CPAT_human1, 'CPAT_human_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPAT_human2 <- CPAT_human %>% group_by(Label) %>% summarise(Count=n())
CPAT_human2 <- CPAT_human2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(CPAT_human2, 'CPAT_human_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)