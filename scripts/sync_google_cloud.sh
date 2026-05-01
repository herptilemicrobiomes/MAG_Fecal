#!/usr/bin/bash -l
#SBATCH -c 8 --mem 24gb --out logs/sync_google_cloud.log

module load gcloudsdk

IFS=,
tail -n +2 samples.csv | while read -r SAMPLE SHOTGUN
do
    for N in 1 2
    do
        IN=$(echo "$SHOTGUN" | perl -p -e "s/R\?/R$N/")
        OUT=${SAMPLE}_R${N}.fastq.gz
        echo "$IN -> $OUT"
        gcloud storage mv gs://herptile-basidiobolus-genomics/metagenome/$IN gs://herptile-basidiobolus-genomics/illumina_metagenome/$OUT
    done
done    