library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('RNAsamba/Fold_', i, '_rnasamba_pl.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

RNAsamba_pl <- bind_rows(fold_data)
write.table(RNAsamba_pl, 'RNAsamba_pl.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

RNAsamba_pl1 <- RNAsamba_pl %>% group_by(Subset,Label) %>% summarise(Count=n())
RNAsamba_pl1 <- RNAsamba_pl1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
RNAsamba_pl1 <- dcast(data = RNAsamba_pl1, Subset ~ Label)
write.table(RNAsamba_pl1, 'RNAsamba_pl_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

RNAsamba_pl2 <- RNAsamba_pl %>% group_by(Label) %>% summarise(Count=n())
RNAsamba_pl2 <- RNAsamba_pl2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(RNAsamba_pl2, 'RNAsamba_pl_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)