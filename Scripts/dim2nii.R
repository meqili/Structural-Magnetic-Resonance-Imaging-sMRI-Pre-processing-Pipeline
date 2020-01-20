#This R scipt is for converting images from a DICOM format to a NIfTI format.
#Author:Qi Li
#Github:liqi814
#Usage: Rscript Scripts/dim2nii.R input/file/folder/path output/folder/file_prelix
#For example: Rscript Scripts/dim2nii.R 0.ADNI_raw_data/S29070 1.Transformation/S29070
#With Singularity: singularity exec preprocess.img Rscript Scripts/dim2nii.R 0.ADNI_raw_data/S623901 1.Transformation/S623901


if (!require(oro.dicom)){install.packages("oro.dicom")}
if (!require(oro.nifti)){install.packages("oro.nifti")}
tarDir <- commandArgs(T)
all_slices_T1 <- readDICOM(tarDir[1])
#dim(all_slices_T1$img[[11]]) 

nii_T1 <- dicom2nifti(all_slices_T1)
fname <- tarDir[2] ###
writeNIfTI(nim=nii_T1, filename = fname)
