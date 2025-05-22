library(dplyr)
library(caret)
library(pROC)
library(tidyverse)
setwd('/home/mpilab/Performance2/')

True_labels <- read.table('True_labels.TSV', header = T, sep = '\t')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('RNAsamba/Fold_', i, '_rnasamba_fl.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

RNAsamba_fl <- bind_rows(fold_data)
RNAsamba_fl <- list(True_labels,RNAsamba_fl) %>% reduce(inner_join)
RNAsamba_fl <- RNAsamba_fl %>% group_by(Subset) %>% arrange(Subset)

RNAsamba_fl1 <- RNAsamba_fl %>% group_by(Subset,Class,Label) %>% summarise(Count=n())
write.table(RNAsamba_fl1, 'RNAsamba_fl_summary.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)

calculate_metrics <- function(subset_data) {
  conf_matrix <- confusionMatrix(as.factor(subset_data$Label), as.factor(subset_data$Class))
  
  sensitivity <- conf_matrix$byClass["Sensitivity"]
  specificity <- conf_matrix$byClass["Specificity"]
  accuracy <- conf_matrix$overall["Accuracy"]
  precision <- conf_matrix$byClass["Precision"]
  f1_score <- conf_matrix$byClass["F1"]
  roc_curve <- roc(subset_data$Class, subset_data$Label)
  auc_value <- as.numeric(auc(roc_curve))  
  
  result <- data.frame(
    Subset = unique(subset_data$Subset),
    Sensitivity = sensitivity,
    Specificity = specificity,
    Accuracy = accuracy,
    Precision = precision,
    F1_Score = f1_score,
    AUC = auc_value
  )
  
  return(result)
}

RNAsamba_fl_metrics <- RNAsamba_fl %>%
  group_by(Subset) %>%
  do(calculate_metrics(.)) %>%
  ungroup()
write.table(RNAsamba_fl_metrics, 'RNAsamba_fl_metrics.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)
