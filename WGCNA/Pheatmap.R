library(reshape2)
library(pheatmap)
library(ComplexHeatmap)
library(colorRamp2)
setwd('/home/mpilab/sorghum_salt/WGCNA/')

data <- read.table('Module_trait.TSV', header = TRUE, sep = '\t')
data$value <- as.numeric(data$value)

data <- dcast(data, treatment ~ name)

data <- t(data)
colnames(data) <- data[1, ]
data <- data[-1, ]
data <- as.matrix(data)
rownamex <- rownames(data)
data1 <- apply(data, 2, as.numeric)
rownames(data1) <- rownamex

colMain <-colorRampPalette(colors = c("royalblue", "white", "indianred"))(15)

condition <- c(rep('Control', 3), rep('Salinity stress', 3),
               rep('Control', 3), rep('Salinity stress', 3))
genotype <- c(rep('M-81E', 6), rep('Roma', 6))
ann <- data.frame(genotype, condition)
colnames(ann) <- c('Genotype', 'Condition')
colours <- list('Genotype' = c("M-81E" = "#6aa84f", "Roma" = "#674ea7"),
                'Condition' = c("Control" = "#2986cc", "Salinity stress" = "#ce7e00"))
colAnn <- HeatmapAnnotation(df = ann,
                            which = 'col',
                            col = colours,
                            annotation_width = unit(c(1, 4), 'cm'),
                            gap = unit(1, 'mm'))

pdf('Module_trait_relationship.pdf', width = 8, height = 7)
Heatmap(data1,
        col = colMain,
        cluster_columns = FALSE,
        cluster_rows = FALSE,
        show_column_names = TRUE,
        column_title_side = 'bottom',
        column_title = 'Samples',
        row_title = 'Modules',
        show_row_names = TRUE,
        column_names_centered = TRUE,
        row_names_side = "left",
        row_names_gp = gpar(fontsize = 10), 
        column_names_gp = gpar(fontsize = 8, angle = 90),
        column_names_rot = 90,
        border = FALSE, 
        bottom_annotation = colAnn,
        heatmap_legend_param = list(
          title = "Correlation", 
          title_gp = gpar(fontsize = 10),
          labels_gp = gpar(fontsize = 8))
)
dev.off()
