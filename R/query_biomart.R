library(biomaRt)
options(timeout = 3000)

# Setup ensembl biomart query for GRCh38.p13
ensembl <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl")


# Extract the positions of all genes that have been assigned a chromosome 
# i.e., no scaffold assignments
all_human_genes <- getBM(filters = c('chromosome_name'),
      values = list(c(1:22, 'X')),
      attributes = c('ensembl_gene_id', 'external_gene_name',
                     'transcript_is_canonical', 'chromosome_name', 
                     'start_position','end_position'),
      mart = ensembl)

write.csv(all_human_genes, "data/gene_info/all_human_genes.csv", row.names = F)

# All human exons

# Queries have to bee broken up into chunks to prevent timeout
chunk_1 <- c(1:4)
chunk_2 <- c(5:8)
chunk_3 <- c(9:12)
chunk_4 <- c(13:16)
chunk_5 <- c(17:20)
chunk_6 <- c(20:22, 'X')

query_list <- list(chunk_1, chunk_2, chunk_3, chunk_4, chunk_5, chunk_6)

all_human_exons <- data.frame()

for (i in 1:length(query_list)) {
query_exons <- getBM(filters = c('chromosome_name'),
                         values = list(c(query_list[[i]])),
                         attributes = c('chromosome_name', 
                                        'ensembl_gene_id',
                                        'external_gene_name',
                                        'start_position','end_position',
                                        'ensembl_exon_id', 
                                        'transcript_is_canonical',
                                        'transcript_start', 'transcript_end'),
                         mart = ensembl)
all_human_exons <-  rbind(all_human_exons, query_exons)
}

write.csv(all_human_exons, "data/gene_info/all_human_exons.csv", row.names = F)

# Get list of imprinted genes
imprinted_genes <- read.csv("data/imprinted_genes/imprinted_gene_names_list.csv",
                            header = F)[,1]

imprinted_genes_df <- getBM(filters = c('chromosome_name', 'external_gene_name'),
      values = list(c(1:22, 'X'), imprinted_genes),
      attributes = c('ensembl_gene_id', 'external_gene_name', 'chromosome_name', 
                     'start_position','end_position'),
      mart = ensembl)

write.csv(imprinted_genes_df, "data/gene_info/human_imprinted_genes.csv", 
          row.names = F)

