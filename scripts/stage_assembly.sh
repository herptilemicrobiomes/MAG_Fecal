#!/usr/bin/bash -l
#SBATCH -p short -N 1 -n 1 -c 1 --mem 16gb 

module load gcloudsdk

INPUT=results
OUTPUT=stage_for_copy
SAMPFILE=samples.csv

mkdir -p $OUTPUT
CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi
OUT=$SCRATCH/asms
mkdir -p $OUT
IFS=,
tail -n +2 $SAMPFILE | while read STRAIN SHOTGUN 
do
  BASE=$OUTPUT/${STRAIN}
  IN=$INPUT/$STRAIN/scaffolds/${STRAIN}_R.fa
  pigz -c $IN > $OUT/$STRAIN.dna.fa.gz
done
gcloud storage cp $OUT/*.gz gs://herptile-basidiobolus-genomics/metagenome/all_scaffolds/
