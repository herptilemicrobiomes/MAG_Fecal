#!/usr/bin/bash -l
#SBATCH -c 8 --mem 24gb --out logs/sync_google_cloud.log

module load gcloudsdk
module load workspace/scratch

gcloud storage ls gs://herptile-basidiobolus-genomics/illumina_metagenome > $SCRATCH/remote.txt
INDIR=input
IFS=,
tail -n +2 samples.csv | grep -v SRR | while read -r SAMPLE SHOTGUN
do
    for N in 1 2
    do
        IN=$(echo "$SHOTGUN" | perl -p -e "s/R\?/R$N/")
        OUT=${SAMPLE}_R${N}.fastq.gz
        if [ ! -f $INDIR/$IN ]; then
            echo " cannot find $INDIR/$IN"
            continue
        fi
        if grep -q $OUT $SCRATCH/remote.txt; then
            echo "$OUT exists in remote"
            continue
        else
            echo "will copy $IN to gs://herptile-basidiobolus-genomics/illumina_metagenome/$OUT"
            gcloud storage cp $INDIR/$IN gs://herptile-basidiobolus-genomics/illumina_metagenome/$OUT
        fi
    done
done
