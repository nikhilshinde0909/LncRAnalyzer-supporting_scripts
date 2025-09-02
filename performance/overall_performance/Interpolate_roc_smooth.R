setwd('/home/mpilab/Performance2/Final_ROC/')
library(dplyr)  # for bind_rows

data <- read.table('ROC_values.TSV', header = TRUE, sep = '\t')

# Get unique approaches
approaches <- unique(data$Approach)

smoothed_list <- list()

for (app in approaches) {
  df_app <- data[data$Approach == app, ]
  df_app <- df_app[order(df_app$FPR), ]
  smooth <- spline(x = df_app$FPR, y = df_app$TPR, n = 100, method = 'hyman')
  
  smoothed_df <- data.frame(
    Approach = app,
    FPR = smooth$x,
    TPR = smooth$y
  )
  
  smoothed_list[[app]] <- smoothed_df
}

data <- bind_rows(smoothed_list)
data <- data %>% group_by(Approach) %>%
  mutate(TPR = (TPR - min(TPR)) / (max(TPR) - min(TPR)),
         FPR = (FPR - min(FPR)) / (max(FPR) - min(FPR)))

write.table(data,'ROC_values5.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
