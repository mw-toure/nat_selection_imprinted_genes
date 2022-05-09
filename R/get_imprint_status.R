library(dplyr)

human_genes <- read.csv(file = "data/gene_info/all_human_genes.csv",
         header = TRUE)

human_imprinted_genes <- read.csv(file = "data/gene_info/human_imprinted_genes.csv")

human_genes_df <- human_genes |> mutate(
  imprinted_status =
  case_when(
    human_genes$ensembl_gene_id %in% human_imprinted_genes$ensembl_gene_id ~ "imprinted",
    ! human_genes$ensembl_gene_id %in% human_imprinted_genes$ensembl_gene_id ~ "normal"
  )
)

write.csv(human_genes_df, file = "data/gene_info/gene_imprint_status.csv")
