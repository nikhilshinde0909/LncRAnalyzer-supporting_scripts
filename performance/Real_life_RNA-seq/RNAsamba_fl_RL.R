library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('RNAsamba/Fold_', i, '_rnasamba_fl.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

RNAsamba_fl <- bind_rows(fold_data)
write.table(RNAsamba_fl, 'RNAsamba_fl.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

RNAsamba_fl1 <- RNAsamba_fl %>% group_by(Subset,Label) %>% summarise(Count=n())
RNAsamba_fl1 <- RNAsamba_fl1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
RNAsamba_fl1 <- dcast(data = RNAsamba_fl1, Subset ~ Label)
write.table(RNAsamba_fl1, 'RNAsamba_fl_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

RNAsamba_fl2 <- RNAsamba_fl %>% group_by(Label) %>% summarise(Count=n())
RNAsamba_fl2 <- RNAsamba_fl2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(RNAsamba_fl2, 'RNAsamba_fl_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)