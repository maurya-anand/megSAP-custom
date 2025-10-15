#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --partition=mpcb.p
#SBATCH --job-name=megSAP-test
#SBATCH --output=megSAP-test.%j.out
#SBATCH --error=megSAP-test.%j.err

module load git/2.40.1-GCCcore-13.1.0-nodocs
module load Mamba/24.3.0-0
conda activate megsap

MEGSAP_SRC=$WORK/megSAP
MEGSAP_IMAGE=$MEGSAP_SRC/megsap-custom_1.0.0.sif
INPUT_DIR_ROOT=$WORK/test_data_megsap
EXEC="apptainer exec \
    --bind "$MEGSAP_SRC:/megSAP,$INPUT_DIR_ROOT:/analysis_dir" \
    --cleanenv \
    --pwd /analysis_dir \
    $MEGSAP_IMAGE /bin/bash -c"

mkdir -p $INPUT_DIR_ROOT/tmp_$SLURM_JOB_ID

export LC_ALL=C
export THREADS=$SLURM_CPUS_PER_TASK
export TMPDIR=$INPUT_DIR_ROOT/tmp_$SLURM_JOB_ID
export OMP_NUM_THREADS=$THREADS

export APPTAINERENV_LC_ALL=$LC_ALL
export APPTAINERENV_THREADS=$SLURM_CPUS_PER_TASK
export APPTAINERENV_TMPDIR=/analysis_dir/tmp_$SLURM_JOB_ID

$EXEC "php /megSAP/src/Pipelines/analyze.php -folder Sample_ERR3964718 -name ERR3964718 -system /analysis_dir/TruSeqPCRfree.ini -steps ma,vc -threads \$THREADS"

rm -rf $INPUT_DIR_ROOT/tmp_$SLURM_JOB_ID

# ##expected input structure:
# test_data_megsap/
# ├── TruSeqPCRfree.ini
# ├── WGS_hg38.bed
# └── Sample_ERR3964718/
#     ├── ERR3964718_R1_001.fastq.gz
#     └── ERR3964718_R2_001.fastq.gz

# $ cat TruSeqPCRfree.ini 
# name_short = "TruSeqPCRfree"
# name_manufacturer = "TruSeq DNA PCR-Free"
# target_file = "WGS_hg38.bed"
# adapter1_p5 = "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"
# adapter2_p7 = "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
# shotgun = 1
# umi_type = "n/a"
# type = "WGS"
# build = "GRCh38"