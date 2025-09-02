library(dplyr)
library(caret)
library(pROC)
library(tidyverse)
setwd('/home/mpilab/Performance2/')

True_labels <- read.table('True_labels.TSV', header = T, sep = '\t')


fold_data <- list()
for (i in 1:10) {
  file_path <- paste0('CPPred/Fold_', i, '_cppred_plants.TSV')
  fold_data[[i]] <- read.table(file_path, header = TRUE, sep = '\t')
  fold_data[[i]]$Subset <- paste('Fold', i)
}

CPPred_plants <- bind_rows(fold_data)
CPPred_plants <- list(True_labels,CPPred_plants) %>% reduce(inner_join)
CPPred_plants <- CPPred_plants %>% group_by(Subset) %>% arrange(Subset)

CPPred_plants1 <- CPPred_plants %>% group_by(Subset,Class,Label) %>% summarise(Count=n())
write.table(CPPred_plants1, 'CPPred_plants_summary.TSV', row.names = F, col.names = T,
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

CPPred_plants_metrics <- CPPred_plants %>%
  group_by(Subset) %>%
  do(calculate_metrics(.)) %>%
  ungroup()
write.table(CPPred_plants_metrics, 'CPPred_plants_metrics.TSV', row.names = F, col.names = T,
            sep = '\t', quote = F)
