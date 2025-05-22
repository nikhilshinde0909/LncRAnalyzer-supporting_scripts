setwd('/home/mpilab/sorghum_salt/Targets/M81E/')
library(dplyr)
library(tidyverse)
Trans1 <- read.table('M81E_Trans_C1+.TSV', header = T, sep = '\t')
Trans2 <- read.table('M81E_Trans_C1-.TSV', header = T, sep = '\t')
Trans <- bind_rows(Trans1,Trans2)
colnames(Trans)[c(1,2)] <- c('LncRNA','Gene')

gene2trans <- read.table('/home/mpilab/sorghum_salt/Targets/Sorghum_bicolor.gene2trans.TSV', header = T,
                         sep = '\t')
gene2trans <- gene2trans[-3]

data <- read.table('/home/mpilab/sorghum_salt/Targets/Triplexator_final_out.TSV', header = F,
                   sep = '\t')
data <- data[data$V1==data$V6,]
data <- data[c(-3,-6)]
colnames(data) <- c('Chromosome', 'TSS', 'Transcript','Strand','Triplex_start', 
                    'Triplex_end','LncRNA','Score','Triplex_strand')
data <- data %>% mutate(Triplex_id=paste0('SbProm000',1:n()))
data <- data[,c(1:6,9,10,7,8)]
data <- list(data,gene2trans) %>% reduce(inner_join)
data <- list(data,Trans) %>% reduce(inner_join)
data <- data[c(1:4,11,5:10,12)]
write.table(data,'M81E_Trans_targets.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
