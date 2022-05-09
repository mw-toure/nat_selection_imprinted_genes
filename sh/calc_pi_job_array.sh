#!/bin/sh
#
# Script to get pi values for each chromosomal vcf file
#
#
#SBATCH --account=zi
#SBATCH --job-name=GetPiPerChrom
#SBATCH -c 1
#SBATCH --time=50:00
#SBATCH --mem-per-cpu=4gb
#SBATCH --array=1-23

echo "TASK ID: $SLURM_ARRAY_TASK_ID"

Rscript --vanilla batch_pi_calc.R

# End of script