#!/usr/bin/env bash
#SBATCH --job-name=fastqc_sample2
#SBATCH --output=fastqc_sample2.out
#SBATCH --error=fastqc_sample2.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=0:20:0
#SBATCH --partition=pall

SCRIPT_DIR=/data/users/kolsen/rna_seq/scripts
RAW_DIR=/data/courses/rnaseq_course/lncRNAs/fastq
FASTQC_DIR=/data/users/kolsen/rna_seq/fastqc

FILES=([3P]*)

## Change direcotry to where the fastq files are located
cd $RAW_DIR

## Add fastq module
module add UHTS/Quality_control/fastqc/0.11.9

## Run fastqc on all the samples
fastqc -t 2 -o $FASTQC_DIR P1_L3_R1_001_9L0tZ86sF4p8.fastq.gz