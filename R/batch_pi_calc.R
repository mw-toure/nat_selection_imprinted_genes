vcfs_path <- "/rigel/zi/users/mt3215/1k_genome_vcfs_30x"

# Get the full filepath of the bams
files <- list.files(
  vcfs_path, 
  full.names = TRUE)

# filter out the indexes
files <- files[grep(".vcf.gz$",files)]

# Get the file names of the bams so I know which bam is which mouse
file_names <- list.files(
  vcfs_path, 
  full.names = FALSE)

# filter out the indexes
file_names <- file_names[grep(".vcf.gz$",file_names)]

task <- as.numeric(Sys.getenv('SLURM_ARRAY_TASK_ID'))

# Documenting the task number
print(paste("This is slurm run #", task))

# Creating the text for the bash command
x <- paste("bin/vcftools --gzvcf ",
           files[task],
           " --site-pi ",
           "--out ",
           file_names[task],
           sep = "")

# Sanity check
sanity <- paste("echo Running ",
                file_names[task],
                sep = "")

# Verbose output indicating job is running
system(sanity)

# Run the coverage job
system(x)