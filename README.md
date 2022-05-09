# Documentation for 'The strength of natural selection on imprinted genes'

## Summary

This is the repository containing the R and shell code to produce the analyses
and figures in the report for 'The strength of natural selection on imprinted
genes'. This README explains how to obtain the data and reproduce the results
and provides the necessary software and their versions.

## Required software

This project was conducted primarly using R version 4.2.0. The ability to
execute shell scripts will also be necessary to conduct the analyses in this
project.

The following R packages also need to be installed to be able to run the
analysis scripts.

|package      |version    |source                                         |
|:------------|:----------|:----------------------------------------------|
|ggplot2      |3.3.3      |CRAN                                           |
|dplyr        |1.0.3      |CRAN                                           |
|biomaRt      |2.52.0     |Bioconductor                                   |
|vcftools     |0.1.16     |[GitHub](https://github.com/vcftools/vcftools) |


## Obtaining the input data

As of May 2022, the input vcf files can be downloaded from the 1000 genomes
project's public FTP site using the following bash command from the root
directory of the repository.

```sh
wget -r ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20220422_3202_phased_SNV_INDEL_SV/ data/vcfs/
```

This will download the vcf files into the `data/vcfs/` directory for further
downstream analyses.

## Getting started

Once the repository and the input data are downloaded onto your system, navigate
to the root directory and open `imprinted_ns_project.Rproj`. It is important to
open the project using the `.Rproj` file to ensure the working directory is set
correctly. The per-site values of pi are needed for the analyses in the
scripts. To obtain this it is possible to do

```sh
vcftools --gzvcf input_vcf_file --site-pi --out data/pi_values/output_pi_values_file
```

for each individual chromosome.

This becomes tedious to do individually for all chromosomes so I used slurm job
arrays via the computing cluster at the Zuckerman Institute to parallelize the
calculation of per-site nucleotide diversity. Once you have the values of pi in
the `pi_values/` directory it is possible to perform the analysis.

## Performing the analysis

The main analysis script is `main.Rmd`. Sequentially running the code in this
file will reproduce the analysis if all required packages are installed and all
the input data has been generated. Running the code in this file will
sequentially query the biomart gene database producing a file containing all
human genes and their coordinates for human genome assembly GRCh38. Then it
appends the imprinted status of all genes based on the imprinted gene file found
in `data/gene_info/human_imprinted_genes.csv`. The calculation of per-gene pi is
then performed for all chromosomes followed by the statistical
analysis. Plotting and statistical analysis scripts are also included at the
end.

## Directory structure

  - `R/` contains custom R functions used in the analysis
  - `data/` contains the raw data used to conduct the analyses
  - `figs/` contains figure 1 from the final report
  - `sh/` contains a shell script used to parallelize pi calculations

## Directory contents

- `final_report.pdf` contains the final report write-up for the project.

### R scripts

`main.Rmd` contains the R script that calls all the below functions to perform
the analysis.

`query_biomart.R` is an R script that queries the ensembl data base for the
coordinates of all genes in the human genome

`get_imprint_status.R` uses the list of imprinted genes I provide from the
GeneImprint database to annotate whether a gene is imprinted or not

`batch_pi_calc.R` is a script that is called by the slurm job array initiation
script in `sh/calc_pi_job_array.sh`. It executes the nucleotide diversity
calculation for a single chromosomal `.vcf.gz` file.

`read_site_pi_files.R` reads in the XX

`tableau.colours.R` simply contains hex values of colours for figures

### data directory

`imprinted_gene_names_list.csv` contains the gene name of all confirmed
imprinted genes listed on GeneImprint

`imprinted_ns_project.Rproj` marks the root directory as the working directory
of the R project. All filepaths within the project are relative to the working
directory and the root directory.

`pi_values/` is a blank folder intended to hold the output of your pi value
calcuations

`vcfs/` is a blank folder intended to hold the output of your wget call to
obtain the raw vcf files from the 1000 genomes ftp site