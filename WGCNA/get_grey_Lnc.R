setwd('/home/mpilab/sorghum_salt/WGCNA/')

data <- read.table('M81E_Edges.TSV', header = T, sep = '\t')
length(unique(data$Source))
data <- data[grep(pattern = 'Lnc', data$Target),]
data <- data[-4]
write.table(data, 'grey_module.Lnc.TSV', row.names = F, col.names = T, sep = '\t', quote = F)
