setwd('/home/mpilab/NPCTs/')
library(trinotateR)

Roma_M81E <- read_trinotate("Roma-M81E_Trinotate.xls")
summary_trinotate(Roma_M81E)

library(dplyr)
library(tidyverse)
library(stringr)
Roma_M81E <- Roma_M81E %>% rename(TrEMBL_Top_BLASTX_hit=sprot_Top_BLASTX_hit, TrEMBL_Top_BLASTP_hit=sprot_Top_BLASTP_hit)
na.omit(Roma_M81E$TrEMBL_Top_BLASTX_hit)[1:2]
Roma_M81E1 <- split_blast(Roma_M81E)
Roma_M81E1 <- Roma_M81E1[,c(2,4)]
Roma_M81E1 <- Roma_M81E1[!duplicated(Roma_M81E1$transcript),]
write.table(unique(Roma_M81E1$uniprot),'salt_uniprot_ID.txt', row.names = F, col.names = F, sep = '\t',
            quote = F)
anno <- read.table('salt_uniprot_anno.TSV', header = T, sep = '\t')
data <- list(Roma_M81E1,anno) %>% reduce(left_join)
colnames(data) <- c('NPCTs','Uniprot_ID','Annotation')
data$Annotation <- str_wrap(data$Annotation, width = 65)
write.table(data,'salt_NPCTs_annotation.TSV', row.names = F, col.names = T, sep = '\t',
            quote = F)
data <- data %>% group_by(Annotation) %>% summarise(Count=n())
pdf('Salt_NPCTs_annotation.pdf', width = 6, height = 6)
data %>% ggplot(aes(x = Annotation, y=Count , fill = Count)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_fill_gradient(name = "Count",low = "#8e7cc3", high = "#8e7cc3") +
  labs(x = "NPCT's annotation", y = "Count") +   
  theme(strip.text = element_text(size = 10), axis.title = element_text(size = 10), 
        axis.text = element_text(size = 8), 
        # legend.key.size = unit( 1, 'cm'), legend.text = element_text(size=10),
        legend.position = "none") 
dev.off()