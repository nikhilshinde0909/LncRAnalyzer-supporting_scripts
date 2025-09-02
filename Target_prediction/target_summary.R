setwd('/home/mpilab/sorghum_salt/Targets/')

# M81E
Cis_tar <- read.table('M81E/M81E_Cis_targets.TSV', header = T,sep = '\t')
length(unique(Cis_tar$Gene))
length(unique(Cis_tar$LncRNA))


Trans_tar <- read.table('M81E/M81E_Trans_targets.TSV', header = T,sep = '\t')
length(unique(Trans_tar$Gene))
length(unique(Trans_tar$LncRNA))

# Roma
Cis_tar <- read.table('Roma/Roma_Cis_targets.TSV', header = T,sep = '\t')
length(unique(Cis_tar$Gene))
length(unique(Cis_tar$LncRNA))


Trans_tar <- read.table('Roma/Roma_Trans_targets.TSV', header = T,sep = '\t')
length(unique(Trans_tar$Gene))
length(unique(Trans_tar$LncRNA))