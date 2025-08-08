setwd('/home/mpilab/Performance2/Final_ROC/')
library(dplyr)  # for bind_rows

data <- read.table('ROC_values.TSV', header = TRUE, sep = '\t')

# Get unique approaches
approaches <- unique(data$Approach)

# Create an empty list to store smoothed data frames
smoothed_list <- list()

for (app in approaches) {
  df_app <- data[data$Approach == app, ]
  spline_fun <- splinefun(df_app$FPR, df_app$TPR, method = "hyman")

  FPR_seq <- seq(min(df_app$FPR), max(df_app$FPR), length.out = 100)

  TPR_smooth <- spline_fun(FPR_seq)

  smoothed_df <- data.frame(
    Approach = app,
    FPR = FPR_seq,
    TPR = TPR_smooth
  )
  
  smoothed_list[[app]] <- smoothed_df
}

data <- bind_rows(smoothed_list)
write.table(data,'ROC_values5.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
