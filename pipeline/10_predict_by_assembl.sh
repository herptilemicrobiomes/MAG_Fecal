#!/usr/bin/bash -l
#SBATCH -p short -N 1 -n 1 -c 1 --mem 16gb --out logs/prodigal.%a.log

module load prodigal

INPUT=results
OUTPUT=Proteins/by_assembly
SAMPFILE=samples.csv

mkdir -p $OUTPUT
CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi
N=${SLURM_ARRAY_TASK_ID}
if [ -z $N ]; then
  N=$1
fi
if [ -z $N ]; then
  echo "cannot run without a number provided either cmdline or --array in sbatch"
  exit
fi
IFS=,
tail -n +2 $SAMPFILE | sed -n ${N}p | while read STRAIN SHOTGUN 
do
  BASE=$OUTPUT/${STRAIN}
  IN=$INPUT/$STRAIN/scaffolds/${STRAIN}_R.fa
  prodigal -i $IN -f gff -o $BASE.gff -a $BASE.aa.fa -d $BASE.cds.fa -p meta
done
