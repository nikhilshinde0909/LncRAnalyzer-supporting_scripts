setwd('/home/mpilab/sorghum_salt/Targets/Roma/')
library(dplyr)
library(tidyverse)
Cis1 <- read.table('Roma_Cis_C1+.TSV', header = T, sep = '\t')
Cis2 <- read.table('Roma_Cis_C1-.TSV', header = T, sep = '\t')
Cis <- bind_rows(Cis1,Cis2)
colnames(Cis)[c(1,2)] <- c('LncRNA','Gene')

data <- read.table('/home/mpilab/sorghum_salt/Targets/Sorghum_cis_cordinates.TSV', header = F,
                   sep = '\t')
data <- data[data$V1==data$V6,]
data <- data[-6]
colnames(data) <- c('Chromosome','Gene_start','Gene_end','Gene','Strand','Lnc_start',
                    'Lnc_end','LncRNA', 'Lnc_strand')
data <- list(data,Cis) %>% reduce(inner_join)
data <-  data[!duplicated(data),]
write.table(data,'Roma_Cis_targets.TSV', row.names = F, col.names = T, sep = '\t', quote = F)

length(unique(data$Gene))
length(unique(data$LncRNA))
