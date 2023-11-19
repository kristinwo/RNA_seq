#!/usr/bin/env bash
#SBATCH --job-name=03_building_genome_index
#SBATCH --output=../out/03_building_genome_index.out
#SBATCH --error=../err/03_building_genome_index.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=4:00:0
#SBATCH --partition=pall

REFERENCE_DIR=/data/courses/rnaseq_course/lncRNAs/Project2/references
INDEX_FILES_DIR=/data/users/kolsen/rna_seq/index_files

module load UHTS/Aligner/hisat/2.2.1

hisat2-build -p8 -f $REFERENCE_DIR/GRCh38.genome.fa $INDEX_FILES_DIR/GRCh38_genome_index