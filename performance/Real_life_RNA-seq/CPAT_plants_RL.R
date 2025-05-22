library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPAT/Fold_', i, '_cpat_plants.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPAT_plants <- bind_rows(fold_data)
write.table(CPAT_plants, 'CPAT_plants.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)
CPAT_plants1 <- CPAT_plants %>% group_by(Subset,Label) %>% summarise(Count=n())
CPAT_plants1 <- CPAT_plants1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
CPAT_plants1 <- dcast(data = CPAT_plants1, Subset ~ Label)
write.table(CPAT_plants1, 'CPAT_plants_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

CPAT_plants2 <- CPAT_plants %>% group_by(Label) %>% summarise(Count=n())
CPAT_plants2 <- CPAT_plants2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(CPAT_plants2, 'CPAT_plants_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)