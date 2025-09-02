library(dplyr)
library(tidyverse)
setwd('/home/mpilab/Performance2/Final_ROC/')
ROC <- read.table('ROC_values.TSV', header = T, sep = '\t')

ROC2 <- ROC %>%
  arrange(FPR, Approach) %>%
  group_by(Approach) %>%
  mutate(
    FPR_interpolated = list(seq(min(FPR), max(FPR), length.out = 1000)),
    TPR_interpolated = map(FPR_interpolated, ~ approx(FPR, TPR, xout = .x)$y)
  ) %>%
  ungroup() %>%
  unnest(cols = c(FPR_interpolated, TPR_interpolated)) 

ROC2 <- ROC2[,c(4,5,3)]
colnames(ROC2)[c(1,2)] <- c('FPR','TPR')
write.table(ROC2,'ROC_values2.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
