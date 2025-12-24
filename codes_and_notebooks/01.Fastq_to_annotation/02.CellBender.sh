#!/bin/bash
#$ -cwd
#$ -S /bin/bash
#$ -q gpu.q
#$ -l gpu=1
#$ -N cellbender-scHcar
#$ -M tahila@unicamp.com
#$ -m abe
#$ -j y
#$ -o cellbender-scHcar

source /usr/local/gpuallocation.sh

conda activate cellbender

DIR_INPUT=/home/andrighettit/2509-scRNAseq/01.output_cellranger
DIR_OUTPUT=/home/andrighettit/2509-scRNAseq/02.output_cellbender

# Só os sufixos
declare -a sample_suffixes=("1_WT" "2_WT" "3_KO" "4_KO")

for suffix in "${sample_suffixes[@]}"
do
    sample="SAMPLE${suffix}"
    mkdir -p ${DIR_OUTPUT}/cellbender_${sample}

    cellbender remove-background \
        --input ${DIR_INPUT}/${sample}/outs/raw_feature_bc_matrix.h5 \
        --output ${DIR_OUTPUT}/cellbender_${sample}/raw_feature_bc_matrix.h5 \
        --cuda \
        --fpr 0.01 \
        --learning-rate 0.00005
done

conda deactivate
