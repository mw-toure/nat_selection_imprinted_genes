library(biomaRt)
options(timeout = 3000)

# Setup ensembl biomart query for GRCh38.p13
ensembl <- useEnsembl(biomart = "genes", dataset = "hsapiens_gene_ensembl")


# Extract the positions of all genes that have been assigned a chromosome 
# i.e., no scaffold assignments
all_human_genes <- getBM(filters = c('chromosome_name'),
      values = list(c(1:22, 'X')),
      attributes = c('ensembl_gene_id', 'external_gene_name', 'chromosome_name', 
                     'start_position','end_position'),
      mart = ensembl)

write.csv(all_human_genes, "data/gene_info/all_human_genes.csv", row.names = F)

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

