library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('FEELnc/Fold_', i, '_FEELnc_arabidopsis.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

FEELnc_arabidopsis <- bind_rows(fold_data)
write.table(FEELnc_arabidopsis, 'FEELnc_arabidopsis.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

FEELnc_arabidopsis1 <- FEELnc_arabidopsis %>% group_by(Subset,Label) %>% summarise(Count=n())
FEELnc_arabidopsis1 <- FEELnc_arabidopsis1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
FEELnc_arabidopsis1 <- dcast(data = FEELnc_arabidopsis1, Subset ~ Label)
FEELnc_arabidopsis1[is.na(FEELnc_arabidopsis1)] <- 0 
write.table(FEELnc_arabidopsis1, 'FEELnc_arabidopsis_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

FEELnc_arabidopsis2 <- FEELnc_arabidopsis %>% group_by(Label) %>% summarise(Count=n())
FEELnc_arabidopsis2 <- FEELnc_arabidopsis2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(FEELnc_arabidopsis2, 'FEELnc_arabidopsis_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)