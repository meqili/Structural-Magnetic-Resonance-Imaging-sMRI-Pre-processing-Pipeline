#!/bin/bash
#This bash script is for bias field correction
#author:Qi Li
#github:liqi814
#Usage: nohup ./Scripts/correction.sh input/image/path output_folder
#For example: nohup ./Scripts/correction.sh 1.Transformation/S623901.nii.gz 2.Correction
#With Singularity: singularity exec preprocess.img ./Scripts/correction.sh 1.Transformation/S623901.nii.gz 2.Correction

##N4 bias field correction

#add the location of the ANTs binaries to the PATH environmental variable
#export ANTSPATH=${HOME}/bin/ants/bin/
#export ANTSPATH=//install/bin/
#export PATH=${ANTSPATH}:$PATH

if [ -d $PWD/$2 ];then
	echo "Output folder $PWD/$2 has been created"
else
	mkdir -p $PWD/$2
fi

#exit


INFILE=$(basename $1)
FILENAME=$(echo $INFILE | cut -d . -f1)
#echo $INFILE
#echo $FILENAME

OUT=$2/$FILENAME-cor.nii.gz
#echo $OUT

#echo "time N4BiasFieldCorrection -d 3 -i $1 -o $OUT"
time N4BiasFieldCorrection -d 3 -i $1 -o $OUT
