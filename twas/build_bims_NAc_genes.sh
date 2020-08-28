#!/bin/bash
#$ -cwd
#$ -l mem_free=10G,h_vmem=10G,h_fsize=100G
#$ -pe local 12
#$ -N "build_bims_NAc_genes"
#$ -m e

# mkdir -p logs

echo "**** Job starts ****"
date
echo "**** JHPCE info ****"
echo "User: ${USER}"
echo "Job id: ${JOB_ID}"
echo "Job name: ${JOB_NAME}"
echo "Hostname: ${HOSTNAME}"
echo "Task id: ${SGE_TASK_ID}"

## Load dependencies
module load plink/1.90b6.6
module load fusion_twas/github
module load conda_R/4.0

## List current modules
module list

## Compute weights for the given region/feature pair
## elif chain to preclude the possibility of any commandline-argument-passing error
## if arg 1 is not null and arg 2 is not null... etc.
if [ ! -z "$1" ] && [ ! -z "$2"];
then
  Rscript build_bims.R -c 12 -t $1 -d $2;
elif [ ! -z "$1" ] && [ -z "$2"];
then
  Rscript build_bims.R -c 12 -t $1;
elif [ -z "$1" ] && [ ! -z "$2"];
then
  Rscript build_bims.R -c 12 -d $2;
else
  Rscript build_bims.R -c 12;
fi

mv *${JOB_ID}* logs/

echo "**** Job ends ****"
date