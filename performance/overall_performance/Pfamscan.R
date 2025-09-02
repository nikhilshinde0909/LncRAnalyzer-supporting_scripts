library(dplyr)
library(caret)
library(pROC)
library(tidyverse)
setwd('/home/mpilab/Performance2/')

True_labels <- read.table('True_labels.TSV', header = T, sep = '\t')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('PfamScan//Fold_', i, '_pfamscan.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
}

Pfamscan <- bind_rows(fold_data)
Pfamscan <- list(True_labels,Pfamscan) %>% reduce(inner_join)

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
    Sensitivity = sensitivity,
    Specificity = specificity,
    Accuracy = accuracy,
    Precision = precision,
    F1_Score = f1_score,
    AUC = auc_value
  )
  
  return(result)
}

Pfamscan_metrics <- Pfamscan %>%
  do(calculate_metrics(.))

write.table(Pfamscan, 'Final_ROC/Pfamscan.TSV', row.names = F, col.names = T, 
            sep = '\t', quote = F)

write.table(Pfamscan_metrics, 'Final_ROC/Pfamscan_metrics.TSV', row.names = F, col.names = T, 
            sep = '\t', quote = F)

