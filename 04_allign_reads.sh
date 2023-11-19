#!/usr/bin/env bash
#SBATCH --job-name=04_allign_reads
#SBATCH --output=../out/04_allign_reads.out
#SBATCH --error=../err/04_allign_reads.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall
#SBATCH --array=0-5

# Add modules
module add UHTS/Aligner/hisat/2.2.1

# Directories
FASTQ_DIR=/data/users/kolsen/rna_seq/fastq_files
INDEX_FILES_DIR=/data/users/kolsen/rna_seq/index_files
SAM_FILE_DIR=/data/users/kolsen/rna_seq/sam_files

# Parental and paraclonal fastq files
R1_FILES=("$FASTQ_DIR"/[3P]*R1*)
R2_FILES=("$FASTQ_DIR"/[3P]*R2*)

# Extract the type of sample: first character is type of clone (P-parental, 3-paraclonal)
# second character is the replicate (1, 2, 3)
SAMPLE_R1=$(basename ${R1_FILES[$SLURM_ARRAY_TASK_ID]} | cut -c 1-3)
SAMPLE_R2=$(basename ${R1_FILES[$SLURM_ARRAY_TASK_ID]} | cut -c 1-3)

# Map reads with index from GRCh38 human genome for all fastq files. Save files as sam-files.
# Library type is Trueseq Stranded mRNA -> reverse forward
# --dta: downstream-transcriptome-assembly - tailor the alignment to transcipt assablers like StringTie
if [ "$SAMPLE_R1" == "$SAMPLE_R2" ]; then
    hisat2 -p 8 --dta --rna-strandness RF -x $INDEX_FILES_DIR/GRCh38_genome_index -1 ${R1_FILES[$SLURM_ARRAY_TASK_ID]} -2 ${R2_FILES[$SLURM_ARRAY_TASK_ID]} -S $SAM_FILE_DIR/$SAMPLE_R1.sam
else
    echo "Samples does not correspond: ${R1_FILES[$SLURM_ARRAY_TASK_ID]} vs. ${R2_FILES[$SLURM_ARRAY_TASK_ID]}" >> 04_allign_reads.err
fi