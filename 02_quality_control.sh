#!/usr/bin/env bash
#SBATCH --job-name=02_quality_control
#SBATCH --output=../out/02_quality_control.out
#SBATCH --error=../err/02_quality_control.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=25G
#SBATCH --time=2:00:0
#SBATCH --partition=pall
#SBATCH --array=0-11

# Directories
SCRIPT_DIR=/data/users/kolsen/rna_seq
FASTQ_DIR=/data/courses/rnaseq_course/lncRNAs/fastq
FASTQC_DIR=/data/users/kolsen/rna_seq/fastqc

FILES=($FASTQ_DIR/[3P]*)

## Add fastq module
module add UHTS/Quality_control/fastqc/0.11.9

## Run fastqc on all the samples
zcat ${FILES[$SLURM_ARRAY_TASK_ID]} | fastqc -t 2 -o $FASTQC_DIR ${FILES[$SLURM_ARRAY_TASK_ID]}

