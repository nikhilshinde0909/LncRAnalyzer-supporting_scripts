setwd('/home/mpilab/Performance2/Final_ROC/')
library(dplyr)
library(stringr)
data <- read.table('ROC_values.TSV', header = T, sep = '\t')
sigmoid <- function(x, k = 1) {
  return(1 / (1 + exp(-k * (x - 0.5))))
}

# data <- data %>% group_by(Approach) %>% mutate(FPR=sigmoid(FPR, k=10), TPR=sigmoid(TPR,k = 10))

approach <- c("CPAT-Sorghum", "CPAT-Plants", "CPAT-Human",
              "FEELnc-Sorghum","FEELnc-Arabidopsis", "FEELnc-Human", 
              "LncFinder-Sorghum","LncFinder-Plants", "LncFinder-Human",
              "RNAsamba-Sorghum","RNAsamba-full length","RNAsamba-partial length",
              "CPC2", "LGC", "PfamScan")


# Define the color palette
cbPalette <- c( "#16537e", "#3d85c6","#9fc5e8", 
                "#ce7e00", "#bf9000", "#f1c232",
                "#38761d","#8fce00", "#93c47d",
                "#351c75", "#6a329f", "#b4a7d6",
                "#744700","#741b47","#f44336")
data$Approach <- factor(x = data$Approach,levels = approach)
data$Tools <- str_replace_all(string = data$Approach,pattern = '-.*',replacement = '')
# Make the plot
library(ggplot2)
p1 <- data %>% ggplot(aes(x = FPR, y = TPR, group = Approach, colour = Approach)) +
  geom_line() +
  geom_abline(intercept = 0, slope = 1, linetype = 'dashed', colour = '#5b5b5b') +
  xlim(0, 1) + ylim(0, 1) + theme_bw() +
  xlab('False Positive Rate') + ylab('True Positive Rate') +
  facet_wrap(facets = ~ Tools, ncol = 3) +
  theme(text = element_text(size = 10)) +
  scale_colour_manual(values = cbPalette) +
  theme( legend.title = element_text(size = 12), legend.text = element_text(size = 10), 
         panel.grid.minor = element_blank(), axis.text = element_text(face = 'bold', size = 10),
         strip.background = element_blank(),
         strip.text = element_text(size =12, face = 'bold'),
         axis.title = element_text(size = 14)) +
  labs(colour = 'LncRNAs identification \n methods')

pdf('Lnc_ROC_tools.pdf', width = 10, height = 8)
p1
dev.off()

# Make the plot
library(ggplot2)
p2 <- data %>% ggplot(aes(x = FPR, y = TPR, group = Approach, colour = Approach)) +
  geom_line(linewidth = 1.1) +
  geom_abline(intercept = 0, slope = 1, linetype = 'dashed', colour = '#5b5b5b') +
  xlim(0, 1) + ylim(0, 1) + theme_bw() +
  xlab('False Positive Rate') + ylab('True Positive Rate') +
  facet_wrap(facets = ~ Approach, ncol = 5) +
  theme(text = element_text(size = 10)) +
  scale_colour_manual(values = cbPalette) +
  theme( legend.title = element_text(size = 14), legend.text = element_text(size = 12),
         panel.grid.minor = element_blank(), axis.text = element_text(face = 'bold', size = 10),
         strip.background = element_blank(),
         strip.text = element_text(size =12, face = 'bold'),
         axis.title = element_text(size = 14)) +
  labs(colour = 'LncRNAs identification \n methods')

pdf('Lnc_ROC_approaches.pdf', width = 24, height = 15)
p2
dev.off()

# Make the plot
library(ggplot2)
p3 <- data %>% ggplot(aes(x = FPR, y = TPR, group = Approach, colour = Approach)) +
  geom_line(linewidth = 1) +
  geom_abline(intercept = 0, slope = 1, linetype = 'dashed', colour = '#5b5b5b') +
  xlim(0, 1) + ylim(0, 1) + theme_bw() +
  xlab('False Positive Rate') + ylab('True Positive Rate') +
  #facet_wrap(facets = ~ Approach, ncol = 5) +
  theme(text = element_text(size = 10)) +
  scale_colour_manual(values = cbPalette) +
  theme( legend.title = element_text(size = 14), legend.text = element_text(size = 12),
         panel.grid.minor = element_blank(), axis.text = element_text(face = 'bold', size = 10),
         strip.background = element_blank(),
         strip.text = element_text(size =12, face = 'bold'),
         axis.title = element_text(size = 14)) +
  labs(colour = 'LncRNAs identification \n methods')

pdf('Lnc_ROC_all.pdf', width = 12.5, height = 10)
p3
dev.off()
