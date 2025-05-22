library(dplyr)
library(reshape2)
library(tidyverse)
setwd('/home/mpilab/Performance2/Real_life_RNAseq/')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('LGC/Fold_', i, '_LGC.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

LGC <- bind_rows(fold_data)
write.table(LGC, 'LGC.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

LGC1 <- LGC %>% group_by(Subset,Label) %>% summarise(Count=n())
LGC1 <- LGC1 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
LGC1 <- dcast(data = LGC1, Subset ~ Label)
write.table(LGC1, 'LGC_folds.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

LGC2 <- LGC %>% group_by(Label) %>% summarise(Count=n())
LGC2 <- LGC2 %>% mutate(Label=if_else(Label==1,'Non-coding','Coding'))
write.table(LGC2, 'LGC_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)