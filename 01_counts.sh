#!/usr/bin/env bash
#SBATCH --job-name=counts
#SBATCH --output=counts.out
#SBATCH --error=counts.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=0:10:0
#SBATCH --partition=pall
#SBATCH --array=0-11

HOME_DIR=/data/users/kolsen/rna_seq
RAW_DIR=/data/courses/rnaseq_course/lncRNAs/fastq

## Change direcotry to where the fastq files are located
cd $RAW_DIR

FILES=([3P]*)

zcat ${FILES[$SLURM_ARRAY_TASK_ID]} | awk -v filename=${FILES[$SLURM_ARRAY_TASK_ID]} 'BEGIN {x=0} /^@/ {++x} END {print filename, x}'
