# megSAP custom setup

## Prerequisites

- SLURM cluster environment
- Git and Mamba/Conda modules
- Sufficient disk space (~200GB for databases and analysis)
- Access to `$WORK` environment variable

## 1. Environment setup

Load required modules and clone the repository:

```bash
module load git/2.40.1-GCCcore-13.1.0-nodocs
module load Mamba/24.3.0-0
git clone https://github.com/maurya-anand/megSAP-custom.git megSAP
chmod 755 megSAP/data/*.sh
cd megSAP/src/hpc_env
make create_env
```

This will:

- Create a conda environment named `megsap`
- Install required dependencies.
- Download the container image in the root of the repository: `megSAP/megsap-custom_*.sif`

## 2. Annotation Database setup (One-time Setup)

Modify the slurm directives to the `src/hpc_env/setup-db-job.sh` and submit the job:

```bash
sbatch src/hpc_env/setup-db-job.sh
```

This will download and configure:

- Reference genome (GRCh38)
- Annotation databases
- Pipeline dependencies

## 3. Analysis Setup

### Expected input directory structure

Organize your input data as follows:

```text
$WORK/test_data_megsap/
├── TruSeqPCRfree.ini          # Sequencing protocol configuration
├── WGS_hg38.bed               # Target regions file
└── Sample_SAMPLE_ID/          # Replace SAMPLE_ID with your actual ID
    ├── SAMPLE_ID_R1_001.fastq.gz  # Forward reads
    └── SAMPLE_ID_R2_001.fastq.gz  # Reverse reads
```

### Configuration File

**Example** `TruSeqPCRfree.ini`:

```ini
name_short = "TruSeqPCRfree"
name_manufacturer = "TruSeq DNA PCR-Free"
target_file = "WGS_hg38.bed"
adapter1_p5 = "AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC"
adapter2_p7 = "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
shotgun = 1
umi_type = "n/a"
type = "WGS"
build = "GRCh38"
```

### Running Analysis

Checklist:

1. **Adjust SLURM directives** according to your cluster and data size:
1. **Modify `src/hpc_env/analysis.sh`** to match your sample.
1. **Submit the analysis job:**

```bash
sbatch src/hpc_env/analysis.sh
```
