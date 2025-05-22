library(dplyr)
library(caret)
library(pROC)
library(tidyverse)
library(ggplot2)
setwd('/home/mpilab/Performance2/')

True_labels <- read.table('True_labels.TSV', header = T, sep = '\t')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPAT/Fold_', i, '_cpat_plants.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPAT_Plants <- bind_rows(fold_data)
data <- CPAT_Plants %>% group_by(Subset,Label) %>% summarise(Count=n())
data <- data %>% mutate(Label=if_else(condition = Label==1,true = 'Non-coding',false = 'Coding'))
data <- data %>% 
  group_by(Subset) %>% 
  mutate(Preportion = Count / sum(Count))

data$Subset <- factor(data$Subset,levels = paste0(rep('Fold ',10), 1:10))
mycol <- c('#8fce00', '#2986cc')
# Small multiple
tiff('Test_sets.tiff', width = 15, height = 15, units = 'cm', res = 600)
data %>% ggplot(aes(fill=Label, y=Preportion, x=Subset)) + 
  geom_bar(position="stack", stat="identity", alpha=0.7, width = 0.5) +
  scale_fill_manual(values =mycol ) +
  theme(axis.text.x = element_text(hjust = 1, angle = 45, size = 8))+
  xlab("Test sets") +
  ylab("Proportion") +
  guides(fill=guide_legend(title="",position = 'top')) +
  theme(axis.text  = element_text(size = 10), legend.text = element_text(size = 8))
dev.off()