#!/bin/bash
#$ -cwd
#$ -j y
#$ -o scHcar.log
#$ -S /bin/bash
#$ -q all.q
#$ -N scHcar
#$ -M tahila@unicamp.br
#$ -m be
#$ -pe smp 40

DATA_DIR=/home/andrighettit/2509-scRNAseq/raw_data

#REF_DIR=/storage/projects/VargaWeiszCo/references-databases/genomes/single-cell/refdata-gex-GRCh38-2024-A   #### HUMAN
REF_DIR=/storage/projects/VargaWeiszCo/references-databases/genomes/single-cell/refdata-gex-GRCm39-2024-A    #### MICE

declare -a sample_names=(
  SAMPLE1_WT
  SAMPLE2_WT
  SAMPLE3_KO
  SAMPLE4_KO
)

for sample in "${sample_names[@]}"
do
    echo -e "Now processing sample ${sample}..."
    cellranger count \
        --id run_${sample} \
        --fastqs ${DATA_DIR} \
        --transcriptome ${REF_DIR} \
        --sample ${sample} \
        --include-introns \
        --chemistry auto \
        --localcores=$NSLOTS \
	--no-bam
done

