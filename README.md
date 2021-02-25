# Structural Magnetic Resonance Imaging (sMRI) Pre-processing Pipeline

## Citation
If you are using this repository, please cite this article
**Li Q, Yang MQ. 2021. Comparison of machine learning approaches for enhancing Alzheimer’s disease classification. PeerJ 9:e10549 https://doi.org/10.7717/peerj.10549**

## Introduction
sMRI pre-processing including four steps:
- Data transformation, from DICOM to NifTi. (Skip this step if your data is in NifTi format already.)
- Bias field correction or intensity normalization.
- Skull-stripping or brain extraction.
- Registration.

For a better understanding of sMRI pre-pressing, please check this free course on Coursera: https://www.coursera.org/learn/neurohacking

## Data
The example data we used in this repository are from the Alzheimer's Disease Neuroimaging Initiative database (ADNI, http://adni.loni.usc.edu).

## Approaches
- A Singularity container with all software or library dependencies bundled in to ensure quick and easy reproducibility of the results.
  - Please install Singularity before you run the scripts.
  - Build the container from the recipe
  ```
   sudo singularity build preprocess.img preprocess.def
  ```
- Or you can run the scripts without using Singularity. In this approach: some software is required to install:
  - R version 3.2.3
  - CMake 3.10+ installation instruction: https://cgold.readthedocs.io/en/latest/first-step/installation.html
  - ANTs (Advanced Normalization Tools) installation instruction: https://github.com/ANTsX/ANTs/wiki/Compiling-ANTs-on-Linux-and-Mac-OS
  - FSL installation instruction: https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation

## Instructions
### 1. Data transformation
```
#Usage: 
Rscript Scripts/dim2nii.R input/file/folder/path output/folder/file_prelix
#For example: 
Rscript Scripts/dim2nii.R 0.ADNI_raw_data/S29070 1.Transformation/S29070
#With Singularity: 
singularity exec preprocess.img Rscript Scripts/dim2nii.R 0.ADNI_raw_data/S623901 1.Transformation/S623901
```

### 2. Bias field correction
```
#Usage: 
nohup ./Scripts/correction.sh input/image/path output_folder
#For example: 
nohup ./Scripts/correction.sh 1.Transformation/S623901.nii.gz 2.Correction
#With Singularity: 
singularity exec preprocess.img ./Scripts/correction.sh 1.Transformation/S623901.nii.gz 2.Correction
```

### 3. Skull-stripping and Registration
```
#Usage: 
nohup Scripts/bet_n_reg.R corrected/image/path template/image/path brian_extraction/output_folder/prefix-bet registration/output_folder/prefix-reg
#For example: 
Rscript Scripts/bet_n_reg.R 2.Correction/S623901-cor.nii.gz template/resized_template110_110_110.nii.gz  3.BrianExtraction/S623901-bet 4.Registration/S623901-reg
#With Singularity: 
singularity exec preprocess.img Rscript Scripts/bet_n_reg.R 2.Correction/S623901-cor.nii.gz template/resized_template110_110_110.nii.gz  3.BrianExtraction/S623901-bet 4.Registration/S623901-reg
```

The downstream analysis like image classification and discriminative visualization are also provided, please check this [link](https://github.com/liqi814/Deep-3D-CNNs-for-MRI-Classification-with-Alzheimer-s-Disease-And-Grad-CAM-Visualization).
