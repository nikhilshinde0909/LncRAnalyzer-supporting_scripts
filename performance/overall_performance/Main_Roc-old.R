setwd('/home/mpilab/Performance2/Final_ROC/')
library(dplyr)
data <- read.table('ROC_values2.TSV', header = T, sep = '\t')
sigmoid <- function(x, k = 1) {
  return(1 / (1 + exp(-k * (x - 0.5))))
}

data <- data %>% group_by(Approach) %>% mutate(FPR=sigmoid(x = FPR,k=10), TPR=sigmoid(TPR,k = 10))
approach <- c("CPAT-Sorghum", "CPAT-Plants", "CPAT-Human",
              "FEELnc-Sorghum","FEELnc-Arabidopsis", "FEELnc-Human", 
              "LncFinder-Sorghum","LncFinder-Plants", "LncFinder-Human",
              "RNAsamba-Sorghum","RNAsamba-full length","RNAsamba-partial length",
              "CPC2", "LGC", "PfamScan")
# Define the color palette
cbPalette <- c( "#16537e", "#3d85c6","#9fc5e8", 
                "#ce7e00", "#bf9000",'#ffe599',
                "#38761d","#93c47d","#8fce00",
                "#351c75", "#6a329f", "#b4a7d6",
                "#744700","#741b47","#f44336")
data$Approach <- factor(x = data$Approach,levels = approach)
# Make the plot
library(ggplot2)
p <- data %>% ggplot(aes(x = FPR, y = TPR, group = Approach, colour = Approach)) +
  geom_line() +
  geom_abline(intercept = 0, slope = 1, linetype = 'dashed') +
  xlim(0, 1) + ylim(0, 1) + theme_bw() +
  xlab('False Positive Rate') + ylab('True Positive Rate') +
  theme(text = element_text(size = 10)) +
  scale_colour_manual(values = cbPalette) +
  theme( legend.title = element_text(size = 10), legend.text = element_text(size = 8)) +
  labs(colour = 'LncRNAs identification \n methods')

pdf('Lnc_ROC_common.pdf', width = 7, height = 5)
p
dev.off()

p1 <- data %>% ggplot(aes(x = FPR, y = TPR, group = Approach, colour = Approach)) +
  geom_line() +
  geom_abline(intercept = 0, slope = 1, linetype = 'dashed') +
  xlim(0, 1) + ylim(0, 1) + theme_bw() +
  xlab('False Positive Rate') + ylab('True Positive Rate') +
  theme(text = element_text(size = 10),legend.position = 'none') +
  scale_colour_manual(values = cbPalette) +
  labs(colour = 'LncRNAs identification \n methods') +
  xlim(0,0.25) + 
  ylim(0.5,1)

pdf('Lnc_ROC_common_res.pdf', width = 5, height = 5)
p1
dev.off()
