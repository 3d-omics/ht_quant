# Macro-scale Host Transcriptomics Bioinformatics
This is the repository containing bioinformatic code for macro-scale host transcriptomic data processing. This repository contains all the required information to reproduce the pipeline in any Unix-based environment with a [Conda](https://docs.conda.io/en/latest/) installation. The pipeline is built in [Snakemake](https://snakemake.readthedocs.io/en/stable/), and manages dependencies using conda (or mamba) for reproducibility and deployability.

## Getting started

### What this pipeline requires

This pipeline requires short Illumina paired-end reads (150PE) generated from RNASeq libraries. These are usually produced through poly(A)-enrichment cDNA conversion.

### What this pipeline does

Raw sequencing reads get adapters trimmed and are quality filtered using **Fastp**, before having any leftover ribosomal reads removed using **RiboDetector**. These ribodepleted reads are then mapped to the host genome using **STAR**, which outputs the unmapped reads, sorted BAM file, and count table.

### How this repository is structured

* The 0_Bin directory contains the snakefiles, scripts, and conda environment yml files that are required for running the pipeline.
* The 1_Data directory is were data are processed.
* The 2_Output directory is were the main results are outputed.

## Usage

The easiest way to implement this pipeline is to clone it to your environment and run it within the repository directory.

### 1) Install conda and snakemake

The only prerequisite for running this pipeline is to have conda (or miniconda) and snakemake installed. Miniconda installers for Linux, Mac and Windows operating systems can be found in the following website: https://docs.conda.io/en/latest/miniconda.html

### 2) Clone the repository to the desired directory

Go to the directory in which you want the repository to be cloned, clone the repository using `git clone` and enter into the directory. If the repository is private, but your Github user account has been given access to it, you first need to create a Personal Access Token on Github. From your Github account, go to Settings => Developer Settings => Personal Access Token => Generate New Token (Give your password) => Fillup the form => click Generate token => Copy the generated Token, it will be something like `ghp_sFhFsSHhTzMDreGRLjmks4Tzuzgthdvfsrta`. Then replace `{PERSONAL-ACCESS-TOKEN}` in the code below with the token code.

``` sh {eval=FALSE}
cd /home/my/desired/directory
#If the repository is publicly available:
git clone https://github.com/3d-omics/Bioinfo_Macro_Host_Transcriptomics.git
#If the repository is private
git clone https://{PERSONAL-ACCESS-TOKEN}@github.com/3d-omics/Bioinfo_Macro_Host_Transcriptomics.git
cd Bioinfo_Macro_Host_Transcriptomics
```
Note that all paths shown from now on are relative to the path of the repository.

### 3) Create a screen session

The snakemake pipeline will launch jobs to the server job queue as required to complete the entire task in the most optimal way. However, some jobs will be sent only when previous ones have completed, which  requires the session to be active while the pipeline is finished. To avoid disconnections to the remote server to interrupt the pipeline is desirable to create a screen session, and launch the pipeline within.

To create a screen session:

``` sh {eval=FALSE}
screen -S the_name_I_want_for_my_session
```

To get out from the screen session type `ctrl+A` followed by `D`.

To (re-)enter into that session:

``` sh {eval=FALSE}
screen -r the_name_I_want_for_my_session
```

To finish the screen session type `exit`.

### 3) Place reference genome in the repository

By default the directory in which the reference host genome should be placed is `1_Data/0_Genome/`. This can be modified in the `0_Bin/pipeline.yml` file if you would like the pipeline to use a genome stored elsewhere. Note that the argument `host_genome`in the `yml` file requires the directory where the genome is stored, not the file itself. Hence, the directory can only contain one genome. The required files per genome are the `fasta` file containing the sequence data and `gff` file containing the annotations.

The following code shows an example in which the [chicken genome galgal7](https://www.ncbi.nlm.nih.gov/genome/?term=gallus+gallus) is downloaded from the NCBI.

``` sh {eval=FALSE}
cd 1_Data/0_Genome/
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.gff.gz
cd ../../
```

### 4) Place raw reads in the repository

Raw sequencing reads must be placed in the directory `1_Data/1_Untrimmed` in order for the snakemake pipeline to recognise the input. The data files can be moved to that directory with the following code:

``` sh {eval=FALSE}
mv /home/my/data/*.1.fq.gz 1_Data/1_Untrimmed/
mv /home/my/data/*.2.fq.gz 1_Data/1_Untrimmed/
```

Alternatively, symbolic links can be created to avoid moving or duplicating files:

``` sh {eval=FALSE}
ln -s /home/my/data/*1.fq.gz 1_Data/1_Untrimmed/
ln -s /home/my/data/*2.fq.gz 1_Data/1_Untrimmed/
```

### 5) Launch the snakemake pipeline

Once the above-described steps are conducted, the pipeline can be ran using the following script. The script must be launched from the directory of the repository, as otherwise the relative paths will not work. Note that the `--cluster` argument probably needs to be modified to adjust to your cluster's setup.

``` sh {eval=FALSE}
snakemake \
-s 0_Bin/pipeline.snakefile \
-j 32 \
--cluster "sbatch --mem {resources.mem_gb}G --time {resources.time} -c {threads} -v" \
--use-conda \
--conda-frontend conda \
--latency-wait 600
```

The terminal should prompt something like this:

```
#> Detected the following samples:
#> ['SAMPLE1', 'SAMPLE2']
#> Building DAG of jobs...
#> Creating conda environment 0_Bin/conda_env.yml...
#> Downloading and installing remote packages.
```

The initial setup of the conda environment will take a while, as all the required software will need to be downloaded and installed in the system. If the conda environment has already been created in the system, then this can be declared as a `snakemake` argument to avoid repeating this tedious step.

``` sh {eval=FALSE}
snakemake \
-s 0_Bin/pipeline.snakefile \
-j 32 \
--cluster "sbatch --mem {resources.mem_gb}G --time {resources.time} -c {threads} -v" \
--use-conda \
--conda-frontend conda \
--conda-prefix /home/path/to/environments \
--latency-wait 600
```

If the conda environment already exists, snakemake will directly start processing the data, and will prompt something like this:

``` sh {eval=FALSE}
#> Detected the following samples:
#> ['C001aHc1_FKRN220332010-1A_H3JY3DSX5_L4', 'C002aHc1_FKRN220332011-1A_H3J2FDSX5_L1']
#> Building DAG of jobs...
#> Using shell: /usr/bin/bash
#> Provided cluster nodes: 32
#> Job stats:
#> job                  count    min threads    max threads
#> -----------------  -------  -------------  -------------
#> STAR_host_index          1             48             48
#> STAR_host_mapping        2             24             24
#> all                      1              1              1
#> qualityfiltering         2              8              8
#> ribodetector             2             24             24
#> total                    8              1             48
#>
#> Select jobs to execute...
```
