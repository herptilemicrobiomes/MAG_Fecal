#!/usr/bin/bash -l
#SBATCH -p short --out logs/gather_barrnap.log --mem 2gb

TOP=results_bins_qual
for g in $(ls $TOP)
do
	name=$(basename $g)
	for bin in $(ls $TOP/$g/barrnap)
	do
		binname=$(echo -n $bin | perl -p -e 's/_R//')
		cat $TOP/$g/barrnap/$bin/*.fa | perl -p -e "s/>/>$binname./"
	done
done > ALLbins_rRNA_barrnap.fa
#pigz -f ALLbins_rRNA_barrnap.fa
