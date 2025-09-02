#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Usage: get_gene2trans.R transcript_list output_file\n")
}

transcript_list <- args[1]
output_file <- args[2]

data <- read.table(transcript_list, header=F, sep='\t')
data$V2 <- data$V1
data$V1 <- sub("(^.*?\\..*?)\\..*", "\\1",data$V1)

write.table(data, output_file, row.names = F, col.names = F, sep = "\t", quote = F)
