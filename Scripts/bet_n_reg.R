#This R scipt is for skull-stripping and registration
#Author:Qi Li
#Github:liqi814
#Usage: nohup Scripts/bet_n_reg.R corrected/image/path template/image/path brian_extraction/output_folder/prefix-bet registration/output_folder/prefix-reg
#For example: Rscript Scripts/bet_n_reg.R 2.Correction/S623901-cor.nii.gz template/resized_template110_110_110.nii.gz  3.BrianExtraction/S623901-bet 4.Registration/S623901-reg
#With Singularity: singularity exec preprocess.img Rscript Scripts/bet_n_reg.R 2.Correction/S623901-cor.nii.gz template/resized_template110_110_110.nii.gz  3.BrianExtraction/S623901-bet 4.Registration/S623901-reg

###install packages
if (!require(oro.nifti)){install.packages("oro.nifti")}

###Install will take ~20minutes
#devtools was installed in Singularity container preprocess.img
if (!require(devtools)){install.packages("devtools")}


#comment this out if you already install the fslr
#fslr was installed in Singularity container preprocess.img
#options(repos=structure(c(CRAN="https://cloud.r-project.org/")))
#source("https://neuroconductor.org/neurocLite.R")
#neuro_install("fslr")

#library(ANTsR)
#library(extrantsr)
Sys.getenv("FSLDIR")
library(fslr)
have.fsl()

if (have.fsl() == FALSE) {
options(fsl.path= '/usr/local/fsl')
}

###Read images and parameters
args=commandArgs(T)
nim <- readNIfTI(args[1],reorient=FALSE) ###nii.gz file
template <- readNIfTI(args[2],reorient=FALSE) ###template file
bet_dir <- args[3]
reg_dir <- args[4]


#Brain extraction
bet_img <- fslbet(infile=nim,retimg = TRUE)
#Improving Brain Segmentation by estimating the center of gravity(COG)
cog <- cog(bet_img,ceil=TRUE)
cog <- paste("-c", paste(cog, collapse= " "))
bet_img2 <- fslbet(infile=nim,retimg = TRUE,opts=cog)

#Affine image registration
reg_fast_affine <- flirt(infile=bet_img2, reffile = template, dof=12, retimg = TRUE)

##write image
writeNIfTI(bet_img2, bet_dir, verbose=TRUE)
writeNIfTI(reg_fast_affine, reg_dir, verbose=TRUE)
