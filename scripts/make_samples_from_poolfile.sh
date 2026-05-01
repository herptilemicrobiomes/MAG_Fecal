#!/usr/bin/bash -l

TOPIN=input
INPOOL=$(realpath lib/UHM_2025_qiagenpool_1.txt)
INPUT=UCB_20250426_M005990
if [ ! -z $1 ]; then
    INPOOL=$(realpath $1)
fi
if [ ! -z $2 ]; then
    INPUT=$2
fi
pushd ${TOPIN}
cat $INPOOL | while read UHM BIOSAMPLE
do
    FILE=$(ls ${INPUT}/${UHM}_*_R1*.gz)
    FILEPATTERN=$(echo $FILE | perl -p -e 's/_R1/_R?/')
    echo "${UHM}.${BIOSAMPLE},$FILEPATTERN"
done
