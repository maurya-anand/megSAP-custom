#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=80G
#SBATCH --time=7-00:00:00
#SBATCH --partition=mpcb.p
#SBATCH --job-name=megsap-setup
#SBATCH --output=megSAP-setup.%j.out
#SBATCH --error=megSAP-setup.%j.err

module load git/2.40.1-GCCcore-13.1.0-nodocs
module load Mamba/24.3.0-0
conda activate megsap

MEGSAP_ROOT=$WORK/megSAP
MEGSAP_VER=1.0.0
MEGSAP_SIF=megsap-custom_${MEGSAP_VER}.sif
EXEC="apptainer exec \
    --bind $MEGSAP_ROOT:/megSAP \
    --pwd /megSAP \
    $MEGSAP_ROOT/$MEGSAP_SIF /bin/bash -c"

mkdir -p $MEGSAP_ROOT/tmp_$SLURM_JOB_ID

export LC_ALL=C
export THREADS=$SLURM_CPUS_PER_TASK
export TMPDIR=$MEGSAP_ROOT/tmp_$SLURM_JOB_ID
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

export SINGULARITYENV_LC_ALL=$LC_ALL
export SINGULARITYENV_TMPDIR=/megSAP/tmp_$SLURM_JOB_ID
export SINGULARITYENV_THREADS=$SLURM_CPUS_PER_TASK

export APPTAINERENV_LC_ALL=$LC_ALL
export APPTAINERENV_TMPDIR=/megSAP/tmp_$SLURM_JOB_ID
export APPTAINERENV_THREADS=$SLURM_CPUS_PER_TASK

cd $MEGSAP_ROOT

$EXEC "cd data && ./download_container.sh"
$EXEC "cd data && ./download_GRCh38.sh"
$EXEC "cd data && ./download_dbs.sh"
$EXEC "cd data && php ../src/Install/db_download.php"
