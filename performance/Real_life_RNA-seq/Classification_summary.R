setwd('/home/mpilab/Performance2/Real_life_RNAseq/')
library(dplyr)
library(tidyverse)
library(reshape2)
dataframes <- list()
for (i in c("CPAT_human", "CPAT_plants", "CPAT_sorghum", "CPC2", "FEELnc_arabidopsis", 
            "FEELnc_human", "FEELnc_sorghum", "LGC", "LncFinder_human", 
            "LncFinder_plants", "LncFinder_sorghum", "Pfamscan", "RNAsamba_fl",
            "RNAsamba_pl", "RNAsamba_sorghum")) {
  df <- read.table(paste0( i, '_summary.TSV'), header = TRUE, sep = '\t')
  df['Approach'] <- paste0(i)
  dataframes[[i]] <- df
}

data <- dataframes %>% bind_rows
data$Approach <- str_replace_all(data$Approach, pattern = '_', '-')
data$Approach <- str_replace_all(data$Approach, pattern = 'human', 'Human')
data$Approach <- str_replace_all(data$Approach, pattern = 'sorghum', 'Sorghum')
data$Approach <- str_replace_all(data$Approach, pattern = 'plants', 'Plants')
data$Approach <- str_replace_all(data$Approach, pattern = 'arabidopsis', 'Arabidopsis')
data$Approach <- str_replace_all(data$Approach, pattern = 'pl', 'Partial length')
data$Approach <- str_replace_all(data$Approach, pattern = 'fl', 'Full length')
data$Approach <- str_replace_all(data$Approach, pattern = 'Pfamscan', 'PfamScan')
data <- data %>% group_by(Approach) %>% mutate(Proportion=Count/sum(Count))
data$Approach <- factor(data$Approach, levels = c("CPC2",  "PfamScan", "LGC", "CPAT-Human",
                                                   "CPAT-Plants", "CPAT-Sorghum",  "LncFinder-Human", "LncFinder-Plants", "LncFinder-Sorghum","FEELnc-Human",  "FEELnc-Arabidopsis",
                                                   "FEELnc-Sorghum", "RNAsamba-Partial length", 
                                                   "RNAsamba-Full length", "RNAsamba-Sorghum"
))
data1 <- data[-4]
colnames(data1)[2] <- 'value'
data1 <- dcast(data = data1, Approach ~ Label)
write.table(data1, 'Classification_summary.TSV', row.names = F, col.names = T, 
            sep = '\t', quote = F)

mycol <- c('#8fce00', '#2986cc')
# Small multiple
tiff('Classification_summary.tiff', width = 15, height = 15, units = 'cm', res = 600)
data %>% ggplot(aes(fill=Label, y=Proportion, x=Approach)) + 
  geom_bar(position="stack", stat="identity", alpha=0.7, width = 0.5) +
  scale_fill_manual(values =mycol ) +
  theme(axis.text.x = element_text(hjust = 1, angle = 45, size = 8))+
  xlab("") +
  ylab("Proportion") +
  guides(fill=guide_legend(title="",position = 'top')) +
  theme(axis.text  = element_text(size = 10), legend.text = element_text(size = 8))
dev.off()