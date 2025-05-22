setwd('/home/mpilab/Performance2/Final_ROC/')
library(reshape2)
library(dplyr)
library(stringr)
data <- read.table('Performance_metrics.TSV', header = T, sep = '\t')
data$Model <- str_replace_all(pattern = '_', replacement = ' ',string = data$Model)
approach <- c(data$Model[4:15],data$Model[1:3])
data <- melt(data)
colnames(data)[2] <- 'Metric'
data$Metric <- sub(pattern = 'F1.Score', replacement = 'F1-Score',data$Metric)
data$Model <- factor(data$Model, levels = approach)

cbPalette <- c( "#2986cc", "#ce7e00", "#8fce00", '#6a329f', '#f1c232',"#f44336")

library(ggplot2)
pdf('Performance_metrics.pdf', width = 7, height = 5)
data %>%
  ggplot(aes(x = Model, y = value, colour = Metric, group = Metric)) +
  geom_line(#linewidth = 0.75
    ) +
  geom_point(shape = 21, fill = 'white', size = 2) +  
  ylim(0, 1) + 
  theme_bw() + 
  xlab('Test model') + 
  ylab('') +
  theme(text = element_text(size = 18)) +  
  scale_colour_manual(values = cbPalette) +  
  theme(
    axis.text.x = element_text(size = 8, angle = 45, hjust = 1),  
    axis.title = element_blank(), 
    legend.position = 'bottom',  
    legend.title = element_text(size = 10), 
    legend.text = element_text(size = 8)
  ) + ylim(0.4,1.0) +
  labs(colour = 'Performance Metrics')
dev.off()